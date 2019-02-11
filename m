Return-Path: <SRS0=deMF=QS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAE9C169C4
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 19:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E77D2080D
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Feb 2019 19:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="rZKD/MxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfBKT6w (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Feb 2019 14:58:52 -0500
Received: from mail-eopbgr690099.outbound.protection.outlook.com ([40.107.69.99]:53570
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbfBKT6w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Feb 2019 14:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSijy5EI2S8+80MsZyA8fak9wM5c0CEXom776QeaCAc=;
 b=rZKD/MxFNi8TDxaS5T2VX2BVSSwfY/zYCEBQmXacedGecASK9aeEnev+BKZYAOCMlNte3ytbKQK0hacoebhCAN21gYVILoIxYkLTk9cB3LBmY3xKwU6sFENCzyDPPslwcZoJ/pJb7e7DIBha/qCcX7YuX2epWXXLrhcOKK8FfhQ=
Received: from SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30) by
 CY4PR01MB3205.prod.exchangelabs.com (2603:10b6:903:e7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Mon, 11 Feb 2019 19:58:45 +0000
Received: from CO1NAM03FT041.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::205) by SN2PR01CA0020.outlook.office365.com
 (2603:10b6:804:2::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.17 via Frontend
 Transport; Mon, 11 Feb 2019 19:58:45 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT041.mail.protection.outlook.com (10.152.81.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Mon, 11 Feb 2019 19:58:44 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1BJwgd5009389
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 14:58:42 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id D52997A4EA7; Mon, 11 Feb 2019 14:58:41 -0500 (EST)
Date:   Mon, 11 Feb 2019 14:58:41 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
CC:     "zhangyi (F)" <yi.zhang@huawei.com>, <linux-ext4@vger.kernel.org>,
        <adilger.kernel@dilger.ca>, <miaoxie@huawei.com>
Subject: Re: [PATCH] jbd2: fix race when writing superblock
Message-ID: <20190211195841.GO23000@mit.edu>
References: <1548420023-8519-1-git-send-email-yi.zhang@huawei.com>
 <20190128150634.GC5858@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190128150634.GC5858@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(346002)(136003)(2980300002)(51444003)(189003)(51914003)(199004)(47776003)(36756003)(26005)(50466002)(4326008)(229853002)(356004)(186003)(23726003)(53546011)(106002)(1076003)(86362001)(88552002)(2906002)(103686004)(478600001)(52956003)(11346002)(2616005)(76176011)(58126008)(46406003)(26826003)(126002)(476003)(33656002)(246002)(486006)(97756001)(6246003)(6916009)(305945005)(54906003)(8676002)(14444005)(75432002)(786003)(336012)(36906005)(6266002)(16586007)(316002)(90966002)(8936002)(106466001)(42186006)(446003)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR01MB3205;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT041;1:ni+Uk40gUGJ3aJh4UWP1mZF+3ev7eV+tz2cM1zh06JVLlNNDOOUwPNdqPomhJ9+Zimn1gR0idYVpnucI/nKUatAK9xMc8wjrlkzn76B3vcGIEIrMZPddgQJQJ6yw9un+85a7sBpz9C1YFXB3HOwSNC0ZECZbfhh6NmyVxHv24Yc=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed56359e-8910-430d-7105-08d6905b5463
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600110)(711020)(4605077)(4608076)(4709027)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060);SRVR:CY4PR01MB3205;
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3205;3:zrWBJeS++ZNt2y+npbFnTX/PMoW//fGcN4o+/fma1fc5PN8C8zAThG4po7rJp+M9qgy2SxsBSA6iggeFY5RGAQgqJ7mHRkOHA0dWoAG3/JxcWT4zRy91/wwUGtJEnL9bzrzURKiRqVGOn258LhPk9J0hZRwGJRrIZBaAlPhaREVtQ+zsveuBT30lly+b29vfAa4Cw2TzvD7VhQ8O+pR9mAM4cqCytjS9hCWGJpsGLbqeP6YT4z6lgKr8yhrDlRbnNEAplSQpew/s/wLN57qF7eoDH7HDkAMQF4rI/mVxsDE928y/dY8cOFKS5fYyJZJ+z1Qt6WZkNq2ZjSTP3Pa18B0liVi3JYYVZZZ93w81Mi69f9JQRnvNwG9Y3BcmpBGP;25:3OdgdADpqgOfkhZnyNIaGTmvXEo0V+5Om8O9WsbTQ7LVdeJX3datYTpqz+6Ph+XuTRf8JjC6WpW6Zyc4HqPcXSdUUCydvs1Y1KyzQSLhBBHOHQ0Ck+mkCvtUK1CTqG2zL+3hf8/37F0sqAy3gLWxV9//gTx5G++vZzR9fvxeaelca70kLCacGNfSh1VwzCqbMmWnkibQe2netwIH9VQXIHs687hVkKa60MCsujV4H2ulIm4K8uJAD1/QmSsvmbh1y7EMyo1FSvZBxkm4PzWY8hCwyC9pBqkqpaM0eSCtPRyH+6i/S/sNhDtFSl12IDdxB4+g3xNaSaIaKhDcwBAJBw==
X-MS-TrafficTypeDiagnostic: CY4PR01MB3205:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3205;31:TIkvsYLCi9vhddHKaDZHaNWcCH3bQIOUH+areQyGGByi7QTS8/5RWA0nQTPLtmUb+azScYod8aCnbCGxsMMnDdn7/LNuhVYJNFsxA2evfGID5PONRHAEFRnHjQr0ge4IsVvfItJgayi3m9d4huQgh9gmN9lSGoWj/xGhNOMxZ0Fwvg0Ob1f2QYo+VuDBLtrx8J5g+Tem8+i/rh20eevAUKAriRGdvf81s0UdSqAGRlA=;20:qw4uW3NnEnB6UxycCOVpcTj63BhJNEe2AS7/NttjL2bkZG17mCHusiLVLmkvHKwDk+lpECkSx19yXyex5n6HH3s3843K7qyAoKJIGnFTR96sDd2QQDocJ6Le99kISWcfL6fVOeSvVRSUWTqOYQg8Z8zG0YzplqNWdvow9B9YUgXqIMjgP6AgT8vk2ig0vvdoM5urQI0JvnONp1IwsNyz8AXDyaLHGo2gm++bLScfeB4VPiKXlbGdNarPZuc/4T12ajFIHbuRX8Qfiwt92gvLHu3unYBO90b/SVlLFLo4s/ALDpGqf4u2ltR7m3MaeoPetjuNVCcOPESXjQ4vA7uxK87lmWrDhxz13sswtpd2XJHqTfNh54KJjygetLmDT57CGKdDOZZBD+OTQkIitXtZ5k8DJ+Y3jEI22IJ6oaJSmN5A8ywS7Fj91SttNVS48w6G3DhsZQzeR52c6Ld1IV19DBXtXDS6SMFNZKNyO3DDF5NB8lfbH8Vf0mF3IWcJWK/O2TZKcIurhgRpIqshGw6TqlRLa3ieIBR/uRy+OnYb9u6nAc34wtRxI1wkyBxhlP6fCQTzA7RBj8MOgRZPEtoryAmkdcsrhVmKnA38uva64ao=
X-Microsoft-Antispam-PRVS: <CY4PR01MB320528C52383F441CC77C5B7B5640@CY4PR01MB3205.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3205;4:LZfyRvlRXfdo+V41FilAWjdYsWnVUmYhmPDeHjTQnxXFm1v+UZi4jko8ot6dvXGoq84RuHwYg65X4SshHmiqXjKCnk+5LoVdGLYTPnqUA4ZxCMQyVmC4kNhvOIkVlC/3ZsAafNIXvwTLh1YAmnSLt9B5PV2LcdvLogsx40k88+8x/iaYQmNIbpvamYmauHry7lx2EjEaiVlrs0GLo8+mvDOX5SLRLyjlJSfxv0txZdO6pIkdB2IdC5sAugs972vdQ9CGxvwDQke+eOe3AysBeAi8snkB7Xvk2mmMxaJVbrc=
X-Forefront-PRVS: 0945B0CC72
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;CY4PR01MB3205;23:5yM3abIQmhLOV+A3u29UPTdxoKE0v2pTfkU09QRJh?=
 =?us-ascii?Q?cTdFA6020P1u/0aLTYwSnMOqaXpprqOgxF7IN2amJlHx0bTC5MGMH+dL/n3k?=
 =?us-ascii?Q?mEdADngoRsJt1Z1N5LBUVt5b0zwmhXxVzzkRIvI7X7oZvv9rpVBbgRWidYJG?=
 =?us-ascii?Q?ipM9yH6/tqw5vjqRRF4ffKbMA2VOPDQRVKTqvrcW71Jm2aEVrL+0TfXfS1nc?=
 =?us-ascii?Q?0XqZHTUqKOOJuyL6Y8cS1CwtVj6R2R7HwbrDf0XJh4MPTpFkKMUk9fw2socL?=
 =?us-ascii?Q?Ol0GYphTl2aZJSWo8mlbu06T8bvOTq+G1v50WJ19Li2SgZrJtc7i3uSNSSEg?=
 =?us-ascii?Q?W7yoz1Ax5SpMSLUWa7fxMIl4D/jKZT1QsIQl75oTRp3sHYxWbfSLpgRdUor+?=
 =?us-ascii?Q?GcGbQSjT7smSILmYC1jG1/6UrjBL+/sSCUVbSJIm7XGIEc0wrjXLWqFznJLb?=
 =?us-ascii?Q?mUeygoTeYBiPmia/giNtH2wV2FAghfoNe8G1jqdF9Nxm9BOqRCWLo4FCqXct?=
 =?us-ascii?Q?D4QFgjmoWLU/xhYIarqXm9NV8HqdQirA5XwvfdgBDo/x+waBtqJMGkoI5/yo?=
 =?us-ascii?Q?HGXfyjESyNbDxNkCmCmczkGu2XTppUrY4fSrrkSF8uRfRAFbxMqkf+qamRk7?=
 =?us-ascii?Q?B44ws+2C+pEViIR64MJ/SAgUDUQwM3NXwcqd5V/B++ID0Ku+DuyaNOdDv4rv?=
 =?us-ascii?Q?e9Y8SFDVBXzelvl2yPnbRzndDUHve5qNFENFvwFvC8BJatoxEEJp1+Uc43ij?=
 =?us-ascii?Q?e7Y1lyY8zSJpIA9YnpUXiAofHisseUzP1tdj5zv9yhL0NlQVc0gej1DiX/GR?=
 =?us-ascii?Q?9jzV16gQd0Fx6xRizgW0Kzy5qFTTBGmSPPZY1C9s1eEuqHVzcO04I08fsNU5?=
 =?us-ascii?Q?tRmZc1XlrF9tUnKj64L0AbT5hEEchFNAri2mwxN/Aw18YXc9s4TND68o62sQ?=
 =?us-ascii?Q?MbWu+0ezmc3qhgnxnq/EVP6Lmkw2kNbOGbaxj9EtUWqJFvOSorct/pWO+3Cx?=
 =?us-ascii?Q?J7JqhZOJS1brHVCFhFqdGlM45mtlU0DdSPwHd4VssO6Qiv8kqultlw4S+tiA?=
 =?us-ascii?Q?VaWStLsYb68TSENGJ4jWXrtjZCQMSeRnR8fEh3D3yCQmQVk8NjdYpQyaaLIQ?=
 =?us-ascii?Q?2IRZQdUU6LpAzPeMdmkZTEeLnmc2deK/J9YPGDzoKyt+uUo/g0VcPtnxf8nM?=
 =?us-ascii?Q?Jw0yXDYWn7awT0tOKATKoiefrth6T7G7fkqLQkk/tYAzO/KCbTx0OaDNYZmU?=
 =?us-ascii?Q?iaPuFDll1YaIS5TeQF7z3FTbxDPdKCWOfeVJT5TXoUS3U0Od5gvFcHwTZmUL?=
 =?us-ascii?Q?ukvwGDMaABjnIPJxH05AfM=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9AMK5pNzxVtbkcBucEiz3u3q64gz2bgRhwVj8TvorKoyVFs6ejQlY/64yTRt/4xLQb4/H2N7+2Q7IVZ5LYhEhta7z4TQ4UFLPR8a/NHwPd4v93V3Y3r3BcMhZrGlv+iWxARm3g4Z7k+FIhtHT16+cxycSAIVBpYHjR1lFeXt6Rk0xaqeJKXiiwYKUgEXtyG6290l6sD68yEM2ECQOlcYlR65eRD8fXqt1O5+IjTeGiDVExyC3L/ZJMHsRwlXTpwB/iGYads344RoC+ihf5GOYDhBHoHW5U6hq5jGqRgUW8pnrWBdd0kVdxm1kMav7DkE5ZPOKoEjtlVQBBwMOAHSivWLtKBM3MwuXTjyFlA8rWT6z42OxoHYx1PVUz9KYLcIcr3xQwHIxlVuFgIorPFQD2kRtDUA+VWbiM3OhLW8omA=
