/*
 * \copyright Copyright (c) 2017-2021 Governikus GmbH & Co. KG, Germany
 */

import QtTest 1.12

TestCase {
	name: "ModuleImportTest"
	id: parent

	function test_load_SettingsView() {
		var item = createTemporaryQmlObject("
			import Governikus.SettingsView 1.0;
			SettingsView {}
			", parent);
		item.destroy();
	}
}
