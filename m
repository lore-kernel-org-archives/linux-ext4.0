Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED62C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752BA2087E
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 05:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="lj5xtDm4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfCAFaw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 00:30:52 -0500
Received: from mail-eopbgr700139.outbound.protection.outlook.com ([40.107.70.139]:29455
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726051AbfCAFaq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 1 Mar 2019 00:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpmkvW/mv8zFy7cS/kZszYoqNTkGc8rOBjht7vYeK5I=;
 b=lj5xtDm4l1vcmfH0bCqi0k3pgXOPPeH/+msWi76q/c4i9FP5uUU8Q5Ulnfqo8pLCYEQa2muUq7k+El5rsdCxjojafbjPpaGbAiH1YValwXP02kRAynxf1bnJSEHnhDD2+aPaEDU2ZEC6eFZ7TRBAbn0B9x5lWyo24CrINhnP34o=
Received: from CY4PR01CA0019.prod.exchangelabs.com (2603:10b6:903:1f::29) by
 BYAPR01MB5607.prod.exchangelabs.com (2603:10b6:a03:127::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Fri, 1 Mar 2019 05:30:41 +0000
Received: from CO1NAM03FT016.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::204) by CY4PR01CA0019.outlook.office365.com
 (2603:10b6:903:1f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1665.15 via Frontend
 Transport; Fri, 1 Mar 2019 05:30:41 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT016.mail.protection.outlook.com (10.152.80.170) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.13 via Frontend Transport; Fri, 1 Mar 2019 05:30:40 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x215UcDP027243
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 1 Mar 2019 00:30:39 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5588A7A3E9C; Fri,  1 Mar 2019 00:30:38 -0500 (EST)
Date:   Fri, 1 Mar 2019 00:30:38 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
CC:     luojiajun <luojiajun3@huawei.com>, <linux-ext4@vger.kernel.org>,
        <jack@suse.com>, <yi.zhang@huawei.com>, <miaoxie@huawei.com>
Subject: Re: [PATCH] jbd2: fix invalid descriptor block checksum
Message-ID: <20190301053038.GA7930@mit.edu>
References: <1551144685-145239-1-git-send-email-luojiajun3@huawei.com>
 <20190226124710.GB15629@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190226124710.GB15629@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(39860400002)(396003)(2980300002)(189003)(199004)(305945005)(786003)(2616005)(36906005)(106002)(88552002)(16586007)(316002)(42186006)(14444005)(52956003)(58126008)(106466001)(486006)(476003)(336012)(446003)(54906003)(126002)(76176011)(47776003)(86362001)(97756001)(23726003)(11346002)(33656002)(6916009)(246002)(26826003)(356004)(1076003)(478600001)(90966002)(2906002)(103686004)(8676002)(4326008)(50466002)(6246003)(6266002)(4744005)(5660300002)(26005)(186003)(36756003)(229853002)(46406003)(75432002)(8936002)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB5607;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6f89565-b9b7-4f6b-fa64-08d69e070b82
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(4608103)(4709054)(2017052603328)(7153060);SRVR:BYAPR01MB5607;
X-MS-TrafficTypeDiagnostic: BYAPR01MB5607:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB5607;20:rBDpr0NF309V/Z+q8jbx62QAqRdO5g4ICOXre9cotJmXF1kVaV66ZldtuHJ5+SsWfECmoOecrSrowf3n5Ky0NKlleWb0C4+Ewb9Ic+DuaaK8WJxjoKviloKO/1Q+6FvwG6mowbjV77wwCLo6i5Vg63mU+3nqmWBIcDeEywOd75SYLu3CXZF89p5G++0QzbfZktziU+EeGNSXLISXKjr+xPMTjgCti0yLzYbOn1l4DdLumV4nfLy9w2tingPOTMuVIN0XLvBcSGs4EM2vwba+yhsz/J6vuYqlSVf+7NR6nlcQRC0ylPf+rEmRcxvQP8S6GgW34rDi5AkhybWw599V6i4d3IHxAvM4k9tMNBTF0Q/9C6NjsNa6uyK9fE8QYuWNZxm/sOhcn1iDRKnRPtAJUdd+vmv5n/m5QhtNb6QvpXecVkzQGf+cg2wjLPEq6c48fTML7fG/MXYmvcz0BTRisQiS9frqZTUMPDOlXb0YRmSQofC6AXXlixd7jNJ4oGeGwfki+TdYrivfKBT+KnfE2dmCIVhScAlGx0v36CSLW2ocwS4bgzSAgrJfo+2yezH1Fl2fbZYDU54DPb7QuCe3P1+tpO4199E9IgIi2QGHt54=
X-Microsoft-Antispam-PRVS: <BYAPR01MB5607A03EA4AC14CF7F0DBC4FB5760@BYAPR01MB5607.prod.exchangelabs.com>
X-Forefront-PRVS: 09634B1196
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB5607;23:MIfKWenOqaNGv+IPhSSUDjcLLWLki3GZ6WnhRZeXL?=
 =?us-ascii?Q?kNOScCC15kvDZqONINK8/APD4YabtXNzoMPXRwUi3ElfeDBZIApHfTsmQ5Rz?=
 =?us-ascii?Q?bFU2VqO4x4x0O9U8+pUdq92d0qke3mqNcL9Sxxk31md+Rm/1IreWMiaMZPER?=
 =?us-ascii?Q?RP/ETAW647TO6fC4ka6bZ29a3sDdfvMvNQgyHofpn/wSttfV7TMvotSKdPJ2?=
 =?us-ascii?Q?p8OcNitS7oacp8flLlM2iikEBEGws8eLnrhe61nlTcQ9/AEG8OW25M4O3Wbk?=
 =?us-ascii?Q?TqCO+3IWValQ0Vau0Fv3TMPjKcv2xzs6zABRiO8yhlrn3NTTNxyO49TQ6rjO?=
 =?us-ascii?Q?b31rrd0mkQZ9wEcFAYAo2VRO/8cQW++hHuJs8jMwEvk0cbjzYVPdSBQkiwCp?=
 =?us-ascii?Q?D2UT8vB9TpqBAdLIEGn+S82HmN+KfhUBu1iyKu+wX4y9s7+lnufHPLiV9RL/?=
 =?us-ascii?Q?XkPHc1FcQPrEV4D+FH2VOREWJv9JCOT/bvk3AUyLGwj6HxsShMlN/PJE39qo?=
 =?us-ascii?Q?Av1oiQbY1kGOZnkMDmvpOvac12NyyIbRbW6FuMZD69W8zNjTviBqgIGk+YZE?=
 =?us-ascii?Q?mxyFet84DOn+uluem7PSrVL5qWvKIfmBqhOANy+irO2lWTZzk0rafRFZH8OO?=
 =?us-ascii?Q?mN1+UskDUpTZFNXhQRoeH906tYIx8q2h1II8Lpy3ZNMel3ckg4VgkV3fsTs8?=
 =?us-ascii?Q?k4duNEjRV2eMeHLSsI0BbKZsfj6ATYHfy1jbRqnFBALd3tOf5/WLgcctGg6l?=
 =?us-ascii?Q?R4RTmC0K5ryIqQBdfR3+1KB0XCp3TEF53Pg2cPQrRJTLGq4AQkSXE/tVfdYB?=
 =?us-ascii?Q?nEYRhcuy/y1nIsWSfVydIsvoCjOFVu8GegJqUHpyTL9wbq6WRPuUblzF6WML?=
 =?us-ascii?Q?zlXlXm2EnJEonVEVmCU69Mg+Uot+WZPeeUEsOCZSbyFjbTyV3gX7yZmiNE9B?=
 =?us-ascii?Q?JQgGceEjrR6Xk6+jOCMgujWDk8NqFJvh7968KJJawlvNeGN4a0g2PoOErqX1?=
 =?us-ascii?Q?ib/tssRVWd7XJUyAxjQg0fOCOBa8lW8oa5A5O+NA59mWdVVjbhKed6cf6L8a?=
 =?us-ascii?Q?zLlpeEeVW1QVCxvvWCOPMnXOAHKPgIgXwwCJz/ftmwWNPtCiPZN3kyRQTDg8?=
 =?us-ascii?Q?eZ5fa4vIn8SsDfR2Gmo7uk102H3nlcL6AvZHlXr7iSyOMAqcZks/h4K/Z2lf?=
 =?us-ascii?Q?85K7sw9wOcvQoneIlklUiDLpAXZRIinIdLjqqUwd5HhDp50JKa384fVLh/MU?=
 =?us-ascii?Q?UoxY5a7U5sMuwjyZxgAkE2GzHd4p3SSn6dzT0Fw?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mH/qpO5J08fGCtDgFc4j2auulo8IX5iY+RU9Fmo72DCmNjBKbU06yWVtP6juLny39STDkzknAruC+hsguAUKJGJ9z21pShUy9LLeqWt54cPVXPMNs12lVR8jpRDkoEjcJ8iFbm5oXEN0f/73VhhciLiF0DqDOiWrgNIFqo/DL4yti8QJu7R3SI+HgdbgPD8bwYNUBGAfIdx0tHiITI43GQm6irLiXTJyec4Jl9Ofi/VSrka/MJHJsVc9v1gWK2mPgTKRWMTUINYIjpK3D0w+N1tiE3q8BbeFaDdyvl6s3LpNCIl03/aNCg8acbq+7CTddVCQIGG3rbByaXhaj29+Ltm6/q5s6pSxw4kODkUO54YhAXhRh0Nh6TCB9sZp00KiWLouzpokXgcGVHVwuivrG5Uql4wOaAO8QtbsqPcL3pU=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2019 05:30:40.9192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f89565-b9b7-4f6b-fa64-08d69e070b82
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5607
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 26, 2019 at 01:47:10PM +0100, Jan Kara wrote:
> On Tue 26-02-19 09:31:25, luojiajun wrote:
> > In jbd2_journal_commit_transaction(), if we are in abort mode,
> > we may flush the buffer without setting descriptor block checksum
> > by goto start_journal_io. Then fs is mounted,
> > jbd2_descriptor_block_csum_verify() failed.
> > 
> > [  271.379811] EXT4-fs (vdd): shut down requested (2)
> > [  271.381827] Aborting journal on device vdd-8.
> > [  271.597136] JBD2: Invalid checksum recovering block 22199 in log
> > [  271.598023] JBD2: recovery failed
> > [  271.598484] EXT4-fs (vdd): error loading journal
> > 
> > Fix this problem by keep setting descriptor block checksum if the
> > descriptor buffer is not NULL.
> > 
> > This checksum problem can be reproduced by xfstests generic/388.
> > 
> > Signed-off-by: luojiajun <luojiajun3@huawei.com>
> 
> The patch looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
