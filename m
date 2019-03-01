Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3476BC43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3D52084F
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="qxJoGCJ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfCAFj6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 00:39:58 -0500
Received: from mail-eopbgr690108.outbound.protection.outlook.com ([40.107.69.108]:3028
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfCAFj6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Mar 2019 00:39:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vrn7Hq8PK00k2S+OfTuGGpQVatYu7mebVSEYydjn2F0=;
 b=qxJoGCJ8aGZo4256pGEuLKxOIWCbby2wVoek4Q/D6isR166jiJCrwwhndKX9/njAH+S5TF/AyaCYX2PH6WEZDjNItz1U8qqflZmXoIv/L1kt0GCP4E22fejCqBZUjGwX3r2nOW1Up6o3A7A5jkOcbHLn26DbIGw0HRBE6LDD1Gg=
Received: from SN2PR01CA0079.prod.exchangelabs.com (2603:10b6:800::47) by
 MWHPR01MB3295.prod.exchangelabs.com (2603:10b6:300:fd::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.16; Fri, 1 Mar 2019 05:39:51 +0000
Received: from DM3NAM03FT054.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::204) by SN2PR01CA0079.outlook.office365.com
 (2603:10b6:800::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.19 via Frontend
 Transport; Fri, 1 Mar 2019 05:39:51 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; zte.com.cn; dkim=none (message not signed)
 header.d=none;zte.com.cn; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT054.mail.protection.outlook.com (10.152.83.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1643.13 via Frontend Transport; Fri, 1 Mar 2019 05:39:50 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x215dlw9029140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Mar 2019 00:39:48 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 8970F7A3E9A; Fri,  1 Mar 2019 00:39:47 -0500 (EST)
Date:   Fri, 1 Mar 2019 00:39:47 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
CC:     Liu Song <fishland@aliyun.com>, <jack@suse.com>,
        <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liu.song11@zte.com.cn>
Subject: Re: [PATCH] jbd2: jbd2_get_transaction does not need to return a
 value
Message-ID: <20190301053947.GB7930@mit.edu>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Liu Song <fishland@aliyun.com>,
        jack@suse.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, liu.song11@zte.com.cn
References: <20190226160728.38587-1-fishland@aliyun.com>
 <20190226163504.GA24711@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190226163504.GA24711@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(396003)(2980300002)(199004)(189003)(52956003)(5660300002)(26005)(186003)(8676002)(88552002)(106466001)(246002)(11346002)(54906003)(2906002)(446003)(23726003)(58126008)(305945005)(229853002)(76176011)(90966002)(46406003)(356004)(8936002)(336012)(6916009)(478600001)(75432002)(26826003)(97756001)(36756003)(4744005)(6266002)(16586007)(4326008)(786003)(33656002)(42186006)(36906005)(103686004)(86362001)(486006)(316002)(126002)(47776003)(106002)(50466002)(1076003)(2616005)(6246003)(476003)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR01MB3295;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a8ce41c-bbd4-4d9a-b26e-08d69e0852ef
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:MWHPR01MB3295;
X-MS-TrafficTypeDiagnostic: MWHPR01MB3295:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;MWHPR01MB3295;20:HxDMFbTSLbdu6Og5heJpMqizw4RKvUfLy+dPOlTTNpY/N8t7YaW6RPk6HO7Gr+bmepF+jgKIeIF7ryO/E7simwnZ3Ov/Jj8tO143CGmJdEeP/LMqm7UCWQX9pEeMb88anG4p1cqXnJIZKGE24jeutftDAxFXq8BVYupEVxCB6SIwtDzEzwdyGCH0jRMjXdflMzYcyiDsjY/NLXwBonoiEb/FDWU3roxJKri/EBSoxpMIgBUiJ4jjLw7YClG1vMJ0lyDx+aVFBPSUb+qXqu5V0kTsubAtjoirZ+DyCo+nJIns0pUtnKSNLE++qkBkTTMTLGGbkhXY9OjzJPx4DhXHUG+ItW6EY395gWKNOvL9CfGyfNi6Wk0aHGNGd4qBoLtFzFUr5b9oD9FoQG0gGrHJyKsL/LDeP/UqqMS47yKph76WGuF1QmiCLiqyEL7dry+rL7YS6HCWTyWE0uAInr3VER7KsVHUpEj731a4MyiiXDvoZysyMqnryyXe5x38F8aSYSZjRb6bX3XTENMNbPbQRaqTqoVRlt8d+hTPpARTHtTAMkBN3TVOypQc1qMtkq+u1jWQDr08UKNvh3bQu5P6j5Zn6vBwbWc9w+96PJpfzEw=
X-Microsoft-Antispam-PRVS: <MWHPR01MB329549C21C7939D26D8730DAB5760@MWHPR01MB3295.prod.exchangelabs.com>
X-Forefront-PRVS: 09634B1196
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;MWHPR01MB3295;23:G0N4F3++9ZlZw5ebaMMPZJDyA0hVaLM6I2zkdPvnE?=
 =?us-ascii?Q?meWyqPm+u8pTMkCC8yvN9CHQ0pSnp0R+nwJjPPM+H9JjhJ2OQ1XRYZ0bEx6Q?=
 =?us-ascii?Q?PzeFlEawXXBabXXaA/U4M3qiSR5IBtiPeQAdvHODSLUw+WZfxxXGa17QVR9B?=
 =?us-ascii?Q?cJLa5MCmQqkGEkjhMncjfhHtDYQQoq8B0jqZHvtABEdDRIDw0FthZTh8izfB?=
 =?us-ascii?Q?hjzyxX+eDIkshXVV2c3S5KDHl4WUsMuX7SyPyEmIau7avECFB3/XzdKLB772?=
 =?us-ascii?Q?Uht+MlGu/q0Sx/shb56P1SDiO+mphYRRqZmmH7JwVeYTXh+ac7hVdTV9HKcG?=
 =?us-ascii?Q?4c9cJgGWuMmpsk4WT1XjDSJAbZ4gdDsUhNW0zFJyT3EIsaY+abyNEz8g7r2r?=
 =?us-ascii?Q?lvFYOMLInPMHF7s8SM+HuexXhHcyzXRd8SbLPUcccNOHk7jevVR2Y0CmKkqf?=
 =?us-ascii?Q?8/u9niO6UAO6I59MxrVBHCxeR46RQiEGtirOmTPgkU87aLOT32ceOA/PAjQl?=
 =?us-ascii?Q?AfQZGn4g9N3ziVXRfEB1kDJBakHlECkiVjsjgp6m2redaSt8LRTgf1YLFNZk?=
 =?us-ascii?Q?xssPBdWmOQydDe8EZJx1vREfcdHXhqvk9GsCu/O8qoZLlqG+Br3BMQwQhncd?=
 =?us-ascii?Q?xwZrXhBnoi42WB97rr4vabGJIHmR1yJrfQ15EJuTMm3V7p7DPJx/p50pSzwz?=
 =?us-ascii?Q?a/4PIOC8CNbYUd5qufH+dJkRZM2M2eyK34xdC1dZxlt4+a7wOQfHOEtfnMUT?=
 =?us-ascii?Q?xA3a+d6DaRjvnOBjmpF7xpT0eQlrTdLChNiBW1Q9aHiMXMgx4oG4cc+1ojSb?=
 =?us-ascii?Q?UwMN2h8ykQZ8dMHmng/nn5LWqzDp1wfO5xCpYMbtfBhAsCl9EXj+dJAbsXm0?=
 =?us-ascii?Q?LI2Krq1T+3DktxjPJg1PExp5PH0zp1rsoTsV4ueQdNCcBIQd0H3BM2QBT947?=
 =?us-ascii?Q?vBcDhNdAknt0x+xJortxKvE/2SWeZiPbVikNMe/bCyBN66z83fjnhV4YpaRz?=
 =?us-ascii?Q?IlPEYxEqv3KacIZXm6M1DpkZIjyCZMge962RkLpUNHM+v0wIUPWBOIxTU4Pt?=
 =?us-ascii?Q?mRCalARm30ol9B/DCy69Vi5Xkl491fSmAQ7Q/obgr+zADTQOGNsd/01P+jqm?=
 =?us-ascii?Q?AaK+CJeTZlTc3lhkyIV2GxILu1HUGFsPmfR29uukhWjg3QM5IKS2wzdTpieC?=
 =?us-ascii?Q?CH/PIVtnxqcuNXqx0OoWESKjeoiZn1YbmXeu517DFt9gyAZ1PkaME34zlq5q?=
 =?us-ascii?Q?ilKsdLWqVrV8X939eQ=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: gVm409phWkpdcqlqX6SAQlsoAGOVZHVrmX5aXPH6gwhq99rvbtNtqP8kk+sXHUVcmYCMz/Ms6ctAtdlaAgURQOPrrq1T9wqhtA/0tsrZlsCuVPXJHC9XFeGGPfwqF8ohttFJtfZx9NjJrSzW9a4dj1ItP/ZtsoTSzxBe5filTC60r0HsUHXy47ddUL1Co1xlXl8DCnlJ3H5XqSfVqDRiYzdFVI5cKukY0WcGds4l3d9LQHQ3nAOubylBLnkmAWfE+kGEpLav+Y5zLXeedQVC17HAFi9YznGx68PAaIv6sHJjROEam/iSKYANf7DJzcvW0OTeEUhf9kS4KH582dbKn9clxfSK9pDv1iUM0TTZ7PZuVYmv6LMJvC5sXa2/R/Qg+FVrwiSuciG8V0OsYTQTO4o2NA5dL3aoQiA29zzspN0=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2019 05:39:50.2062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8ce41c-bbd4-4d9a-b26e-08d69e0852ef
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB3295
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 26, 2019 at 05:35:04PM +0100, Jan Kara wrote:
> On Wed 27-02-19 00:07:27, Liu Song wrote:
> > In jbd2_get_transaction, a new transaction is initialized,
> > and set to the j_running_transaction. No need for a return
> > value, so remove it.
> > Also, adjust some comments to match the actual operation
> > of this function.
> > 
> > Signed-off-by: Liu Song <liu.song11@zte.com.cn>
> 
> Looks good. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

						- Ted
