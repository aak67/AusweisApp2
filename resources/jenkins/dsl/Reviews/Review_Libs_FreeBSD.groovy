import common.LibraryReview

def j = new LibraryReview
	(
		name: 'FreeBSD',
		label: 'FreeBSD'
	).generate(this)


j.with
{
	steps
	{
		shell('cd source; cmake -DCMD=IMPORT_PATCH -P cmake/cmd.cmake')

		shell("cd build; cmake ../source/libs -DCMAKE_BUILD_TYPE=debug -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DPACKAGES_DIR=\${PACKAGES_DIR}")

		shell('cd build; make compress')
	}
}