X-Microsoft-Exchange-Diagnostics: 1;CY4PR01MB3205;6:prSrIhfG7xIOb3pwQBQsq4RJM0XrS2B8ThtThM8hnyZgT3Nq171u6pfx/+BEAUgWpwIDi7GST8MW4hpfmQAu9DZDi7rlg41pt/0idqmUuFT6n8RdS764JpkbfcaGmj2XqbdmToCNR11EwgizF6uRy5C6S5oaOlhk89SfYuubaJPL8sle8wxJvjjRirNB/dDwK+lAxkQnvwxBeTeVPQ9LziwSeor1UJQgHhFmY2RGy5xquR+Vt0D6DDUoyVTiB9qg7h6IuW0k4zQxz69uUQ/UP/WY6of5H96jC6mBDigReX6EtO2e22t0FCsxp1f1npBuozaoaQFzvpSWlqJQmbRiQGj5FYtWmo9C8MNQYBt6rTk061p4qNg5ITAxp1HbzFUaeRJtcBQ8EoJdy7Ks+YUP6EtVRdW2gE6bHgXOyfRG8rlkAdfR3g4+V67Fb9ZQfftlBpRMEmJWz88EN9eb0UyVyQ==;5:6K52nTkJ1GHALyN9TdwPY1umH0TA/8IMJ2PlKvyog9xyqyvIlBFYhzOD6YpucWj1HXRqOr4yJAYMPpa+BhsL2Uqj7xUjPaoEE4df7hiaQL7Wm8rM8sE6Z0SzsZvs6covLoHv15HmZvsOvYaWnl9Iq5/HQRIKDBMmSERcjLgq3TQVujeq7AQR39xRUMtQNVDX42CEgDlqwV1+WRD2iAX+Eg==;7:YKaacCfCBKp4fyFFtgimm5fAEZJm3P1uXKNLijiiVWnK1a44zzDEMNa8XlqKqrEhdo1ALIT3Fvo/nXmpnDlFUQgqxh/8n3e1EYfYMVTdOoG8XHnYxpQ5QWgDoBnEFT4GhizBly+gmAW/mEw9LT1wpw==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2019 19:58:44.6696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed56359e-8910-430d-7105-08d6905b5463
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB3205
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jan 28, 2019 at 04:06:34PM +0100, Jan Kara wrote:
> 
> Thanks for the analysis and the patch! I think that copying of the
> superblock to a temporary buffer is not free either and the frequent
> updates of journal superblock are synchronized by j_checkpoint_mutex
> anyway. So I think that using buffer lock when modifying journal
> superblock contents is actually the easiest way forward.

