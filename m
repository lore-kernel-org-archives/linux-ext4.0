Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1CEC4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 15:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9595220823
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 15:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="cvlt0b77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfBUPwc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:52:32 -0500
Received: from mail-eopbgr720101.outbound.protection.outlook.com ([40.107.72.101]:56750
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbfBUPwa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 10:52:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozRxzMurU21w48JYprR849vMNJMRBbFGSCgknsgpXk0=;
 b=cvlt0b77vLDw4LntM0K6Wpmsm4SYqoHL1BsejUNWyhnlazfzorsWIcd6c3TWP83Jt4czvleGbOccr+Aibr79InDOnjxNKqciHA+1A8Kxnlswlymgra19XLCMaGXf2FVV5aucjJhujv3eZfTSxLyJPE6Igu8pakPblhj3sKl/9Yw=
Received: from DM5PR0102CA0007.prod.exchangelabs.com (2603:10b6:4:9c::20) by
 DM6PR01MB3995.prod.exchangelabs.com (2603:10b6:5:92::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.14; Thu, 21 Feb 2019 15:52:22 +0000
Received: from CO1NAM03FT059.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::206) by DM5PR0102CA0007.outlook.office365.com
 (2603:10b6:4:9c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1643.15 via Frontend
 Transport; Thu, 21 Feb 2019 15:52:22 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT059.mail.protection.outlook.com (10.152.81.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 15:52:22 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LFqJDb025351
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 10:52:20 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id BD4F07A3F79; Thu, 21 Feb 2019 10:52:18 -0500 (EST)
Date:   Thu, 21 Feb 2019 10:52:18 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Mathieu Malaterre <malat@debian.org>
CC:     Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ext4: annotate implicit fall throughs
Message-ID: <20190221155218.GD4062@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190114203945.20233-1-malat@debian.org>
 <20190114203945.20233-2-malat@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190114203945.20233-2-malat@debian.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(346002)(136003)(2980300002)(189003)(199004)(106002)(5660300002)(36756003)(316002)(16586007)(42186006)(54906003)(1076003)(50466002)(46406003)(76176011)(58126008)(36906005)(186003)(786003)(26005)(336012)(90966002)(4326008)(23726003)(52956003)(305945005)(86362001)(103686004)(126002)(446003)(476003)(246002)(486006)(356004)(47776003)(229853002)(2906002)(11346002)(88552002)(6916009)(97756001)(2616005)(106466001)(33656002)(26826003)(14444005)(6246003)(6266002)(75432002)(4744005)(8676002)(8936002)(478600001)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB3995;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 631dab5a-74da-4e84-1ec3-08d698149161
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:DM6PR01MB3995;
X-MS-TrafficTypeDiagnostic: DM6PR01MB3995:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB3995;20:5B7EtBcfUXxek44m6Cb9yHTjJJK/DylJWJ9GBscklv1qk0tDE8ZyOL9Fmtru9a0CeAMCSXktH50Uk/Pl93t86+t6utW3SqadE2GU1ZqRvS8YLd2SK//wUx11Ra5UaGvpE5EIbOtrsQ1CyIARCKtQH5ZCo6tRfJYmLTASg7iIyu9UptWEXJZi2qMdeU8cykRUtfGoybsbCE12C6T6LLP6EvNFepGUu10pM0w906Qs3sR57dflP6lp8xIStKHQKFDb+DdBEoeCgtchfvgnf4OA+3c0bPHzxXKAtJy2Gq3T8k3TKgWfBbzRHxzy3FR62x12B1NuEBiwEjxvZolae8mLwzp/Kdg7t22LxGHaHdGi8RQl188kSaJYmknGDkPPexjj7NLNz0dwS1Pb9He5zdBFn7O7zaMOpWC+817cG8EYsut6sjLxdf0rvK3IGH5jgE+qbjx+FW8/ICKQLVeVXfrVTWX8Q0k+WsDQymVWQTG1f829S9aWVoOmEBc0PsGHVk17gu5O6MCPAgglu2uDi/n/CyiLltgqfIbhFuHbJWMOnDL+p8kUgKaA7MthAkTowHH+jRWkRZU/f4tbg2yhK7h1cM2XzkNpL0JllBTO025f/Hg=
X-Microsoft-Antispam-PRVS: <DM6PR01MB39954136346719D6AF0C4952B57E0@DM6PR01MB3995.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB3995;23:gFhQ+8ZDzpQjEs5tHN4LEZNL0RKhfVxRKr6lK+MoQ?=
 =?us-ascii?Q?gp6Wc7W4+LgGO6QQ1n9QuC/GJUAAulIMm62EZqBy6eadsAKpq9O96734RtcO?=
 =?us-ascii?Q?lfA9SLxzK4iI/jF37cpilCuMDbFSYUv9x/TmSsOvFNmKk6w7/iFhOzZ+jrKJ?=
 =?us-ascii?Q?G6FSCLkhO1eYSFzKho6LEsSEizqxWfLlwPhgcplFNgOoMQ1GCmxBD1kzNW11?=
 =?us-ascii?Q?wYzoIYPo1Z51+yOKCputmdLIP4tngV9wRBg4fwEUQqqllsRyheCnu/m+X0wN?=
 =?us-ascii?Q?VuYXGC/zFWU+u2MHqXKi+Y8w8xpsNxbBi8+zNwXDhtXR8KWcnU2elwDyQcc5?=
 =?us-ascii?Q?+9Oaf3aZSRH1pEJ76tE2fAkKYAjG4wWTmssbuk0St04hwpyh8UcUS8z/TXus?=
 =?us-ascii?Q?9C2FUnEFxzgNm6NF2XFJBkC1WloDSqvgcaT3WGZ7Btb3IBZDyKQbOYByVkAf?=
 =?us-ascii?Q?DQJHBMpEAyYIdRzaJvPoNM/fM+FNEvkufpZ0HPrGlvet9MImTCy++ts7etdz?=
 =?us-ascii?Q?maZGP6tVSx5gZYAaFQd5vX4UdasaOReC8eIPmrmPgCHEbLMMojQPieuhf0ao?=
 =?us-ascii?Q?wpZUlxfOJi1LhEJPRdqDvjF0oW1IcRjnufLSPOmLvFYWY/qKgRy1gO7VYfGO?=
 =?us-ascii?Q?gFWvfGMINuO8UGrAHnht3rKBQSsw+THRBo12UH6IOV2OqbqCoS6gwBXpK5fC?=
 =?us-ascii?Q?WEhQ2sUeStLrK8LUAAEBA9R5AGMTS6cJairL/ngNSWanw8jlCqq9DjG+UfN7?=
 =?us-ascii?Q?P1WK/URTK7MfzZvQLYUQTSYPRjmsyuvgAsNHLM2NEp1sLphksWAOZLPryNRf?=
 =?us-ascii?Q?2kWBM7LffVJP9p0oy5kT66cVw3W3jv1TgyK6CjWx3y7dW+uSoiA+VpTiuHHb?=
 =?us-ascii?Q?0huTCiP2TOVVWVB7w5FAexzcuFwzs56+WONcXPmd7i6K9vURWNZHsykBK5yL?=
 =?us-ascii?Q?dtODt6M3Y6+MHSnk5xjxxSFMV/vNJT2d0EofGwolg03Wehj0zAtaZAgQHjI1?=
 =?us-ascii?Q?ZaOKIGaZOTtnVbDkKLUkoc2Q+cvAUqkqNMAfwvJa7JTIRHYko4a8Oz4ms5RQ?=
 =?us-ascii?Q?HzQoOiKGDUdtfnjfZK7xHHJn1HVZuGxA1z3Yypfua6oRyliCIgnKg/CILRXK?=
 =?us-ascii?Q?VKXt3i+rHAiE76tfdqqxE4hJ1YQMMta4nFP1E3TPekyK+brYnTvYPtenvNwV?=
 =?us-ascii?Q?7odouzKX/Knmd8lVlq7LnyWmTK+gC2hRcMONZ15sLssntWHAofKXdtSZyAwP?=
 =?us-ascii?Q?cEK4AlUL2OTV6PJMS7Bk+TnY09krxUkVCpn8K5xZ9np13l0W8xI4wdOBZ8cC?=
 =?us-ascii?B?QT09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: TCmpp+TZcjZsy+/PskmH3Dv0XEI1gCj1JLzHXJxEPGC0DAUUiMg61JgLlXSC7JV5f0hsLtPW0qnJSSTUhOhPB8nXumW+NShMM9Rgo3u8fij/3gciAGOjhkuUZBBGD/0D5LtMM5zVaxfKWvHG/l18vMqNhxRaHbfKNTKxUF4MtajyJDqzPLLX9Qguoh5xWv45XmqR3LyijFHwwjSScjVmWzte0h9W522ZavmQNcFRlKTL5n0Vvdo1aILwCOIrfF5If4P4e4ooWNj8BM+QPc4InEXZZNTFt+5J812ZK8vqhboXmu/jNU8+Q+pFVHk6qjO6pRtd8bZFYnw+mmqVzk4x01sYL/U+7EFASvS7vBY4llGulF87sPjRLjAmeJGm6AwLBLBSzFRB2bSsJNNhskhNMNZk0WliFacxh0XiuKbLkTE=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 15:52:22.0819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 631dab5a-74da-4e84-1ec3-08d698149161
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3995
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 14, 2019 at 09:39:44PM +0100, Mathieu Malaterre wrote:
> There is a plan to build the kernel with -Wimplicit-fallthrough and
> these places in the code produced warnings (W=1). Fix them up.
> 
> This commit remove the following warnings:
> 
>   fs/ext4/indirect.c:1182:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   fs/ext4/indirect.c:1188:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   fs/ext4/indirect.c:1432:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   fs/ext4/indirect.c:1440:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Thanks, applied.

					- Ted
