Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB232C43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 17:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8211020661
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 17:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="FLTxvStL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfCFRGr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:06:47 -0500
Received: from mail-eopbgr730093.outbound.protection.outlook.com ([40.107.73.93]:54644
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbfCFRGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 6 Mar 2019 12:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7VVT04x0pw2pwqe7BntNcKNsU+nlCIx3qfAtiQcCrU=;
 b=FLTxvStLiVFGLB3IcrKyMCwUJyQdKqQnD/UTa5bA0F1PLTByiCaS2udLCGB3iV8M1W3vuxUQBg4yY+yDrSM+FjexxETvG2wPgkbNDGpds75gi4PFMj4Bi+SsY+/4I+ZMsa4bRtMt/B683ZyQlNGoEeDKZfqgUCYFIpLOTgix2fE=
Received: from CY4PR01CA0009.prod.exchangelabs.com (2603:10b6:903:1f::19) by
 SN6PR01MB4991.prod.exchangelabs.com (2603:10b6:805:c8::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1665.18; Wed, 6 Mar 2019 17:06:42 +0000
Received: from BY2NAM03FT046.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::201) by CY4PR01CA0009.outlook.office365.com
 (2603:10b6:903:1f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.19 via Frontend
 Transport; Wed, 6 Mar 2019 17:06:42 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT046.mail.protection.outlook.com (10.152.85.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.13 via Frontend Transport; Wed, 6 Mar 2019 17:06:40 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x26H6cWu009341
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 6 Mar 2019 12:06:38 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0FC627A3F4B; Wed,  6 Mar 2019 12:06:38 -0500 (EST)
Date:   Wed, 6 Mar 2019 12:06:37 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Artem Blagodarenko <artem.blagodarenko@gmail.com>
CC:     <linux-ext4@vger.kernel.org>, <adilger.kernel@dilger.ca>
Subject: Re: [PATCH v7 2/4] e2image: add -b and -B options to use supperblock
 backup
Message-ID: <20190306170637.GB3485@mit.edu>
References: <20190129175134.26652-1-c17828@cray.com>
 <20190129175134.26652-3-c17828@cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190129175134.26652-3-c17828@cray.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(136003)(2980300002)(189003)(199004)(2616005)(88552002)(2906002)(36756003)(305945005)(33656002)(316002)(26005)(76176011)(786003)(6266002)(46406003)(50466002)(47776003)(26826003)(229853002)(54906003)(8676002)(23726003)(186003)(6246003)(97756001)(6916009)(52956003)(86362001)(336012)(486006)(478600001)(126002)(103686004)(446003)(246002)(11346002)(42186006)(106002)(356004)(5660300002)(4326008)(75432002)(106466001)(476003)(90966002)(1076003)(58126008)(4744005)(16586007)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB4991;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff76e708-aebf-47e4-f191-08d6a2561ae1
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:SN6PR01MB4991;
X-MS-TrafficTypeDiagnostic: SN6PR01MB4991:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB4991;20:VQpulktCa08eBPKechpzntzuzIWcDEV3sOO5h3i+6Tny4nP5cXuaSzT2T7RKZRBCceXThNroinCVZ4RvhOGs2IL1ov4/O/sSc5IE8w2Ha4AbMPDsPleDkAEgDC/r5INocsY5HYcB/fu+6kg7r4/mK1nFiWmxhet/h9nkCRHY/RE1aTk712JCb5wJmPzhXhohAR8YLhhSRttRBIxNIjfbVV0ZrS51S9jRUivCalZzi6gjRQqadukSrfq+a2JP/LskiZe9prR25mod2K8b2WXvjbe5E6EzmpWpn59BZyvlaa6Tc+NxW8LzALueDzckMKx0fvKqsxtpzDGKDG//59f8d1rOzrDhcDVE41BfixHT4lNFn164+ARxZf5FDKeAnRePGinYPnbPO4uIXT++FVNaOOZ6ZAD8zWaU4zMBN8QmsGhXu1nn9gtWdyTJ1EAM1tvU0QHxt0WxVe5K89bNCkNGc6drZs6UubwxLaINiB5kWOcJW648dJOMO1xNx1j4fDPQdBF5Q0A8k2VnPJf2wyTPiBWWb03GmXwJkljZ/+LvIxnsqwSxhXVICswDKlI5afYufj3fFJI67MQ1eCngxRyLGH5Cr/nBvGJDrdnJ7Bvli/M=
X-Microsoft-Antispam-PRVS: <SN6PR01MB4991D7B4C08D40DE379A109AB5730@SN6PR01MB4991.prod.exchangelabs.com>
X-Forefront-PRVS: 0968D37274
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB4991;23:bTSZQM1L8E8tWuq1dFXx8hZMA4vDKoyoXKZ1cEMpT?=
 =?us-ascii?Q?kFQkphrXqlpgko1bCoPRITXJF5aDAoRfNCk++yPmOxrh5qfluFKpQsD/KUTc?=
 =?us-ascii?Q?3P6uVrx5mx1e1pXwJpAOkeUjb9qQFpzGHLKdCmYkN+yIvFRUsg6EijtNNg3+?=
 =?us-ascii?Q?wjD8x7+QODVvddccLkMQqt36Tr4BxhjIfNIdEjOo/nA8N11XZbYc75mQcjiZ?=
 =?us-ascii?Q?2GRTlit8FYf6XiUUO2gLqjFN/PCxE4JVcRrCyEl9W4E9Xtl4XEjaqt+Dx2XR?=
 =?us-ascii?Q?sdrmT80rH5hGEuRAxm4ByibRW8ThmJTtJFe8KyG8zl5P+R1KBDA+Hk4f9jDY?=
 =?us-ascii?Q?/1BqDzj95DccwCr9L2s9EZ/cDk6ZKHmToPEAC84++BedwVnh2U/Baumg0PoN?=
 =?us-ascii?Q?PhFKsTrGcbFGLILgv7T6HSQPRZG2VnQ0vMBGONWbDLNkB02OqEJBJVxw9ZXI?=
 =?us-ascii?Q?yasMP0R+e3SR57F2PfyGmEIl1ci/uO1nOvSFmpAwStsjQo7wfktx/72aq490?=
 =?us-ascii?Q?JjLF7+Gm/pyAH7JI6vg4AuAuptvLeqvJSHwFmrTZkUlvAmDQDWrILDKyafk6?=
 =?us-ascii?Q?PywJB/8dCs90RB+ks2bo2099rYuXG4sxmEb6tIyJvCAbJG3cwWg3ayvfOiaD?=
 =?us-ascii?Q?1isBL7YGeCh09L0OLco2ce6+tOuA+br4fjMF0UQoxJkSLp2nevH9veA4YrBQ?=
 =?us-ascii?Q?UcZPAAV74y08xn3zFpYdybmCIAEPVnwbmNF3sx0U02M7QUxHM+Tm1PtFPkbZ?=
 =?us-ascii?Q?xc6ARaTFmTPCMliR6Qfp1u7G9lLfLob4kzC8AK6m1DQoRB+kR6xJp3pBDwsi?=
 =?us-ascii?Q?/WFR81uyjYDSVbjn+P19UHl17hqG7sBus0K7b+Y1nw/yJauitOcdNwVLkJjP?=
 =?us-ascii?Q?visy91PTwhebSVP1bXpK4iFYCDRc0tGAu/xppjQf3qDy+HwQ0t41JKwOQTpf?=
 =?us-ascii?Q?nqc0Zmaw34Hs+PfvsY6LDxZo0ZHZpiir95ldyNDb/jh7LdPvVUJjkkb3/qfK?=
 =?us-ascii?Q?VdFK/bOOCTTzEZCF98uMiNrJTix0IIL6m2Xe3FxeqowjiBTHD+rkDQVyjreo?=
 =?us-ascii?Q?7f/kxtEAPY6G0J0SxW0Kb+8F2vmi1Q7oaB7GjIAyrn236k2A1xLK2YtMUJsw?=
 =?us-ascii?Q?oNON68wQpugd+NoyzVNw4KJWbwQDvMWysOwsg8jH25NyiEF0HzRV7WAY/6vG?=
 =?us-ascii?Q?r0dAk3PgrDgm/tebHZ6oE1ut5YhT1gS5+KZ?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CxHLpFfGh11qmktUmWmpgQoxtgw+NyvQyyxQs/1dpPCF49b9dVGcnDweVZgUUNIuwD1wo35RYkv3PJVg4DuvIs+Xq8At+l+oglbyKhGiFS0vPlbO6Rg9ofq+U3Ohgf15oUZ3/bZNXH9Ska5Cl2YpH/vuslWaTFMZnmrNC6vqP+eq3+Dfto4aTHzSKO15oJhcS37GP7xRPkRA5UxTnqVevHehJDvwXn1oKC+9UIJhABwqFUde7WVXzVoeAvKZf0U+LV2LZshDMYsg1lchK3ZeU2qmiQMO5LLDHvzm+/sZFlqb0HDQh0fyzAdakVKuJd42gNT1V2tGxxEVdHnSCWdETEKKpUCXv4l4ibbkrEuUucs3k/uBgxpRjl8cFE7gb53ZtHXORFriAd9WTMsus9/gIuaxrh2+FSGJsbaCWTAlj7Q=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2019 17:06:40.3100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff76e708-aebf-47e4-f191-08d6a2561ae1
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4991
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 29, 2019 at 08:51:32PM +0300, Artem Blagodarenko wrote:
> e2image has no ability to use superblock backup to copy metadata.
> This feature can be useful if someone wants to make partition
> image and fix it using e2fsck utility.
> 
> New -b option allows to pass superblock number, like e2fsck utility does.
> e2image doesn't change primary superblock and store it as is, so
> it can be fixed using e2fsck latter. Option -B allows setting
> superblock size.
> 
> Signed-off-by: Artem Blagodarenko <c17828@cray.com>

This change is independent of the first patch, so I've applied it,
thanks.

						- Ted
