Return-Path: <SRS0=C+hA=QO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DF9C282CC
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 16:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6D782175B
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 16:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="QrW/ND8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfBGQKR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:10:17 -0500
Received: from mail-eopbgr730110.outbound.protection.outlook.com ([40.107.73.110]:59120
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbfBGQKR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 7 Feb 2019 11:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/DHrNYuDGsRbSApfjH6k+ONAWIa0MXJiPJR4fQNy5g=;
 b=QrW/ND8L2BfKO2LMK6Ge4BLk97xPvmV4MXKozWpdIWs2YMUHkTwIUJo8dSFTFQDnXINOojqdmyhyAkx+KCIre9Jh6Rk+FJX34GOEGloDeL8Iot1L14BSS13ANSM1T1tAvC4ocUNXGRs08+8qVtE+Q4RTRO0aLO87QbPMmWfUhFE=
Received: from DM5PR0102CA0018.prod.exchangelabs.com (2603:10b6:4:9c::31) by
 BYAPR01MB4517.prod.exchangelabs.com (2603:10b6:a03:98::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.19; Thu, 7 Feb 2019 16:10:11 +0000
Received: from DM3NAM03FT038.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e49::206) by DM5PR0102CA0018.outlook.office365.com
 (2603:10b6:4:9c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.19 via Frontend
 Transport; Thu, 7 Feb 2019 16:10:11 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 DM3NAM03FT038.mail.protection.outlook.com (10.152.83.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1580.10 via Frontend Transport; Thu, 7 Feb 2019 16:10:10 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x17GA8dS030491
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 7 Feb 2019 11:10:09 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3AD537A2DF9; Wed,  6 Feb 2019 22:11:01 -0500 (EST)
Date:   Wed, 6 Feb 2019 22:11:01 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Proposal: Yet another possible fs-verity interface
Message-ID: <20190207031101.GA7387@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(39860400002)(376002)(346002)(396003)(136003)(2980300002)(189003)(199004)(52956003)(486006)(106466001)(126002)(90966002)(2616005)(476003)(33656002)(75432002)(47776003)(26826003)(478600001)(6916009)(46406003)(50466002)(106002)(336012)(186003)(36756003)(4326008)(305945005)(103686004)(786003)(2906002)(6266002)(36906005)(26005)(1076003)(54906003)(23726003)(8936002)(246002)(356004)(316002)(86362001)(42186006)(88552002)(58126008)(97756001)(8676002)(16586007)(18370500001)(42866002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR01MB4517;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;DM3NAM03FT038;1:YvIdZEmpUL4ZyYuvjB71B2mPDdxwCqe0b9GfnS3Hq4mtTdqeIgG2lortQJTz07k7VaiXfy+04gxRfEkQXsPbH4v+zoRdtMcEzuU01E0MY9L56IJnWPtCXoMNoqPyoIfDIljvkf4CIXgNn7wO5EKctqNIzs9SlI10uO/rx9sm33w=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12d94a13-76b0-45da-bc54-08d68d16bc98
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BYAPR01MB4517;
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4517;3:vTCM0LRzWUY79pYql4OYndlGiL5LA+P4tAQx2w+Sg0f/UoQ9OaFZJ1tbUQlThvLLQmxlQAnzdMWW20JK6A85dSIMGKkDNnLGQEg8/MMhDdoloVBA+wuUmV73cLJ2jCfKf/8lG61LP/s5oPVyb2qzh3CP9plwJzksuIFN9i8ARzCSrjCpdJGnU56sI/S5OwGKaJZEb97kXDMzSwzKk6k6d68c4CfdQiIkuWzPuEKNDeUERIqtnqqV2yR1zz403JQlCYV/d8Ta98i6YLYGO6Ths+KZ30Vq93tRh5P5Wo64EXa733FzXSE6fOBoz0II2GCshwjWT6sllrmtnDqHe5en5u76Rg+c7ASUKD7v8VTO4poKBSt/5BmLtI8Nb08zGBEU;25:AdkJVzwUm9zfVc0VtR/ApTw/U4I6cy2stxzjCpsHiQaYiKbzcc7I/2sI+W+LTDxF8LU3IZ+9ivaK+4u29ASEPNbAKkfQaiHBLKfq1MTRdRiyg/L9JoqLsT8qtwJTTR4Xd0D3nLtfpXgNiGkEdsSizdNjnRWfE8LlKXfjnjHhPkSntxQxmI2uahtSwHQsjDkzlomr168yM6kwBuZJlFieMBJVYSe0ky9ju227ti6+WT9R44oh+zV1GubYN+dfFPdrfBjnenAGfE2hg1bB+hHeVe8rgO1WkStD8hgXDCxCMsH5pyTgRN1puhIJvM96dc3NbgxtpJELYQyy1prFs/ayMQ==
X-MS-TrafficTypeDiagnostic: BYAPR01MB4517:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4517;31:7C2pi8U9DuA6uapnkELwrS3ZVY8xvxRSexAgCAUEUKUEBD5R0SzoCsx7vjJgwvJYu9RPMmAbIk+w17bqsRwY7iP+nm6UoS/fYiDiFjFzCd9oh8K5tn1I4k0c87im63dWEy0HVmA2mZLUF6kmxnkcMxUvY/y57TkNhKEMtBo00f6IigWVVMyDHc9BGED2fKgrru2uzAl56tWDgQAAWC2KkVvN74hYaxlGtUdHvUXIDZ0=;20:l5Seh87Qlhq0LNIvE5/ZN90xPDcmTZUqFP+k5vw3sW+y+6z3ms0iLGoofkhoNyve5GoVfpMwaFksRBav3PsuMu9vxT0V/vSFRs1ITDA6RJgTVHpgyByjN0/RzQ4EVE56kGA7Mpx42C6GGZ5hl1L5Qy5b9La7eBAPcR3nTnOiFKfnS92obAaskJQKFdh86mm0wG5zdAarb5gRQUZxv1BaKmB95/RdbBVkzETB6D1QdVap77751wf/kkHbrCEKkWfJYUatHgHOx+ecs4/0FNPnLkWxwUen2ls1Lzt0f6hNh8QTGRmt7tnUoPljoXWz60QRhiELsxF2luUTl+UIgQ8v5nXiZC/lk+jIWyQaryp7e52Vtjo47TzT/Inp+uuBc1M/WPf3JSGzHPjiSSdiBYz3Z9Dp8atpKFWH/TVvVSZfXSbYLTkDo06aBBHSINlnead+3AgH/kNa5cUcrfBUcb3fNu/SvowQBbZrQlOTu/iS4b/9u/kOa3wWwZuojBCV1M3Q7imJgLjI7HyU4kGQKPs/cHt4CgaUY/ZXT4aaCfLyGkQaGbsdbjr+IRoEIKvyRVOYrqrnaRaRDWQ+v2y5075P0tYcEIH6d8WmB2cGfqGblA4=
X-Microsoft-Antispam-PRVS: <BYAPR01MB4517F20E62A2640F02338777B5680@BYAPR01MB4517.prod.exchangelabs.com>
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4517;4:j9FTPl8DlHtBVhi7w3G5sM6D7CJ3KVjnTgCti9PnRdj0FXAjxRyt7CKuvauk2m5Ml0GYICZ1S4XlA1Chzt+VCNdJelwxokFBdhSadG/lEU3Jf3Ry5ngE1JwxdaEtLuBBrn3aOgRmOjCXV0jSN5NJjDG46iwdivPWx/g2flyUy0O74fyMj+n4G8Hmpgl3qAwHK9cmCWTR0UKpGz3JCIg7p+dtsg21KrmBAGZJKG4OYSgpeZX+zDGsPg6jEZ1yHhofRTIG6fcIPyGZdZVfidGdKag2Od1xTI4+GGBA30ZsLduy8AqTwFET/VhSC9wxQ2kS
X-Forefront-PRVS: 0941B96580
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BYAPR01MB4517;23:0L0ajVNn8cpnO30dFFWXR9TAIYcKIjdDCBdFl/Vaj?=
 =?us-ascii?Q?9kZXg2+V6eRo9S0raoNQ2uIKJsUQO+lo6sKeqJIAuSRvxkueNfOPXpXg6EMy?=
 =?us-ascii?Q?NSMoqHEGK+orlFJ37Zb76AzxfurmLhLycU0mht9++HDrgxR0YhHaEZYHpDBC?=
 =?us-ascii?Q?uHfJOQJqchDmvhvCU6nPxCIxZso0vPOqVoVe1iEig/cdqcIPq3ao2KMbOpYj?=
 =?us-ascii?Q?rsN1sQiKM8+gwaGustkzmEXvqd6qDAn84OCoOiQys0VGwGfZKlCkFJ+UifZB?=
 =?us-ascii?Q?B0KT5t16CCDRv/VajygXShDQc1QhVBZccb2y1pQOn2AHo7cj5MPeZ8HLsqdd?=
 =?us-ascii?Q?+3J1oANHMYq6UmK7WE/8nOpbb3I5+JARAL9vgegah4IFpnuqiV5+cogFlJDp?=
 =?us-ascii?Q?IP6akRlaenT3+v2w9t1ISzEEWW/dF6BamLgEELnuoHSK4PoC+nf975ljFnAe?=
 =?us-ascii?Q?LikXLrQj8e8LMRDTTcfBOVbh74FfQdbH8uLBC4tJPEkX8idLKZHhpNtRVmS7?=
 =?us-ascii?Q?gZub3Wb8i1XL1oczL7EFpRs917t9nekylSGIuLkjEgcMMpYRlV3F+Kc644RL?=
 =?us-ascii?Q?Yl4OKEc242qN6/mI3kpASGzhatrFPIL3geYYr4jrh3iVCq1Gr2Lan1ScbnUZ?=
 =?us-ascii?Q?qMJm4/vzH8V+808v/HiYT00TZxHionQymuxhs/dTfdla2NiqdCAJwOlseapq?=
 =?us-ascii?Q?97a1+q/cPKCFNvkk/e05aG/jOoVpUltzKlKiUGBJs9wNx7ZNbnwFXizMdEuC?=
 =?us-ascii?Q?ToaapEKCKURibFU+GeID6s3OUUpzY62ktwBqxvUOdE7sGKsAyhdpCJHLJdrO?=
 =?us-ascii?Q?sWqKhDh7Pxdn/zYH+wtamkbN1Tjugh40L4cuCfW1YOPaU+AC4KrDwRmiCHO7?=
 =?us-ascii?Q?3UTRqwXmVz30vX2YxEIA9RXbqX09OBicRyhIW0Tit4KXB3R0bTiE5w1Ei/La?=
 =?us-ascii?Q?Cg/LhdHjfchfYsKTO1uevxNu5IA9Ed+pZRLJJ3cchp8h5gRVw95c1C4bTvMA?=
 =?us-ascii?Q?4f1XIyiuGSo4fcvKLt5BZCcddEYCCYFmy96H0lLJY5QL+LpemRetkJOWcIO6?=
 =?us-ascii?Q?RRFT+YiL5QJLmxBNwO7uTalbKILeCRLSWAS5hl+c7SPYX/B723WKPcMqDkFr?=
 =?us-ascii?Q?MDPcauhQ67sZMdnrL1ST4Ilj9tJUCUhLblYvx0xbS+ac1lx54szSi8Z6PiQg?=
 =?us-ascii?Q?TsX/wTTk0UYWQkrGA6RM2tjfG5OoHJD22bfLzJWnGfuctw1p6X+1vgYcw=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: mQs9LaHcFJusbOjIL52tAsGNumeWdK0mHe0ARzjvYN2vNkQT4CjtyjIi/zovi75KSSXs+t+F890GCI4uXZINfJ9QYuShkn3ek52S0LxOSFWhRDH9e1MYEnmENhUk5zkMkWlPoWVyMJVa1ccwOLiaodbYcMIdVN7Il1y5CQar/iHl6sDyVbVcuA4FYuK+SBLC8B7ChILKSdg42f7QgwCLqsFI3CX7THQD6C3c96QhAcxsCeRZiDIe8morKj165vbrTZSMDc9OHw/8+mYLuFwcYqVCOT2j4Sc85qbFWTimoHlLi8cS11q2gTdr/9AYfparHsctzElYDr2cpsCemSiULIzKx2OnQKTmyjjD6R55EPZANnzyVmmUOnCF/tdeUzDAzvE0U00Qxt4aN1jtiGouH6FhQT5TSaH6zLK3YhHeX+s=
X-Microsoft-Exchange-Diagnostics: 1;BYAPR01MB4517;6:gCNvmfGmOTu3Rq8TqTHG+IeUe7J/2mDxzuLjSEB/b7B3QLHuFpGDJBb3K1/+/7FkNSSA9QRnvcXccjk6CArJw+ufAdQqkqaGWHH7GDeNhLrIPIMv6bfZptBkeZtSB8KY0Jq1mN0YrF2KOjOLcSlf8rci6+/DOXSHck8Y2rUpRuUoDked1x/N67+O8F7Owt+bKquwHXlackNFfjnNcMhCVTNL80W650yVxIdrp95ViLE18hPAt4vg5BWrZpHoF4pNScYWjZlJnKWOs/8sFAjZgCcsOza7C2gaUP2gditathgaiZYJKOWwpjmMIWmfUo8ej1HsSHU2AFTNnkgdLVu2i0Ttbr+eKoiIEwhhvdhxN3Jb4qrn9pWDVZ0fcvHuoUDwKo70JxOhZSp5Mt7Fs34yxBvyoatjLewzVaiDv5992lVN4v75RgEGFqQWfbdNvODWuM85Vji9r0x1F9vRJMXSUw==;5:KpvJHCcpvzMiHxs6JaudqWCk6ghOmrWHPYoeMhLzPLSsx919RlOKwt0vWBP93mPdkDqQ9iCTh11Atx4Ke6aYF5naVWpqP1m/+q9BcKDoonqCVfAtCy46g8UoKfl96MwfUcIelgBN//atn0opYQDx3Vajp1++nturQuVyavfkQ+idf5S0ruTMKdmVZbBJQElsYa7xNXA6LRBWeEaQ9kuggA==;7:wK7bcVqK+OgCWlRbuH2ZXwrOEHQGseUtJYIWRV3VAuTv2Bd4G8gWnV21T3qblKfQW17HOdyQltVm6u9Xxtw67MpAhz/Cvvmm+o9FRdmm5wecl/DfLDAn/fSjoK2QBB1PGUJR4cyLka11u5mzn1YZOw==
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2019 16:10:10.6352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d94a13-76b0-45da-bc54-08d68d16bc98
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4517
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

After doing a lot of thinking and conferring with the other fs-verity
developers, our current thinking is to simply move the Merkle tree
creation into the kernel.  The upside of doing this is it completely
bypasses all of the complaints about how to transfer the Merkle tree
from userspace to the kernel.  It avoids the complexities of
redesigning the xattr interface, or creating a magic fd which could be
lseek'ed, mmap'ed, read, written, etc. to transfer the Merkle tree,
etc.  Calculating the Merkle tree from a code complexity is going to
be simpler.

The downside of this approach is that it can take a lot of CPU time in
the kernel (it would have to do be done in a kernel thread).  An extra
bit of complication is worrying about how to handle the situation
where if the kernel crashes.  The current thinking is that the ioctl
which enable fs-verity protection on the file will make sure that the
file descriptor is not otherwise opened for writing, and then set the
immutable bit.  Once the Merkle tree is written and finalized, the
fs-verity flag would be set and the immutable bit would be cleared.
The exact mechanisms of crash recovery would be file-system dependent,
and TBD, but would probably rely on the journalling mechanisms
available (e.g., ext4 might rely on the orphan list; f2fs might use
copy-on-write semantics; etc.)

This effectively moves the complexity from the interface (which is
where we seem to be getting hung up) to the implementation, but as
stated above, the actual code to create a Merkle tree is fairly simple.

Hopefully this will cut through the current complaints of the
fs-verity API.

Cheers,

					- Ted
