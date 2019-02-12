Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA78C282CE
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 17:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F6DD20700
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 17:11:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="b7OwjCVC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbfBLRLU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:11:20 -0500
Received: from mail-eopbgr760094.outbound.protection.outlook.com ([40.107.76.94]:20552
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729536AbfBLRLT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 12:11:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORamBFDRIV00CLhS3LUHcO/GmG4g9XMk7QoJZDhu69I=;
 b=b7OwjCVCyfgdwDGZGVtUyStJlulDezlw8bLrlLAiQ9ThcYbgtrrguYRAdL3WXZHrQ7lzJ/f0knsX2B89WhM31CYxOoZuSU6FdZgiruILaXAbBAaKBT7eBwY/xClj7kf9dJ2yvemqSMA8sWL8lfTPOHciSjMMbz6ysOcDEwG5T9g=
Received: from SN2PR01CA0027.prod.exchangelabs.com (2603:10b6:804:2::37) by
 DM6PR01MB4938.prod.exchangelabs.com (2603:10b6:5:57::26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Tue, 12 Feb 2019 17:11:14 +0000
Received: from CO1NAM03FT029.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::204) by SN2PR01CA0027.outlook.office365.com
 (2603:10b6:804:2::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Tue, 12 Feb 2019 17:11:14 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT029.mail.protection.outlook.com (10.152.80.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 17:11:13 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1CHBAji013865
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Feb 2019 12:11:11 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CF5927A4EA7; Tue, 12 Feb 2019 12:11:09 -0500 (EST)
Date:   Tue, 12 Feb 2019 12:11:09 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        <linux-fscrypt@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: Proposal: Yet another possible fs-verity interface
Message-ID: <20190212171109.GS23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
 <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
 <20190212051237.GQ23000@mit.edu>
 <1549982679.12743.248.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1549982679.12743.248.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(396003)(2980300002)(189003)(199004)(23756003)(126002)(33656002)(336012)(58126008)(54906003)(76176011)(2616005)(11346002)(446003)(476003)(36906005)(786003)(42186006)(316002)(2906002)(486006)(26826003)(88552002)(2870700001)(106466001)(90966002)(75432002)(50466002)(26005)(478600001)(93886005)(186003)(52956003)(229853002)(6246003)(47776003)(106002)(6916009)(8936002)(1076003)(246002)(8676002)(14444005)(4326008)(6266002)(305945005)(356004)(103686004)(36756003)(7416002)(86362001)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4938;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT029;1:8dPst4+9Qsni5xGeJJuQYSMjulMIvW6Jd/hWmHfARkX6Um6RESkdq+Tuxmu92+KvkgyQZcnSSzJ9lO6Xgp11xC6hV3ObNF6gM9GYxcjgTxh4kvzk9Clrq3MNMJYrWNP1bx8SkqG8Adp8ko7fzQ9skQ==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fc2de95-9933-4c38-d763-08d6910d17bf
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB4938;
X-MS-TrafficTypeDiagnostic: DM6PR01MB4938:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4938;20:5VS7kLwFiPOEH4iZ20v9eqlFng2RLqwl0eza7Iz7Wk/aop2P3NzmdagaaWaFfVeCx/61tU+iAcP7oBVjExsPr659VeozB5e6rLcriAWooqjSXdFDMhsNGvMtANakP6pYswllzIKqI254+0z7TK82lSDBaVPxufRmEkmv6ouSFhOcXMl/2AFyMPh9lsJJmbCplViAd5Renc0i8SsvM4el9l9YRap5l3yX7jenpk4TtRQ6atpJ88WZR5fkIPj0sJRbRxbALqLHqEbLhvkgEvtdG7tOW3IAA2jIVnmzdp4c58l727fsaj5vvTutOc4Rvm6Gg8f0409nAHIiGzYvN4+FzqwaU+RCpTnPe5UTnK+nclugkmuNijo264pO7+w9S8acCZSN0QaAgPGj7Z7Ujfiz4Ov3+msH4Wy4dX/B3stBSxJaw891Arfa9nMpIFBe0Z/9/FbLvUTDkOQC5hDAzFqqFhNbbNu8ysXGledxASY8CuRPWDFMwYthV1xjX1cEYtrPnTcmcX4Yf3JdVey2a/llT5TN5BtPfG0od1Y0+jYlhAQkYdv6Kkr4rb4PpgHKbHGPWL6WNE2aRG6b1gY0ic2kXQBHRvcr52D3zbQlvsj+Xtc=
X-Microsoft-Antispam-PRVS: <DM6PR01MB493869F04E2CC95411EF12D8B5650@DM6PR01MB4938.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?iso-8859-1?Q?1;DM6PR01MB4938;23:iuGlMzlwFme+LgjIv9CXobyTEcgp4BFTtjHCpi3?=
 =?iso-8859-1?Q?X9ogA3d/CButXoThOsGySjyOadMH4ampEs02CcsaQYnqCAi76jgHWa8siU?=
 =?iso-8859-1?Q?hBHP3x0tKJ/sbOJeldVfzArIlqS7M4lBrU1DmJvFF7PioN5pL+y/I7szId?=
 =?iso-8859-1?Q?FmPlizlXK5wfHWPCzKN7ebEZB/f+04j82xs5QHHtAgd3e2a3O4gY188to0?=
 =?iso-8859-1?Q?sLfPqJvE7gbOhO8WBptyJKxJcER0/8f9pRUG1UFZ2NXRmQ6kP5/f0LDjzw?=
 =?iso-8859-1?Q?VRxdCizFCBew/qi9WPwgvMKvAF+7GOj5CX2MTcqUJWRZxC6SXQNcd6toDz?=
 =?iso-8859-1?Q?WSjFnVU9fSCfd6PDmdYTwE2SQVdsHezcv9/KB0HyXbRsAQnRAOuW0cAXWu?=
 =?iso-8859-1?Q?e2bQ3awpt089fk3VSSH8UTIDZoIcP8rAYeR4qBw/f0Z/dcn5gd48mT6wGH?=
 =?iso-8859-1?Q?8Y5HaZfGYyZxnjq3OFYtS6mXnDyLJnjaMiisKH/MoTlPqt18GO1WCJeMYc?=
 =?iso-8859-1?Q?OfvUpJpaS4aO1/qqTLVwhJioibZTPkG+MN43KViN8orQY4RFB3ETO4ACPa?=
 =?iso-8859-1?Q?SmxxVnnT12lgAWkk8R0MdYIZzjNeu0tLfrrjCL6Jy9O+XU5ubp1y8dcuwC?=
 =?iso-8859-1?Q?hmKkCp9BFiAxzQgbdAb4mICjOF9luCak5TmMxmwlJr7U2+0sHwuJXk/LTv?=
 =?iso-8859-1?Q?ouZH3qEFPsmETbh9DRlBWfPawsLDaAMEw4roYbTczSZ6GKK83KvJf9q/6U?=
 =?iso-8859-1?Q?nyQJ6pWWtDS6dkLu/2m48lzv88203fDCXo2tQB3SXtRZh3OQx+4r5JheEC?=
 =?iso-8859-1?Q?2K7SWfxEJr00ySsAHwMEg0NH9e61vASwgLJdOX1ghLjEQOyMY4JE6V4TcB?=
 =?iso-8859-1?Q?qPxm1U/4/cCSKO+um2hGct6rDv85aLoSk0HyoA0yjLkuEmwZ/wV549ILBa?=
 =?iso-8859-1?Q?aDhM794mmzegpWkuzYafUMAUYHnwoZkjcXrCgcIyE0kvUCbeKBlysefZzS?=
 =?iso-8859-1?Q?+Qc7Z0oigIJnX/4f7zKG0rQ/kOGZM8IoGNQB71cuCx9l8jX699xC+2rmQy?=
 =?iso-8859-1?Q?izaMXrMJgoVzWayw1CeLmVyAQS/Unmm15MpP7ZvTh7GmHhpZmgOxn+mHYy?=
 =?iso-8859-1?Q?BY/oM+GDMVMVaiuswYUK/gMvD2+mfVVe+8u2VTfEtiWPwkzj5fpBapbrpy?=
 =?iso-8859-1?Q?0pAkEjQVwp7fTk/4xNulJWc/IRd9CIo8wuxE9z4zjTfxqYf9rPjMtI4vvR?=
 =?iso-8859-1?Q?Q9i+DHaaA0J6jUYs/hB76G8K79DjCNBFDFHZpGhynTshC8xSG6BCN3Gnub?=
 =?iso-8859-1?Q?mU=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 9C8GCQnqk/nC4ucrCNBVoWijiKm5IBifZaoGwbLWwVMD94+uZo3Ozkg2aBN6DrruIcIT4cEbmTv6kDXBbarYW5eh1ZFN6+AOt7JIsfO0OdTxamnVeyAWMr9OOEE0VvLq+I8TmBVdd7q6m4OXE4gl+tlj039AX6kFlFt4PPQFnNoY4Sc2+IvT82aEMUxuQe+aDxCKahd2+gg320bfHZSbgH2WcS5mPpVG7iGG/IrQe8fRz6I/2lKXxb+PaZ4diyttIM6aXrLLWiCPf0Fc91zJ0ntFQAgOCeqRNDfnK+aUhGmsVzWdJQGeNwV+z7YlmPtBxef/BLAdb+ceG/oH2kfmZrs0mzZTnLVC8OU9YGLw/UGlEbnIIDOm0UPc33hvqj42DH6CyLipvkk1/DBCICIwwEqcY6VFTbsA/7L3y9zmb7s=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 17:11:13.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc2de95-9933-4c38-d763-08d6910d17bf
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4938
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 12, 2019 at 09:44:39AM -0500, Mimi Zohar wrote:
> Ted, one of the problems with IMA is that the file hash/signature
> verification is at file open.  It isn't aware when files are brought
> in from cache.  Does fs-verity re-verify blocks as they're restored
> from cache?  For some use cases, that might justify the up front cost
> associated with building the Merkle tree.

fs-verity as designed and implemented today *only* verifies blocks as
they are read from the file system.  The Merkle tree is stored on
disk, and we don't verify all of the pages at open time.  That's the
whole *point* of fs-verity.  So when you say re-verify, that's simply
not correct.

Could we change it so that there is an optional mode where Merkle tree
is kept pinned in memory and recalculated the first time the file is
opened?  I suppose; the overhead is "only" 0.8% of the file size.  But
for big files, it adds up; and if you never use most of the file (say,
it's an unstripped executable with debugging information), you end up
paying twice --- once to calculate the Merkle tree (in CPU and Disk
time wasted), and a second time by pinning the full Merkle tree in
memory.  Also, it leaves open the question of how aggressively we drop
the Merkle tree once the file is closed.  Do we wait until the inode
gets purged from the inode cache?  That might pin the memory for way
too long.  Do we drop the Merkle tree the moment the inode's open
count goes to zero?

If it's not too hard to add, and if we're generating the Merkle tree
in the kernel, it's something we could do, I suppose.  But it's not
something *we're* going to use, so I'm not terribly excited about
wasting effort on work that just bitrots if no one is actually going
to use it in that way.

If you are willing to commit that IMA will use it in that way, and
you're fairly sure IMA users are going to be willing to pay the memory
tax, we can look into adding it, if it's doesn't add too much effort
on our part.  I just want to be clear that this is a "yes, we would
definitely use such a thing", as opposed to, "it might be nice...."

Cheers,

					- Ted
