Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B58DC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 15:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6C820823
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 15:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="yCIWbq/v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfBUPuP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:50:15 -0500
Received: from mail-eopbgr760101.outbound.protection.outlook.com ([40.107.76.101]:40320
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbfBUPuP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 10:50:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad9MqGeic7tNc4l2jXqcDlQ2S9xxTLb/31WWq5Z6Mgw=;
 b=yCIWbq/vMGGQRCdeOV6IgXusRNHk3Fa33Gl8QwKlAjTk8RmgqANFbGme1kqQa2eq8TN/ZQPpCzYPhhAMSWD83YsEuQFx0qc0b9Vs+M60EX04qERB0w82GjdCpc/YdFoRLk6jh3FaWE6svULxHG+coHG1D1UnEaP5rLNbqURBdgo=
Received: from DM5PR0101CA0008.prod.exchangelabs.com (2603:10b6:4:28::21) by
 SN6PR01MB5183.prod.exchangelabs.com (2603:10b6:805:c1::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Thu, 21 Feb 2019 15:50:11 +0000
Received: from DM3NAM03FT032.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::207) by DM5PR0101CA0008.outlook.office365.com
 (2603:10b6:4:28::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1622.18 via Frontend
 Transport; Thu, 21 Feb 2019 15:50:11 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT032.mail.protection.outlook.com (10.152.82.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.13 via Frontend Transport; Thu, 21 Feb 2019 15:50:10 +0000
Received: from callcc.thunk.org (guestnat-104-133-8-109.corp.google.com [104.133.8.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1LFo7jS024420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Feb 2019 10:50:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6CB8D7A3F79; Thu, 21 Feb 2019 10:50:07 -0500 (EST)
Date:   Thu, 21 Feb 2019 10:50:07 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Mathieu Malaterre <malat@debian.org>
CC:     Andreas Dilger <adilger.kernel@dilger.ca>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ext4: annotate implicit fall throughs
Message-ID: <20190221155007.GC4062@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190114203945.20233-1-malat@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190114203945.20233-1-malat@debian.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(396003)(346002)(2980300002)(199004)(189003)(106466001)(106002)(54906003)(88552002)(6246003)(4744005)(229853002)(36756003)(52956003)(305945005)(6266002)(33656002)(97756001)(2906002)(786003)(316002)(46406003)(356004)(26826003)(36906005)(246002)(8676002)(186003)(478600001)(90966002)(4326008)(42186006)(126002)(5660300002)(476003)(11346002)(446003)(2616005)(486006)(16586007)(58126008)(86362001)(336012)(103686004)(14444005)(75432002)(50466002)(8936002)(6916009)(76176011)(1076003)(47776003)(26005)(23726003)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB5183;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22e529e3-8a02-4420-3066-08d698144335
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605104)(4608103)(4709054)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:SN6PR01MB5183;
X-MS-TrafficTypeDiagnostic: SN6PR01MB5183:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB5183;20:CsJbEEdUosH8Fi6zhF6J2xfOvMWxhQxIrVuRkdAjsfO0H0+N8jnRhbXV8kK6rJifOHCb7FWUeVGRvKgnYdAqIhvDr0WF+K2FHmDIwwiPIxxCgTNgL1U/ZrIAruWoT1Y4B8ObGL9aMmLM7jjeTMn50yfMIHaIo+2iNEfJZ0OK/r+WZnA/dlHrxd+IX5vcNzLHX9Ske8jsuDynOaU27jPpoLqPmiUiKLBLqeNgj+SbhK0VvWGSiwbzadrfB779DmWEPl9wFXAAJvMS/jpXvwlauOheEgngAiw3BDVBl4wbHLOLT96dTW0e/Bbd/yZnJAQjyP6b/Q2MBy3ET5WLc8nl0ZdxMGVbDMyo1fEhPALxPEewy2xTBmfORiRU+tZnIR4LaGGUxoA2wcC1iOlAh91qKBqI2e1iH5IF5f/7LjefjY5k1ZWe9/cU8m0pGAIVTpQ7634eiU7ofrUuC0xQkbW5crc6F7Ne6al3AehyNJRiJ6m/iRxuDYkv8zU5TaVioCqbWxxfGtMmjE3AG1obBAaATtkp9Mv+ajV2lV57pXNvFpq/ANM/SUs36ciRPkWY1mBYImMlnszJqJJlsji2aCJZTlEdyZphlI9lxm6Un04COio=
X-Microsoft-Antispam-PRVS: <SN6PR01MB518389E45D03FEB6BBEEE0C2B57E0@SN6PR01MB5183.prod.exchangelabs.com>
X-Forefront-PRVS: 09555FB1AD
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB5183;23:AwAKPV1ywcE05HWuUxiLmDZkEtJUHuQqexWnWfgFC?=
 =?us-ascii?Q?ysFQQFuyhIF4d+oad4xk4GVOHVH9XKyBIopfHskNCxYygWaxS6Qwut+B8MPE?=
 =?us-ascii?Q?1WmkRstiZS0Wlo7q8/eKwKKvYG35ZF4pYXWEEYIzQfj9BmtkCDUkbBOdNrCm?=
 =?us-ascii?Q?zhZxl4VXwEvYrnaY1/BmS1AzWfqUINRc2XZH7J5/4GJLz7YQCuj4HqoCAz6C?=
 =?us-ascii?Q?ZrpVa0Uu3I7Y7QE4mZkd3T2SJ+29xzrB/365hnRPBLDC9ZHF9PEgobO7jrSe?=
 =?us-ascii?Q?Cp4hS4TKpUHKYqiC34gqp/0uZp+yQ5MJ3jg4b5AJ7CHedgjCATsd6zNd24Hc?=
 =?us-ascii?Q?5kZjRoEX2FhLGKuCAixW6S2/A7nEpcwsOjYCje4o+htafMpGA3qclzCoGU4w?=
 =?us-ascii?Q?jPDQn/Zf3lNQT32r3KocjEcbyogTSbZ4UMzH1TXNlLrdt38zN+xHJiyJ1SQ0?=
 =?us-ascii?Q?l8Z+/W153gqdcOhAHiRJWpX5jFFP02HouJI567J28BRcrV2AHVrRxppkxNkN?=
 =?us-ascii?Q?NtvhjFl+zW9SNYhrD6H7Qhr+jF4XbTkcwigvnxzECzASih8w37x9+K44AyRx?=
 =?us-ascii?Q?byHU5stK5HuZzRKWaU+Kd2jpts/PJzoW3hFKk37ssJjRCuAjXkV9dFEksfdY?=
 =?us-ascii?Q?if+p4pUE5H1fopB4IET7nZm/jh2vrk5GCd8bEkYHHBDUuWcC3NE381jmYeMT?=
 =?us-ascii?Q?nUhQFXIla4QO18EwtIC6J8m10N/3frh8Oh6+4LJh6eyb6W+Rf3fxSCjL/ULH?=
 =?us-ascii?Q?DLfa0LtXjkFG1RCq+V3ldPDIPoSL4wNyuAN0ZUljsUFXEG3Qt/BXHwfqKfVn?=
 =?us-ascii?Q?JTDCPDPax/fmNrNbqmx4mn5eeFBoYpBxpyIlq0SND5aWQB4ad3hat4weRf8M?=
 =?us-ascii?Q?dujKY2MZ9IVYPOtELAPzq2Ha7ER4gfCxGaWRVFSeaAO7W7AvQGbFEEDrbXgz?=
 =?us-ascii?Q?yRsUw7/JgzsGmPadTjijwlEzLyWtdDxfF0+AWm2PVcNSB3V7VzEw8pH9fAB1?=
 =?us-ascii?Q?6dduciIjslH2Zg46q+gLlpM2PVxC46LZeihoJuoXFoiG7BHgmfQq6wazN1uC?=
 =?us-ascii?Q?Vo/Jd4hTJ5YP9piT8ZSGmTenatTK17SKWcD5PpCQ36rlNv+752OPNOqaNI07?=
 =?us-ascii?Q?v15v8e7G0WB4Xk1uHRG8KJxZFJYgIYuQMALotl7+NhRQ0tDjKmIGDGmDsv91?=
 =?us-ascii?Q?vyH3zPMtduTmLiZl7X6HgnvrEv5ZEHRGBLbX6j4g8UnRw74vRsQZltLtlaqx?=
 =?us-ascii?Q?tgZSohd9YKSpYICx66wpZb9Pyqr60cxl6IospJdkkYOsVu02oqzKu5kSu0mC?=
 =?us-ascii?B?dz09?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 29LNVJ+XA61tBwXeYzDJ18YRAW/75fMuuDmRBhkpJv9onl4Ur3tdTLr9KOyceTS43oD9fA+sr3uNnls9IYyT10bnCsBxVHo0JlBXUQ5m5kSyEy2ztL948cj6Lqi9ADUTr2UQNsKrszpm+uL9+Fssms3dFyEeR4X+qFNdd9zt49M+XtqDqUP24Qhg2GYDDLjiAmeAET9IsxBnb5HXJ2K1FfX89VwIL3AXofnhXt4ssoh9jqldZFroUKgb5SOlYZoF1XE8lU1reqxuXifRwW/jid2DZ+rU09r4NjgJ8YbGaCYzqpudtkLW03FBfA4vmBfwv738kFZuF6/a4s4t4ToYtPB7QHDrJ3aZVjnS/+kkssld41r1mkT/BwwEEgL9qlK67Q0E7A8gH4jjjufLnu6OK+2cS+tRRhCBbLHsJoWqVR8=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2019 15:50:10.9167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e529e3-8a02-4420-3066-08d698144335
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB5183
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 14, 2019 at 09:39:43PM +0100, Mathieu Malaterre wrote:
> There is a plan to build the kernel with -Wimplicit-fallthrough and
> these places in the code produced warnings (W=1). Fix them up.
> 
> This commit remove the following warnings:
> 
>   fs/ext4/hash.c:233:15: warning: this statement may fall through [-Wimplicit-fallthrough=]
>   fs/ext4/hash.c:246:15: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> Signed-off-by: Mathieu Malaterre <malat@debian.org>

Thanks, applied.

					- Ted
