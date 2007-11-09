setupQuestionnaireEditing = function(questionnaireId, pageId) {
  this.questionnaireId = questionnaireId;
  this.pageId = pageId;
  Resource.model("Page", {prefix: '/questionnaires/'+questionnaireId, format: 'json'});
  Resource.model("Question", {prefix: '/questionnaires/'+questionnaireId+'/pages/'+pageId, format: 'json'});
  Resource.model("QuestionOption", {prefix: '/questionnaires/'+questionnaireId+'/pages/'+pageId+'/questions/:question_id/', format: 'json'});
}.bind(this);
                    
function updateDefault(questionId, newDefault) {
  el = $("question_" + questionId + "_default_answer");
  el.value = "Saving...";
  el.disabled = true;
  el.newDefault = newDefault;
  Question.find(questionId, {}, function(q) {
    q.default_answer = el.newDefault;
    q.save(function() {
      if (this.type == 'checkbox') {
        this.checked = this.newDefault;
      } else {
        this.value = this.newDefault;
      }
      this.disabled = false;
      new Effect.Highlight(this);
    }.bind(this));
  }.bind(el));
}

function updateDefaultForRadioGroup(questionId, newDefault) {
  if (newDefault == null || newDefault == "") {
    buttons = $$("input[type=radio][name=\"question["+questionId+"][default_answer]\"]");
    for (i=0; i<buttons.length; i++) {
      if (buttons[i].checked) {
        buttons[i].checked = false;
        button = buttons[i];
        break;
      }
    }
  } else {
    button = $("question_"+questionId+"_default_answer_"+newDefault);
    button.checked = true;
  }
  button.newDefault = newDefault;
  
  Question.find(questionId, {}, function(q) {
    q.default_answer = this.newDefault;
    q.save(function() {
      new Effect.Highlight(this);
    }.bind(this));
  }.bind(button));
}

function reloadQuestion(questionId) {
  new Ajax.Updater("question"+questionId,
                   "/questionnaires/"+questionnaireId+"/pages/"+pageId+"/questions/"+questionId+";edit",
                   { method: "get", evalScripts: true });
}

function makeReloadFunction(questionId) {
  return function() {reloadQuestion(questionId)};
}

function addOption(questionId, newOption) {
  el = $("question_"+questionId+"_add_option");
  el.value = "Saving...";
  el.disabled = true;
  el.newOption = newOption;
  el.questionId = questionId;
  QuestionOption.create({question_id: questionId, 'option': newOption}, function() {
    el.value = "";
    el.hide();
    reloadQuestion(this.questionId);
  }.bind(el));
}

function removeOption(questionId, optionId) {
  QuestionOption.destroy({id: optionId, question_id: questionId}, function() {
    reloadQuestion(this);
  }.bind(questionId));
}