Agreed.  It turns out we always write the superblock after we modify
it, so we have to call lock_buffer() anyway; the patch just moves it
so it happens a bit earlier.

Please take a look at this fix.  Zhangyi, can you confirm whether your
test failures of generic/475 are addressed with this patch?

					- Ted

From 9bb7a0025fc43bc517c5e30c638f9ca389600b15 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Mon, 11 Feb 2019 14:52:14 -0500
Subject: [PATCH] jbd2: fix race when writing superblock

The jbd2 superblock is lockless now, so there is probably a race
condition between writing it so disk and modifing contents of it, which
may lead to checksum error. The following race is the one case that we
have captured.

jbd2                                fsstress
jbd2_journal_commit_transaction
 jbd2_journal_update_sb_log_tail
  jbd2_write_superblock
   jbd2_superblock_csum_set         jbd2_journal_revoke
                                     jbd2_journal_set_features(revork)
                                     modify superblock
   submit_bh(checksum incorrect)

Fix this by locking the buffer head before modifing it.  We always
write the jbd2 superblock after we modify it, so this just means
calling the lock_buffer() a little earlier.

This checksum corruption problem can be reproduced by xfstests
generic/475.

Reported-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/jbd2/journal.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 88d8f22d2cba..7a38b56c2544 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1356,6 +1356,10 @@ static int journal_reset(journal_t *journal)
 	return jbd2_journal_start_thread(journal);
 }
 
