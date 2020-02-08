script_name = "Timewarp"
script_description = "Stretches time"
script_author = "Joshua Walsh"
script_version = "1.0"

field_height = 1
row_height = 2
label_width = 10
field_width = 20
form_fields = {
    {
        class = "floatedit",
        name = "originalA",
        label = "Original Time A"
    },
    {
        class = "floatedit",
        name = "newA",
        label = "New Time A"
    },
    {
        class = "floatedit",
        name = "originalB",
        label = "Original Time B"
    },
    {
        class = "floatedit",
        name = "newB",
        label = "New Time B"
    }
}

dialog = {}
for k,v in ipairs(form_fields) do
    i = k - 1 -- why can't Lua be zero indexed? :(
    dialog[i*2] = {
        class = "label",
        x = 0,
        y = row_height * i,
        width = label_width,
        height = field_height,
        label = v.label
    }
    dialog[i*2 + 1] = {
        class = v.class,
        x = label_width,
        y = row_height * i,
        width = field_width,
        height = field_height,
        name = v.name
    }
end

function timewarp(subs, sel)
	row_height = 2
	proceed, results = aegisub.dialog.display(dialog)

	if proceed then
		originalDuration = results.originalB - results.originalA
		newDuration = results.newB - results.newA

		for _,i in ipairs(sel) do
			local line = subs[i]
			line.start_time = (line.start_time - results.originalA * 1000) / originalDuration * newDuration + results.newA * 1000
			line.end_time = (line.end_time - results.originalA * 1000) / originalDuration * newDuration + results.newA * 1000
			subs[i] = line
		end

		aegisub.set_undo_point(script_name)
	end
end

function check_minsel_1(subs, sel)
	return #sel >= 1
end

aegisub.register_macro(script_name, script_description, timewarp, check_minsel_1)
