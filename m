Return-Path: <SRS0=DlHj=QT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CDDC282C4
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 05:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A612D217FA
	for <linux-ext4@archiver.kernel.org>; Tue, 12 Feb 2019 05:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="MeAZu5y0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfBLFMr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 12 Feb 2019 00:12:47 -0500
Received: from mail-eopbgr720139.outbound.protection.outlook.com ([40.107.72.139]:6327
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725550AbfBLFMq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 12 Feb 2019 00:12:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhervjRoGf0lLYekpE2FBEEC1GVY3HwrRM4e1Vz/crk=;
 b=MeAZu5y0S8dGXnEZrs6gnkEes9CvSp/m2V8nfXWcVbhZoWfpOCboULZj1Bx/C1PVUV707Zj9h1mxv73dLLMVtyi+YBb/Y/I/EzN3MMCQ/GL7Xr+BVFuqzGXMzKxF9xVAGpwZ++feEiUCk21ymKvtW3a4rWwsOeljEz0PI6u/TZs=
Received: from BN6PR0101CA0012.prod.exchangelabs.com (2603:10b6:405:2a::25) by
 DM6PR01MB4537.prod.exchangelabs.com (2603:10b6:5:79::12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1622.16; Tue, 12 Feb 2019 05:12:42 +0000
Received: from BY2NAM03FT027.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by BN6PR0101CA0012.outlook.office365.com
 (2603:10b6:405:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1601.19 via Frontend
 Transport; Tue, 12 Feb 2019 05:12:41 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 BY2NAM03FT027.mail.protection.outlook.com (10.152.84.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Tue, 12 Feb 2019 05:12:41 +0000
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1C5CccF022809
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Feb 2019 00:12:38 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 04C2D7A4F02; Tue, 12 Feb 2019 00:12:37 -0500 (EST)
Date:   Tue, 12 Feb 2019 00:12:37 -0500
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
Subject: Re: Proposal: Yet another possible fs-verity interface
Message-ID: <20190212051237.GQ23000@mit.edu>
References: <20190207031101.GA7387@mit.edu>
 <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHk-=wh2j+Yy28H_QxEdsP=k9xcHxjCG1PqKAF2Uv=ckK8oPug@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(346002)(136003)(2980300002)(189003)(199004)(46406003)(446003)(106002)(11346002)(4326008)(16586007)(305945005)(229853002)(58126008)(2616005)(786003)(316002)(52956003)(54906003)(42186006)(14444005)(126002)(476003)(486006)(8936002)(47776003)(26005)(36906005)(50466002)(86362001)(6916009)(88552002)(76176011)(2906002)(26826003)(478600001)(186003)(106466001)(36756003)(90966002)(75432002)(97756001)(6266002)(6246003)(1076003)(23726003)(356004)(8676002)(246002)(103686004)(33656002)(336012)(18370500001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR01MB4537;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;MX:1;A:1;
X-Microsoft-Exchange-Diagnostics: 1;BY2NAM03FT027;1:SAhNkf50kTY5Pkooi8VABJq/p3bPFRyHhuafs0wbKhVD25iNnW4zGP6TIBas8qpNrAVEY66Y8i5C2mgLX1jtQknLVwPouODrdT4R5R/VpR/enKnR6LwKQudDSLqQfIG1hoyiMTu4nvpIc73FEkU+pCQjFxh2eGTmXQMX98S5tHE=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dc092dc-7a30-4141-015e-08d690a8b6cd
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:DM6PR01MB4537;
X-MS-TrafficTypeDiagnostic: DM6PR01MB4537:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;DM6PR01MB4537;20:C52ZT30kA7AeKqD/6+xZc0pS7dMHcykvbbpvlh2EYooyi4IXcA1bWxZiHYEyGBfgdyHbcxyHPKSw37GBs1yc482/8rCQ2etB/6cgqmUmzomycfjJNCichBsqtKlMpp6fdAZEW782oDST/h4FEE57ROLJc+rkEksjCtnWqZxFQ4tZ85nFVwlRYTJ39YNdyZ7lzNPrrg7Zt/spwMx24dscoI+hzChT42o6s6PF+ccTvLRDw9hHGCw0U/5IFekRimyAuy9Lry7q4icS6eWxflZ3HeXQ13QytOHn9ywur3/1qSveCwBI22kPs+0rgNtM1ZWlFm80uu6ODatN1ckCd2xyL0jCVLSXspPzJv1VzREclYZ5DB89huAJ1TqPU+3Iw3FCgbIYpOjAaWYwp4PpYYm4JGl5Ry9QBxtHb87l1jY9eJ1BpWpEsUKszr3F1sws+dRRuvLbCs8biCCohV/oWBkESWW8vNNuQjsQ3WVkG14H6V1PuzI7vHRMSCsqe4ggGfMYa+2o7sMnr47ynPY2wV0r/hCFl0HxKrGUiKGXQtUF4phXJrAe1dWS5IiasrliKQI/9rpiasFehjqKzhYS03xwTno6+or9VSalk9PHBzkx9ac=
X-Microsoft-Antispam-PRVS: <DM6PR01MB45374FD65A1B83A00ECB2101B5650@DM6PR01MB4537.prod.exchangelabs.com>
X-Forefront-PRVS: 0946DC87A1
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;DM6PR01MB4537;23:qwD1HBVpfsjgTqeXbDRQaAlR4agOggmnPfe+3uMBZ?=
 =?us-ascii?Q?QvwLGp6NHrOsjaiHaJTxNInmrUo3AwAMkvCgfj5HgSJrqvFSiC7Akv0o5gAi?=
 =?us-ascii?Q?ByQXPzGts4GbENWe7YJDB5rrCDfkYM7KaBY4zyfED21zZGHMlg7dV/n/tfjO?=
 =?us-ascii?Q?g2z7cVkEoFvTiJ/iC2IIYSO8DuPepgLlmttHnA/+LK9I1MYHlJfil/9sD8Zg?=
 =?us-ascii?Q?ufpuUl06K4oV0mbPdMsy1dnTvtdfh3D0TjVbw7nnkdAqJxLR1QuWaGaMb0JH?=
 =?us-ascii?Q?Cf3/RcU6Cc0RWJtQQv9nWdaYc2xVtQcIF+FtUN6jDBirDIOFrh+QX0L9PKk1?=
 =?us-ascii?Q?hL+e93LoEkr6MhCcdjChivdbWll1ziD/Pgo/XrmixISqRTwo553LywYqEj7E?=
 =?us-ascii?Q?81PNS1V1wrumF1Z/1JnHamgzCBN+qb+AF4raRvAZUMUDm5n+9gNXBu+nPoxC?=
 =?us-ascii?Q?+6UeUEcMWmLSXrEBdvcUDdw/lrd83+UamUGlVw3TkPAveWmPJ32PodJ/b/tA?=
 =?us-ascii?Q?n+EZOMbtTLmWK8ZofYoP0XqcLI9f6bihnjVquTkKlEcg9wgUq101zTtNJilu?=
 =?us-ascii?Q?kXqDjb4ipEwIdXkqZ9KS3B6bw1+Obl+CAxjnlxTLHqwuRXaz+9rBLykQMNiO?=
 =?us-ascii?Q?fAv5HwqAml98Rb6qQIdu2ld5EHQ5768DpAapXxEOBlDvrbN0MMjCB03SpXMo?=
 =?us-ascii?Q?lgB+gWcopJjg/cs8ykzIGvJyqGcw39nxfoQdBR3osnvvQEav5LCpshaZlOIw?=
 =?us-ascii?Q?AabyavdOXTlKP7BtVpqnVDjFPRvh/n/7pA6fvtAGGlDfjoYiBBnetFXww8pv?=
 =?us-ascii?Q?HWX9aALnNJBkLQnATUcXcfJiWJVUeiUZ6TAGPhWhGJ78gkT8mQVQfjfiY3WF?=
 =?us-ascii?Q?Jh3Ko+AR7TyVseIhixye8Fcbo86WVBW3JkWCUbjzHC2gbcdhFkuC1Vy/H2WV?=
 =?us-ascii?Q?PaJLAc8EpWQnj7V9Z10i/Laz6pLGRaoFLrPSd1fnDX+EHkvZKA7pWfZdter+?=
 =?us-ascii?Q?vELjeJsdl29r1MylrBoc038p321Fsr+XD3Yzi0I6zubz7tPu6oAeKxUohoIw?=
 =?us-ascii?Q?a8jVIjQRK8o/GoRlujsqzFBjf5QbpNTh8L4KbYaqb/njk/1WmgGRMuP37SvE?=
 =?us-ascii?Q?d1wk5xCJmNXkWGtkboj5X588mcoKPkUCjgdKCpeqc9X0bUtLtOSVujMEsF/b?=
 =?us-ascii?Q?KEwIwAEJZi3wZr0EOUCpeVIEkNbu0ppySlWxeGjUX9skWzTa0TPu2tByg=3D?=
 =?us-ascii?Q?=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: Y2sqHIX7doGBbKZZgLGM/B2p30uY7KO3rBNeTeq4xZ5VYDwiA5BbFnpHAwjDHE+tNuWYLAil1/Et1UOrLdw9nMDOHxlaDmp8I7kCfYcX/S3YxwdDMWbMZIsHZRaWjzwldKNX2CnHJln0twQXGSxoiwVnNJrrE7CIlA4LhqCdUzk0pUzMy4/JtJHy8OnzU2dUCGhPoHOgBmxCawSy9pznfDoBFs2JnMFWD6LoOeCHSSi9mmR0wyamgzFlIcy8nDmtKNJAOluMFDqr+rU84ZT2qAHEJCyTw+gdlUt8plE/esp/QYY+ngGJ9x1syjCp3QAxufP0LFJPE1ZHU9SZ/MzVG5bS6xyD3i+9pS87DqqlF9sIktaa6nzj8u+MAEyNIV91dCw8AiqWhzuPQ65L61a1quDz2uSRYkSkKqNWV0RVx78=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2019 05:12:41.1214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc092dc-7a30-4141-015e-08d690a8b6cd
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4537
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Feb 09, 2019 at 12:38:05PM -0800, Linus Torvalds wrote:
> 
> In particular, may I suggest that  the interface be made idempotent,
> so that you can do the merkle tree operation several times with the
> same offset/length arguments, and if the merkle tree has already been
> calculated, you just return the resulting root hash directly.

Sure, I was already thinking that rerunning the ioctl should allow us
recover from an interrupted Merkle tree generation.  So I agree about
it being idempotent.

> Why? That allows you to "validate" images on filesystems that don't
> actually have any long-term storage model for the merkle tree. IOW,
> you could do the merkle tree calculation (and verification) every time
> at bootup, and on a filesystem that supports the long-term storage of
> said merkle data, it's a very cheap operation, but on a filesystem
> that doesn't, it would still be *possible* to just calculate the hash
> and mark it "finalized" for that boot (or that mount). IOW, it would
> work for something like ramfs (but you could also make it work for any
> random on-disk filesystem that doesn't support long-term storage).

Well, we *could* do that, but at that point we've just transformed the
Merkle tree to be a very inefficient crypto checksum.  The whole point
of the Merkle tree is that you *don't* have to scan the entire data
file before you open the file (or at boot-time).  Instead, the root
hash of the Merkle tree is digitally signed, and you verify the file
as you use it, block-by-block.  If there are large portions of the
file which are never used (for example, because they contain the
Russian language files, and the phone is being used by a French
speaker), then we don't have to read that portion of the file to
checksum it.

If the file system doesn't have a way to store the Merkle tree, and we
have to recalculate the "Merkle tree has" as a way of validating the
file, it will be *much* faster simply to calculate the SHA-256 of the
file, and then verify that against a digital signature of the expected
crypto checksum.  For a file system that doesn't support the Merkle tree, 

> At that point, the merkle tree thing ends up fairly equivalent to the
> IMA "measurement" thing, with the exception that the filesystem *may*
> optimize it to be long-term. Hmm?

Well, except that it's just a less efficient way of doing IMA
"measurement" (if the file system doesn't support Merkle tree
storage).

So adding that complexity is, in my view, not really worth it, since I
very much doubt anyone would use a slower scheme.  I think the much
better model is that fsverity is for file system where you can store
the Merkle tree (and it's really not that hard for most file systems
to store it); and if you are using a file system which doesn't, use
IMA in good health.

I've talked to Mimi about how we can hook fsverity into the IMA
machinery, so that if you have fsverity protected files, that can be
used for the audit log (for example).  This basically means treating
the Merkle tree hash (which is stored in the fsverity "superblock", so
it can be fetched without pulling the entire file into the page cache)
as a IMA "checksum".

This will have to be a policy matter, since there are security folks
who like the idea that the entire 100 megabyte file must be paged in
to be checksummed *first*, before it is used.  That way, you know that
file is 100% valid before you allow userspace to start using it.  In
the fsverity model, if some portion of the file is corrupted, possibly
maliciously by an adversary, the program might abort in the middle of
being run when the corrupted portion of the file is finally used.
This is a tradeoff; and for people who really care about "how many
seconds before the user touches the facebook app ico, and pixels start
being painted on the screen on a low-end mobile device", they'll take
the fsverity approach and avoid the IMA approach.

So yes --- we can tie into the IMA framework so that if policy allows,
it can be used instead of the IMA measurement.  But I don't think it
makes sense to try to use fsverity without the Merkle tree being
stored in the file system.

Cheers,

					- Ted