+/*
+ * This function expects that the caller will have locked the journal
+ * buffer head, and will return with it unlocked
+ */
 static int jbd2_write_superblock(journal_t *journal, int write_flags)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
@@ -1365,7 +1369,6 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
 		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
-	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the journal
@@ -1424,6 +1427,7 @@ int jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 	jbd_debug(1, "JBD2: updating superblock (start %lu, seq %u)\n",
 		  tail_block, tail_tid);
 
+	lock_buffer(journal->j_sb_buffer);
 	sb->s_sequence = cpu_to_be32(tail_tid);
 	sb->s_start    = cpu_to_be32(tail_block);
 
@@ -1454,18 +1458,15 @@ static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
 	journal_superblock_t *sb = journal->j_superblock;
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
-	read_lock(&journal->j_state_lock);
-	/* Is it already empty? */
-	if (sb->s_start == 0) {
-		read_unlock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
+	if (sb->s_start == 0)	/* Is it already empty? */
 		return;
-	}
+
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(0);
-	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, write_op);
 
@@ -1488,9 +1489,8 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	journal_superblock_t *sb = journal->j_superblock;
 	int errcode;
 
-	read_lock(&journal->j_state_lock);
+	lock_buffer(journal->j_sb_buffer);
 	errcode = journal->j_errno;
-	read_unlock(&journal->j_state_lock);
 	if (errcode == -ESHUTDOWN)
 		errcode = 0;
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n", errcode);
-- 
2.19.1

