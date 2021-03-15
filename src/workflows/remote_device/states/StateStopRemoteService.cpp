/*!
 * \copyright Copyright (c) 2017-2021 Governikus GmbH & Co. KG, Germany
 */

#include "StateStopRemoteService.h"

#include "AppSettings.h"

using namespace governikus;


StateStopRemoteService::StateStopRemoteService(const QSharedPointer<WorkflowContext>& pContext)
	: AbstractState(pContext)
	, GenericContextContainer(pContext)
{
}


StateStopRemoteService::~StateStopRemoteService()
{
}


void StateStopRemoteService::run()
{
	Q_EMIT fireContinue();
}


void StateStopRemoteService::onExit(QEvent* pEvent)
{
	// onExit: Stop if the user cancels the workflow, too.

	const QSharedPointer<RemoteServer> server = getContext()->getRemoteServer();
	Q_ASSERT(server);
	server->setPairing(false);
	server->stop();

	// Request an asynchronous update of all retry counters
	Env::getSingleton<ReaderManager>()->updateRetryCounters();

	AbstractState::onExit(pEvent);
}
