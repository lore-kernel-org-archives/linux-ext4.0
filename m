Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,TVD_PH_SUBJ_META1,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1838FC169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B905920855
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 05:16:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="JSvWCzdt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbfBKFQY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 00:16:24 -0500
Received: from mail-eopbgr820102.outbound.protection.outlook.com ([40.107.82.102]:63952
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfBKFQY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 00:16:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZV+MigAoUY7j7IamtqvRGVIgyyGE3ymHPga0+QmjY8Q=;
 b=JSvWCzdtF8TTJcaCBYDoS3R8BXnE9vt/416Bsu8RiNZ3GmuHD7VTphadxYS6tH8aZZGAhBb5Kjm63istjxkhB8IQvPrVtIb82eYmwMYU8U3I9Xt5yT2Y8OPzkQxA/Mn/zxQvDDwpw6J86M7TqEaSpspldk+Fs132q86QIsC12Yc=
Received: from BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42) by
 SN6PR01MB3760.prod.exchangelabs.com (2603:10b6:805:17::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Mon, 11 Feb 2019 05:16:20 +0000
Received: from CO1NAM03FT012.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::207) by BYAPR01CA0029.outlook.office365.com
 (2603:10b6:a02:80::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 05:16:19 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT012.mail.protection.outlook.com (10.152.80.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 05:16:18 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1B5GGnL000715
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 00:16:16 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id F0CBE7A4EA8; Mon, 11 Feb 2019 00:16:15 -0500 (EST)
Date:   Mon, 11 Feb 2019 00:16:15 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
CC:     <jack@suse.com>, <miaoxie@huawei.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] ext4: update quota information while swapping
 boot loader inode
Message-ID: <20190211051615.GL23000@mit.edu>
References: <20190122065823.67957-1-yangerkun@huawei.com>
 <20190122065823.67957-4-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190122065823.67957-4-yangerkun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(376002)(346002)(2980300002)(189003)(199004)(246002)(33656002)(4744005)(90966002)(26826003)(478600001)(36756003)(1076003)(2906002)(786003)(356004)(316002)(42186006)(229853002)(46406003)(88552002)(15650500001)(58126008)(16586007)(36906005)(106002)(54906003)(6916009)(76176011)(126002)(446003)(186003)(8936002)(336012)(14444005)(26005)(52956003)(97756001)(6266002)(6246003)(23726003)(305945005)(4326008)(8676002)(103686004)(486006)(47776003)(2616005)(75432002)(86362001)(50466002)(476003)(106466001)(11346002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR01MB3760;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT012;1:N922T6AytbajMKwnBdr6Zs7d0aVvCisIREGunJzbUg7Kecd9jIgvo3ABHVxph1oDZS4BTIO++RENsPZigvbJnvGq7bOfi/hSwr1USH5MgNJWHdweKoCM4QpEFWgpP5DZwuwaLFqwHP8SgDX09RHotuBseri0aEDxX+u9BAy19Xc=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a5a57b8-1a6e-4fea-f9a0-08d68fe00dde
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:SN6PR01MB3760;
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3760;3:KOXyJKFKu7IrF4EcvGoc0ywiGt3S8n8t8J/LFQ6AG9YUTcYVGDkwF4zBUv9KW06K4mfbFFKBq5yR/GlPgXnaZ1oIPxmb7MCV/90Aqbu5rLaTN0HrJE43dx0XNzIsOxiAMbiEF3xWRMTYIRAmWi7L3vaLV8AgRRYpRsCAaAxOfp7PaDiwy+M/WIYSEblcZ1Ab5IxEO8G0fPgpdQLzuxB5qn3Vx6b5DpAAxnfh3nPsr/ElJ9wnNeilxlexqxmUYn+X5Zo2BZKsDJiRCiXKMhLV1E2dXYH+F0TpdvjSfFfvA/ObYfm43TCUOH7OBjVy9tyYKA4kIl3+M+h4zlfxU6xurn8BiRffV0cssVtP+6r3vWz5SX9MJYegJ90z3LM2nino;25:7wAFdImwYP2lGJLObdn/w6sj53ABaZzCxsTuyb9Hv1X+S6ef3e8hcWTwwEM56TVWJrCej+TBu91pLEbQxkAB5zgsIU1JutdDrOZgxffBs08ZuB0rS4juXNJdqG6i7ZUbkg2YeNjiXE0dXIIGGUNWGnmD5fy0LX+0H+jDIQLsuL2LDPYOCOsB9KI4qU+JoEnMvmticnOqywNMKHZn99j2gOVy5zE5SMTQXsz+ZWfWz217UaMDyzPt6TGlxkljLK7CXzEKmUW4GOoWWdMq3Yqqqd/IcFYMpNiaGNZXe/wqw1THpgXCjGfwyAJzo/H0wH+/51YSSCyK2I+RfvSLPMkNYw==
X-MS-TrafficTypeDiagnostic: SN6PR01MB3760:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3760;31:A5XyswATVZI90lbtQZi+c2m1RkiszYAQdXeWuql1kXyhjk2UMMlB7sUX+Qr6OudPQBzmypbcgQOHtF3m7lxrtET8yL9044sevTuleZZkCPatMIh8vUPE4GiWyNON5hulrGQVpWjYoRAHNORc7Vx+5pP182VeGHF8Q4BN1riAscSjL3aacL7/NpX/zqVTAJOy3SPFjAP1cmpfV9ytcH7WyNyAHfIkGc66D7xVeCorMug=;20:w+wvjbO4B+MFktN5ZAxBxIlhKNZkakV7jbsR/yNp7I6GjxzQQp0c6ZaBKECFTOci3dT1nmjYR1yxgLMGcucJTyqmkFfjq1vbNmrQIKWbsw697q0j7TeEjbHdsLzzpa7DZTzkHFo0HQ0OivCePe1SOUjfE3OXkwQ2a5IGeDv600xKvRz/vxb3ad1jNc1pstpenI+Bdyjfe7/JtaC52zxoLGtI6Q6TPxymDmt0Qo78hMIoKj9bWam0w1kOUk3KDdw1Bph+hsU3SvbX2x1SZnMx0Ga2hG9tu4cykBFPkb9HUfdTZV5aHQ/ZE21pgyUz/h9spxeYmSmIVubpu3jtTCNLBgkFFPXgH/LX6Vm79urskvQ7NGB3S6wIyDmBz3YaeUdBxpP5EsT0QyXMcslh6Yu9Qd2/K0y0qeQM29nCN7Ig3bV0c/Iu8zEXj7CkWtf9SSGGqUCuQWuGwsUi1TysHl2+YFnTriApSzUWyC7/2fHhYFmZvIRrrs4Eah/tu+BI151og2SLN2gs+luYfNRW8PgcXo5LbLcepmeS67F62AlOFAr7PjCz3yfS3zhuZZg3hyk73VBLUtWI/3K6uubzeNvYKVNDv7FZS5v8b9+xyuZAEU8=
X-Microsoft-Antispam-PRVS: <SN6PR01MB37609B5FBA12370CACF2CC2EB5640@SN6PR01MB3760.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3760;4:jRKl/KwIxfq5WDASCOsm0lEVefy/WGlJ8ITdAPCYEU3LkflXi0NJnXJRIbIgWAKNrEXmAx+xUSGpGZoxtwNX1z/Hbn7UX3L/QNXUQ1ck/A/vCRozACBF0izeieYcoF66JsB9MWKqxuo9GKUXkaAGmgIl3O3dWZu6UkMT4CX5StqSAzB3buKC45zu1llcu9saD1VnBsqNc57P3bGoDwxsLfYgvEe3hiP7CzCJlJDrmh6fhFsTaddcVh/ZvMnChJidMgYV5MLij0qlpMj8Z7LV4TA7Hnfg8+iYVEEwft3DGSg=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;SN6PR01MB3760;23:8ES3FE1cM5J/9eElOWI0Q60APHM3T7Fp7f6WXqOCD?=
 =?us-ascii?Q?3Vmhm6mGlNdNqGyGrxUwuCdnTiIRk0d4UYg/8jF3Q1ch2Yi0XjnyyZbvILQF?=
 =?us-ascii?Q?RZjZAnp0ahywRKx5eViPDLscXnEsNjjjy3M9PNl8+AF/h2kkkipmMAiJkz41?=
 =?us-ascii?Q?R4CacSati7PjZNNCa57h5z4zI49PaUkpEJpFIMONyNGdy4QC+gOfnSBJBgOR?=
 =?us-ascii?Q?iO8BQSCT0j37Nmu67uY4G+YU/3Bu2RuLYwxu7sifFl9abl8iW8bAbmykSAoI?=
 =?us-ascii?Q?lJx9w8y3RYKNaKm0kX1EVwK87J0cVl4NZKvxFtUzAhbtz6ADjvjJsqwQaom1?=
 =?us-ascii?Q?ULX70GT53FTI4q8ssJre3GM2AIMCThH0tqpAZfjXrAXdglaLpTltlmi8QQGQ?=
 =?us-ascii?Q?S59IjArIIctlHFma0AJfsrMzLRnGD5UL2UfjdXbpjKyaBf7AaUEAXZEYiJpV?=
 =?us-ascii?Q?YWl9UzteKDpBariUlGH9VkXqBNBBvNB5EiMOWPU8Ngp6GOFlNQx6YrVOC1aM?=
 =?us-ascii?Q?DBRv6hcyZxRFDICfgL3H/8qoq3gguXwxirDWMn7py6EKrHYDby26lETX70JO?=
 =?us-ascii?Q?oiWftgQ5vogmfzQgSw6ueT37GQx9WG1EWeFM2yFEEni+WDlRL/6BBZNg1L4j?=
 =?us-ascii?Q?KEWIhXe9DC5FPcYqOHNKMnuORsCUWcZDUN+b5NRufCZF0JXtDMNJcVLR60me?=
 =?us-ascii?Q?P4HxdXsnJH4ieM8Z/eavXar7LlMHKHXwp1zjWypaBMhx1lKjRXflcVE8jue8?=
 =?us-ascii?Q?3Cl+kcZo95CZEExP3elT6TCHVHHpqU0UT5Hlv9+loBrDUylX8SJ/UlMpQwkT?=
 =?us-ascii?Q?cb/cAnk8Xv80wkMXV0j0zwIe1RQi4bXQX45q2bs0xy/PWY5GCvrTOa+V7K3E?=
 =?us-ascii?Q?CZO2AL7sheqYye+Daoz86WbkKSSRYt3Ylo5A1TG0j+0bzJGULZOpB7H1oohc?=
 =?us-ascii?Q?q9Tpwsy/lcfMemioVxR9ELsTq7yKzQ7B3A2YnpOPAyB4ctp6Iija8vfoXhlu?=
 =?us-ascii?Q?9OTY0/yaM47GbOu9M8lhi0FHjq3VlkazWip691mB3rzqsic6z3SsuT9ftx1X?=
 =?us-ascii?Q?iuAxXGlPScGl7aAIqYT2Sb6WHSCN7j8gaE62e+U+ErKd2rqugCQ07L7I7+TQ?=
 =?us-ascii?Q?sxHQCXSVFOJQZ9G8Nf3LOw71GPA477SNGwh0j2/616vxRTyupxeAcsdZ0jRO?=
 =?us-ascii?Q?98d4IAyzbhfSv0gk45JWDdeIiE21WS9JhqT2haSZ80HQg8bJgpiKnh6p3VKx?=
 =?us-ascii?Q?E3kRaLqVxVH79fPQPAEyuznQFNaCaTD0l24au88?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: QWRPSOeci5A/4RtiSJnln3O+FkMZfU2O64B7mlZMZ1y/FbJhAO6Gf3n8m8dD7VRBdjHQWEj6fVbwUXr5rlgrYwiXKn8yRNO6TFbQ3WzbFluBBBxd73xD/r/z8iBtcRLmQSntfV9/iRPQAYPtSk9BxDoZyz+UnabiQYLDrrgxwdC4XNYWeeUAX90Tp/P3YdOIioPcq/tzQiibZiOHC+Dsk6ziJ+E5XYCsJSe0LGyNpwQswPDIsF9uKHMMhsyNxWyNzOOFYU8922ZbqrnIljf2Z0/W9zdX/9F/Gtvwy5RzoHngRteMzVE9ebm9tK0c21JgCMImjK+Jqc5j2D7PHl6hcSuEpaXJdGKlWY1ZXVY47s8eS2xawBiZsPn5qta25ldQm7RA9xxYyuMiMzCwVzITv2rA05YuETKj1iYaoX69b/4=
X-Microsoft-Exchange-Diagnostics: 1;SN6PR01MB3760;6:uVS5Z+KP+zVFp3Ll/1fjXGXOMGOdE8EyJGKce3smjKspJ54gdWUbp1TtWyBIwz0+I5NoZPs4XChQiliDU2RoxSmiL29s1asGc69xnW4CbYbxhNqNh0NGkeOpuMfVUVjW8JYPB6QtMUWhT3jD0krTbqZ0Q1MexZvfMpu+EE9SQ8DdxY2doH3wnls7ZJRjd8DcC4PKAlKvZWXHm4VOB0h2BXbIeBr0EncLSj2sG5Oz1rRXx9OmdlRsMU1fD9g90zqUX9N5HWGIWANRBhxK9GWCppgDT78qmnPsWQW7VhXs9fUR0ouR5H1Fozi6OrJHu3cXM5BXhm/fn6vLOH14Z/uTgNml35M3HCVybuGqwT7G0R+zyVzzEObBry8yjP7MSGMhEX6nlm4A5pWjLHhIeA+KJInfyoVYEGqY8rt7a3KMFlMeBgPCC/JOa/TrWRcCiaSgPj6JmvrcbFXSvzVktL9WvQ==;5:51BgzhLNEAboRxKQo1Bl+GPPGyNCBPLwtabBifj1ZdxD6g1rZhGDzAUixbfx1njYp701L03da8lMn6D2VZjl9RcvB1H2jc6hz/RSk7l+m+gS0+k+8sgoUTde6c52ium1FLPtLIHJPy2HZGCVgaJ9AkzmsE0YSw1JFwmLH2VkHCYtmVK/BfMkwyP7iMvZRtBtflPYbn6oaeaIHIOvw6WPuw==;7:W3k+YETMB4JqpwD78lLAOv9v5/xEv1SsPR7ELYkxvAKcMMN3BfZlULwu0mUqCXxjg5+x/V4r9WiUoWoI9cCicZVm5reaL7NJdoKJGtWyiILRmCTVr3woEaITA4AthPTYeSIy3mNoSxXFto4ziXQuZg==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 05:16:18.2155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5a57b8-1a6e-4fea-f9a0-08d68fe00dde
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3760
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 22, 2019 at 02:58:22PM +0800, yangerkun wrote:
> While do swap between two inode, they swap i_data without update
> quota information. Also, swap_inode_boot_loader can do "revert"
> somtimes, so update the quota while all operations has been finished.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks, applied.

					- Ted
