using RiskService from './risk-service';

annotate RiskService.Risks with {
	title       @title: 'Title';
	prio        @title: 'Priority';
	descr       @title: 'Description';
	miti        @title: 'Mitigation';
	impact      @title: 'Impact';
}

annotate RiskService.Mitigations with {
	ID @(
		UI.Hidden,
		Common: {
		Text: description
		}
	);
	description  @title: 'Description';
	owner        @title: 'Owner';
	timeline     @title: 'Timeline';
	risks        @title: 'Risks';
}

annotate RiskService.Risks with @(
	UI: {
		// HeaderInfo describes the key information of the object, which will make the object page to display
		// title of the risk as title and the descr as subtitle in its header area.
		HeaderInfo: {
			TypeName: 'Risk',
			TypeNamePlural: 'Risks',
			Title          : {
                $Type : 'UI.DataField',
                Value : title
            },
			Description : {
				$Type: 'UI.DataField',
				Value: descr
			}
		},
		// SelectionFields section defines which of the properties are exposed as search fields in the header bar
		// above the list. In this case, prio is the only explicit search field.
		SelectionFields: [prio],
		// The columns and their order in the work list are derived from the LineItem section. While in most cases
		// the columns are defined by Value: followed by the property name of the entity, in the case of prio and
		// impact there’s also Criticality. For now, you can neglect it but keep it in mind in case you go to the later modules.
		LineItem: [
			{Value: title},
			{Value: miti_ID},
			{
				Value: prio,
				Criticality: criticality
			},
			{
				Value: impact,
				Criticality: criticality
			}
		],
		// Next up is the Facets section. In this case, it defines the content of the object page. It contains only a single facet,
		// a ReferenceFacet, of the field group FieldGroup#Main. This field group just shows up as a form. The properties of the
		// Data array within FieldGroup#Main determine the fields in the form.
		// Criticality: This property is used in OData annotations to control the color of some of the cells in the table of our work list page.
		// see risk-service.js
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: 'Main', Target: '@UI.FieldGroup#Main'}
		],
		FieldGroup#Main: {
			Data: [
				{Value: miti_ID},
				{
					Value: prio,
					Criticality: criticality
				},
				{
					Value: impact,
					Criticality: criticality
				}
			]
		}
	},
) {

};

// The line Text: miti.description , TextArrangement: #TextOnly, declares that the text from the description property is displayed
// for the miti association. Then it adds a value help (ValueList) for that association, so the user can pick one of the available
// mitigations when editing the object page.
annotate RiskService.Risks with {
	miti @(
		Common: {
			//show text, not id for mitigation in the context of risks
			Text: miti.description  , TextArrangement: #TextOnly,
			ValueList: {
				Label: 'Mitigations',
				CollectionPath: 'Mitigations',
				Parameters: [
					{ $Type: 'Common.ValueListParameterInOut',
						LocalDataProperty: miti_ID,
						ValueListProperty: 'ID'
					},
					{ $Type: 'Common.ValueListParameterDisplayOnly',
						ValueListProperty: 'description'
					}
				]
			}
		}
	);
}
