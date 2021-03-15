/*!
 * \brief Mapping protocol for PACE domain parameters. For details see TR 03110.
 *
 * \copyright Copyright (c) 2014-2021 Governikus GmbH & Co. KG, Germany
 */

#pragma once

#include <QByteArray>
#include <QSharedPointer>

namespace governikus
{

template<typename DOMAINPARAMS>
class DomainParameterMapping
{
	public:
		virtual ~DomainParameterMapping() = default;

		/*!
		 * \brief Generates the terminal's mapping data, that will  be send to the card.
		 * \return the terminal's mapping data
		 */
		virtual QByteArray generateTerminalMappingData() = 0;

		/*!
		 * \brief Generates the ephemeral domain parameters.
		 * \param pCardMappingData the card's mapping data
		 * \param pNonce the nonce that was generated by the card
		 * \return the terminal's mapping data
		 */
		virtual QSharedPointer<DOMAINPARAMS> generateEphemeralDomainParameters(const QByteArray& pCardMappingData,
				const QByteArray& pNonce) = 0;
};

} // namespace governikus
