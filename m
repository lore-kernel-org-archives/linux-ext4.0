Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45716C282D7
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 16:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E231121B69
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 16:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="sFRZc3R+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfBKQyA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:54:00 -0500
Received: from mail-eopbgr760120.outbound.protection.outlook.com ([40.107.76.120]:39680
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfBKQyA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 11:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8mbHE9wotuVLuogHueGIS2pk1s8Wn6Pzk3RuIkHkEU=;
 b=sFRZc3R+fxh0VxI30r/mYGEzTqM94bsIkbOICUdrUVwyHfjTHJi0xs4Y7a0fhipcf8E9SwmM/73c5/HtYvY30II1GyVC7ekoDCvY2aqmjEbxl9idT20d33ll1P9Lxmpz5gQ8AP0BJJrsEXerbL9shf5ottWQqL6uAOJFE7dQbqQ=
Received: from CY4PR0101CA0011.prod.exchangelabs.com (2603:10b6:910:3c::24) by
 DM6PR01MB3753.prod.exchangelabs.com (2603:10b6:5:82::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 16:53:55 +0000
Received: from DM3NAM03FT062.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::204) by CY4PR0101CA0011.outlook.office365.com
 (2603:10b6:910:3c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 16:53:55 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT062.mail.protection.outlook.com (10.152.83.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 16:53:55 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1BGrrEc031693
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 11:53:54 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E3DEC7A47F7; Mon, 11 Feb 2019 11:53:52 -0500 (EST)
Date:   Mon, 11 Feb 2019 11:53:52 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
CC:     <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/2] e2freefrag: fix memory leak in scan_online()
Message-ID: <20190211165352.GA10996@mit.edu>
References: <20190115134203.11448-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190115134203.11448-1-lczerner@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(136003)(39860400002)(2980300002)(199004)(189003)(103686004)(356004)(8936002)(106466001)(229853002)(246002)(2906002)(97756001)(558084003)(33656002)(88552002)(316002)(8676002)(75432002)(42186006)(36906005)(786003)(46406003)(16586007)(26826003)(58126008)(478600001)(6266002)(52956003)(305945005)(47776003)(6246003)(26005)(186003)(86362001)(76176011)(336012)(6916009)(90966002)(4326008)(23726003)(50466002)(11346002)(446003)(476003)(486006)(126002)(2616005)(1076003)(36756003)(106002)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB3753;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT062;1:D3pEeisMPqKvD9Ie/qrzAgIXZ8CSY/910/wCTFq8NX8WRMALDlwlNYDhAy8ZvgfTXwXsbNDdxHp3Nz+PhJvhq7rvDyAlS80gJueL1rYY1MYVkaVD/kuiujlYPLmJEeXqVom3btoTOuEdyTQ6AHtz43WrzBMiR5zayIMiU9Lx4PM=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98676c57-197f-47c0-c0ff-08d69041824a
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB3753;
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;3:EQrUNJ5LA1rLXwK3mvcay0XSZ9cWfZaZrAOevn+seJDZ5110wk/ELzt7LA/khshjJfjzI99CcAWPj/Z3793VRd0hfmqM62vqzJaiiX9JDALPt4UrwV73gdWjBkCMpiwmgR4uZC1rCIHAr3qCNePcUpld+o+5n16//CgAZtTnM8zMgTgvxsE4XJtRkVNr83MQ8+B3CB0TPGhslMRwGoCP42IFNfr1rroPHYPIe3OR2PzHlSAbNdFQ6+UNSz2vGktGLPuNxL+QxhjAlx02L7QJKZRPYm9gmqXQCcI79VIbFKyc5/yrv1f7Dfiu+fawtKfh6jw1N3XFvrWb5e1Fhx8O1W/edQO/nEcsgXB/jS54xDuR1nYPyLKvvjLc5b6NrEGz;25:JNlNXrONZEtJoapGImgXXX0t07hS6pTmlR6r9zAtdSGY7Amo1FpDoT73oXoiRqjaWiteTpRRbEH6A5Dgvo1PuMpeOdENBTnDFzB/IS7H5RQksFX93L6Aj7jjZcXFOQnm450EvC4M79Y4IAOy0OhPKSQvCkD4zGqGGTVkVKEbTUBNJ6Cu7eeP5GgZOA/WCxbAT7osUD/GDtc4A8jnGSosiZNONL5pPl/76fVQlIbYngyEW3ncb15Bu13jGGJ0e+p+pHRFcJVeeTgWJuIwahN/VRGKI3i3w26pbH6ARB9UFUoC9xHB1x4v+3wzptGqhSpdI0bkbOBRup/rnfdBcQM/rg==
X-MS-TrafficTypeDiagnostic: DM6PR01MB3753:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;31:TqnHIZ72HTSLJr6+wgfSilURnRFrN/yhJsYu2aZPXrN9leNlVIaxV0gDHEmgkAbDqBgMjAf6/MmPA2xVn7KNF6MLDnMQXFFNnP8WP3ubkJvjc+Y8gm6miwd5hQemRPkC8RBJMmpPtzwVpi3uif4ngNvO16JeD6sOQMMDbpR7VBskqWNr1iAVrxVfU+zW7GjfqvgWOUvTxLZxgOC1AB0YerxkQbSl6s/VhMHYjAMoi+w=;20:fSt9SztvQPZNuNFK9YegruS6+NMDuh0Yc9hUNthrtRh8GyGerjyYScymXl5fez70XotrkULChr1g9w8vnG7JEqT+FtouxmYe9m9bBCRs95C7w6VO1bUxHV9+A6AqSyhC0TwAD50ZJRnyDHSdckHFXMDgQiQ8DmAKYRElQ1ujVhyI+wRwkOEnmA0r9GAUqpJfHjSpMcOWvSr7u7Ur00iErOiR2sbs6Bu38JotzZY3JNSJF8UNi77yWJ99ZCUK8Ha3Yecdf0OVjUvotx0q4EoDBQTs+tsP0RIx+UQV9xsWCL7GUToN8ggyb01x55V9DSUrEBtd5u5sYDyowaQI2/maocLHS7Q+200EkAaVq3ApCY6799mR8TsZuwC2GgNiESImJi6En1/GQkoLvGHU9CKTyx3vZwGVzAfwYYD1sOoVCKRmvWz4u/o7/pONWly09BbqPX+FP4lDwyUwPIrdiGF1CILCr5LpP4XNAIC9x0gk2IG4xzZg3hDM9Py/BEf5ANNT0UyJxAHLEOwicOO1SbfLMk+kECAi7gCh70q08W1S0JX08baDwy0EiTsxjyP4P66Me4Xh7+C8fNJk/MATDMjI7LHcapKQGkbtTtxLBHWRJuE=
X-Microsoft-Antispam-PRVS: <DM6PR01MB3753788E25F7291427F61DA0B5640@DM6PR01MB3753.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;4:5FVlH1X3oOSALIMXQTZ5Fov51HAu0KJdRMMmnTDY8l1O7mpGVGBvAOkLIYmfE0G8VpA6KwVLlhWRIDwUrLpSK+aYgSLx7sgey5oFR8FPcXdBzMmFBDwPRRPwS6lowL7dDjj9OdGLLR7nutbTW1fT4AV5CHFvarwZHnDr1wNbOx8tLuP2amZsV0hyCRt25z/e56sURvH/G72UasRzMT5OGuGn7kUNEafVQkCjqVilSYLuch267+yXINJT7iaLjsFos9DuFWPSKOnoB1G/fozgUNlMFHu3t3lVQzudzKqMYkM=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB3753;23:BJ1WsHMxfCA+Hr//lEWuf6m/7coR4Pb2mCLb7otnP?=
 =?us-ascii?Q?CySuGs1tjw4ADe+DB6Yb+4SwLvytAse9S4TIqxr5lWj6GbkYngAIBTHBdwad?=
 =?us-ascii?Q?cErhh2tk/40nsBsPpwAwTOOQiXfE5jO8BtN3RXw+kThShEss/Hw47i+JDKfO?=
 =?us-ascii?Q?vBz4XmZ+Gj1xpLIU+lwaheUhrqt0VwY5de/2AnNZbHxg+tbFE4Ydvoj9YylJ?=
 =?us-ascii?Q?ZxY9fymZ7LUsxparwP9oW0mTl1bM++zSmUdN3GIYGG+oSmRD+FiXaVP8sXzn?=
 =?us-ascii?Q?SHvGoMbcgzGM3SScbz6b2P6jCqgTV3ws2GU7H8h87/ZTGPAeqz/6/6gl+LYD?=
 =?us-ascii?Q?mk0BzToc0E5qf++F/odrhnt2WwMtul6iMXANYPQKiwCk5uWe3QI9hWHGkwjs?=
 =?us-ascii?Q?8iVtyGpYv1zenpCHYbn1DRcenDah+9iSXApLlV8KpIRNQsNNNBz0bGCbFZJw?=
 =?us-ascii?Q?m7o+dvDhtLKN/eTxKu9ByZIrAeyqpRJQvJoNfnLctgIh/fsIPYH2QSdecdLS?=
 =?us-ascii?Q?RwKi9lEAdiyHuzKIi/ubLe8hcLJMBEdCktvzDZRMtlgW23W7Vdk2FCKHN/dO?=
 =?us-ascii?Q?yy36ys46hkkEadhUUUIpOoCL/D2kn4dKeqMU8pyG68OLMjKUs9tz7P1zDkO8?=
 =?us-ascii?Q?1J7sJ9AtkVjf4SgONG+HeZKL4FlndSpCeTfYXXO9ZqgwmWodimpeKlsZWQQ+?=
 =?us-ascii?Q?G9+Asa3Mu71vHhunKEZ8We5TAxh4ZnF5po3atNqiMr1vxuQoXDlird7Uz6Oi?=
 =?us-ascii?Q?kJBaqx5rwKfxX40tqyo7hEzgJgJKvkIbs+Gkaq4dbN3mx2/PhGM3+GWowHVl?=
 =?us-ascii?Q?pC6RP+iIyiC0LwOjUJiHqUFI6OZzmPB4UceLaOTI8afPj6lT7lmu7452b6qU?=
 =?us-ascii?Q?6uMWtk+ozzt0TxvRdmcbK+o2ixQfE9Z50/xDHokUbym3nGA+BCOMBPgEOy3E?=
 =?us-ascii?Q?lPmsnIvuOeK5YTn/KIRCwaJJ45I4ad3s4x5G1Rsuiwn3LDTyVwWZ9mDbxYbm?=
 =?us-ascii?Q?JLU+XfHiqZdtdSTtzEKGYgQiDYeFTtlC5Ro/rBDfAZ3Atmf48X0LPo/KNnsD?=
 =?us-ascii?Q?sSvvoiH8ofC8hDqGchgmvCCUZF4t2L/eZWWaqW0tQD775ZTpbBn1MuVZ2e50?=
 =?us-ascii?Q?iPXkcOCrqIoxC/RmrkknbWK5VE/+6B+GTg3gEoI4YNzkY4foKAEoh8xDFffP?=
 =?us-ascii?Q?xn2mWveaBKcmMFbg0XV6VnmCRkH6AVj3xQnZNjJ2NkZNtNLniId9nl5aA=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Lio2+/SI5Nu99PDw7Fp9bxSDRKtxfE982jcr+9n5m7LJI+ItQdq5wCSj5FmSXrgQ3SdjW//Oresy2vIEduP4QEhf5BAPE0XkOf9qyHjSakm8XUTklZBa6p/uhtKBV5JknsM2t8wxRQwaaX8iuDaFXjZoDWvXzcMUs/b/jYzHJ2NC0vR3mfjqm7xyqzLRehJSekn9tAmpp3ZEbDZRXxt9MuWv95zLxNJ0Mu1AynFWlkanD/RBXm4lXKbNifLEtvFgr/QjwiERuwEWlf4hEeN3pEAfakdWfM1+mEurAgYHdwQPhShLBbmIUSwQFKlMxDMKUpAL+tnbAm15BjlmhVzynILXkK7v7i6bx3iO44qiuetjKZCANVc5rSgw3rMBw3QmCIKCnOdbPrA8hHlgwp8XZzR15H8wLIiNQQ2rM1jrJCY=
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3753;6:cmTbCuvqPHvRmbG43yaXR4820qDummxA/9yiCqfnolC4gov2V6vF8j4EhMnDEID5qXouT9grJwdhQtnoMi0FEQV1yfh8fcLxITZOhfxbo5tPPWzXWIVcv67Er+YZhp2WZCs9FdxAO1RIoEu0qZJljEZPh464bBcdbQb9SAaSwVweqioxdzDwq9lqPviAYkZJVPkDyiLybfEqBcBYjKMqYxIMuRAQbyPcLCrUdn15H4w/KpMOu6J8bZAgjTGbER3/sWt+UV6x878895JG40fhXz1zKQSEVoP8L+JkWnSIlYGdIej1u9rCW07FPVXB9bJy6dCV4Zz+PNYdGXh+1/Sw4S6tmt9DysDN9X0lL1N6rkMrIk7Vw4hdCfR4gs8uayW31H1Dj5V89Ab0VJzNn4M4R2U7uJTrDzS75SKzkzNH4O1rBxKPhf++AYXSZ+pNUYOHXvepkbEaTDylMf3rwzr1wQ==;5:hRJhtRpl4XiYqlcBI4VBdB06SFZP4rpP3klnXh8eWCMNWsDHRw3hnfSfCr/DI239lKyw1XbrjYZbAcmirNCpdTk0B5tINRi7SQadxhBXQafpmQXOAPmVsOeoyRQrLw2blcUg4TlJnk2nhv+ju6rFTYtZ+YUzGYzuPvLMcFnnf/ekkHrbzzTQt4bUyEXeI1A34Pb/yHqsnw/AcUekQVYNZA==;7:/BOneTjiiAOm8x91SsYRm3jIlGgJcGUBowmVr6w1QYrTBoCIG1eG0RWueNIOeVJsGLRAL2KdGZ1ZZ2ksHPDMVklyPxwytmqzhtS2DFEIP5QXAkjcu0sc6JzEpjpoA8FBAJ0u3rOYYkjh4WynS4zSuA==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 16:53:55.0142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98676c57-197f-47c0-c0ff-08d69041824a
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3753
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 15, 2019 at 02:42:02PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
