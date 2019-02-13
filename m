Return-Path: <SRS0=kW/n=QU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9873AC282C2
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 18:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FAD20811
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Feb 2019 18:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mit.edu header.i=@mit.edu header.b="EgXWShiG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393951AbfBMSxm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Feb 2019 13:53:42 -0500
Received: from mail-eopbgr710116.outbound.protection.outlook.com ([40.107.71.116]:39651
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730918AbfBMSxl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Feb 2019 13:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqy05HyrjHBlkMskkDYurM3+EokRZbCIt2AEEDmvAmY=;
 b=EgXWShiGIV8nyrC92xtTECn8b4lSFT2tfYifp03cL6mDyUYtNrTD4hAGdDAeklV4WHgyUvkGAMzWZ2+y4AfnJt7MCfW7m0l+xaWy5FyZNw3h74aZlbrNq03w7BVv9pA3wvtnlnA+FFpOlnLQM7/IZlUUdh6UGw7otnXcD52obZs=
Received: from MWHPR01CA0040.prod.exchangelabs.com (2603:10b6:300:101::26) by
 BN6PR01MB3204.prod.exchangelabs.com (2603:10b6:404:d5::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.22; Wed, 13 Feb 2019 18:53:37 +0000
Received: from CO1NAM03FT037.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::205) by MWHPR01CA0040.outlook.office365.com
 (2603:10b6:300:101::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.16 via Frontend
 Transport; Wed, 13 Feb 2019 18:53:37 +0000
Authentication-Results: spf=pass (sender IP is 18.9.28.11)
 smtp.mailfrom=mit.edu; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of mit.edu designates
 18.9.28.11 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.9.28.11; helo=outgoing.mit.edu;
Received: from outgoing.mit.edu (18.9.28.11) by
 CO1NAM03FT037.mail.protection.outlook.com (10.152.80.241) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1580.10 via Frontend Transport; Wed, 13 Feb 2019 18:53:37 +0000
Received: from callcc.thunk.org (guestnat-104-133-0-100.corp.google.com [104.133.0.100] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x1DIrYSl008678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Feb 2019 13:53:35 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 82B837A5755; Wed, 13 Feb 2019 13:53:34 -0500 (EST)
Date:   Wed, 13 Feb 2019 13:53:34 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Vijay Chidambaram <vijayc@utexas.edu>
CC:     Andreas Dilger <adilger@dilger.ca>, <linux-ext4@vger.kernel.org>,
        <jesus.palos@utexas.edu>
Subject: Re: Selective Data Journaling in ext4
Message-ID: <20190213185334.GY23000@mit.edu>
References: <CAHWVdUVW7VMefDQBpas4Trm2SrJupKqKSgAXN9ZiMWJFQCryKA@mail.gmail.com>
 <12FEF208-5FAE-4EE7-93D1-34359A0CBE4F@dilger.ca>
 <CAHWVdUXwzLoeqGjanWYcwQvUqZKJnQnuiSKx=_PjDOz4t1Ox7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHWVdUXwzLoeqGjanWYcwQvUqZKJnQnuiSKx=_PjDOz4t1Ox7g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:18.9.28.11;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(396003)(136003)(2980300002)(199004)(189003)(36906005)(186003)(88552002)(316002)(1076003)(486006)(16586007)(75432002)(42186006)(8676002)(336012)(2906002)(786003)(52956003)(246002)(8936002)(4326008)(6916009)(58126008)(86362001)(106466001)(54906003)(2616005)(11346002)(446003)(36756003)(126002)(356004)(106002)(476003)(103686004)(478600001)(6246003)(2171002)(26826003)(46406003)(14444005)(23726003)(50466002)(6266002)(26005)(97756001)(76176011)(305945005)(33656002)(229853002)(47776003)(90966002)(18370500001)(42866002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR01MB3204;H:outgoing.mit.edu;FPR:;SPF:Pass;LANG:en;PTR:outgoing-auth-1.mit.edu;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;CO1NAM03FT037;1:IRz46tc48vnHNDajeussDuoqja6wun8VxsUeRZIhz9tsOzNyOksQ6RAwh8TD65BUixY+fz++3irtjXi+m3Xiz+4lEYUv/N3wn7LOzDF0FyfhrzUvpNAiqSSWpt2ULBWyPwrL7iqSzjuhLViP1vj43w==
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2edbf58-2229-47d0-edda-08d691e49003
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BN6PR01MB3204;
X-MS-TrafficTypeDiagnostic: BN6PR01MB3204:
X-LD-Processed: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b,ExtAddr
X-Microsoft-Exchange-Diagnostics: 1;BN6PR01MB3204;20:Ob67uRCvHOr7KbNfhl6I1uVGiwCvc7rWbqotqntI7v+L3j8NUZliU6tvI/cHQ+qPBey9RvDgelSRsiPC09SRmOgK4snBvqr5aa0LPiukHJeGrobd7bhbwUN7YsziwYZDVXa7nw+rFv1LbhSaKlWwbhm1Sg4MTdFpGuMBaizLEsLc4TVdqV1qHPZSdfESaYQ2cubTuqOveBCOQumnSgF9/mcmTlrLJ6vSdwkaDzJoWM6Oo0GZjfEJDdh/dKBNObR7s/r4vK7MZWFbDQcp6KmxJ1XS7hT+eM35asLH7y4xeTgdunmkwfCCqgTxyEpUNLxdtXTFYJ8yMT3vNKAZ9R/4n4JOTDfi38aRSzSbrTwRFwczKgeTt1w4R01VPjH3fzrh2UbLmwK1rML9OCPTJZ/LBQtj1r2zTrQIUEzgpUYq28wCg3Hfp/SiuUkVy7qMMS86LEDBL61XE2n2M4F4hZnFb8Uz7iyK9IbpfDkSAxsqdZQVDRcIq0Rfog7+Dz5UuTjKJMh0ctwnHaOLNM4Kodlis077Hch9H9O4tRbFUDJ/XAABnPOxD4wZQhxX9EavHsD8q/mOeATFzJ5ICXNGBZipObA/wAMn1tZIVdFmw54ChOU=
X-Microsoft-Antispam-PRVS: <BN6PR01MB3204A6D0320D0AB15A36668BB5660@BN6PR01MB3204.prod.exchangelabs.com>
X-Forefront-PRVS: 094700CA91
X-Microsoft-Exchange-Diagnostics: =?us-ascii?Q?1;BN6PR01MB3204;23:aWcOa6aGRLpPeLPfRwjoPmLBczR0UAfkTDmGs1ezq?=
 =?us-ascii?Q?oBbJjRB7CczWYZghxJ/ZJGFE6ngwyxBstqUXqulSjopkdsbOR8zlCn4YH1Xv?=
 =?us-ascii?Q?vcAB8GUPcLYv0HZk2MYTSnlpjTb2NtSYjSOHhYDO6GB/UTon23TlzdvJR/96?=
 =?us-ascii?Q?l8ZhZFcSTrmUxrU2gMJH0yI8Ys8vBvcmzq7C5wyuGHgADpT1OIdFBtUe4Lxe?=
 =?us-ascii?Q?1JJQJbH6SxX5+Pgv4UM+8XiHfALwNtW7Y+G1ffbwTAcSz1UmmnvoEBImHLFD?=
 =?us-ascii?Q?dVmPzg+pDNfxPIXRW0iMxARBXUK9Ty6k23yC0xEmD15oiD9kQmpmjoDOp0SM?=
 =?us-ascii?Q?YXL83jtvNHkB0XEUlTwvWfmlJ0dIA14DN7S/iG4lGvh0mLgO9fNmkTMBQZ8m?=
 =?us-ascii?Q?+jDCVuVwuvZe/zIEkaxngfcSHwjz0qaG7GeJOclWcEQaYmeVwYenChq4x/ID?=
 =?us-ascii?Q?ZKjTCcjMv8hHsH1F/uTLf/AL7uTYpC35axQZMUtZRyR2TqfRPes0isDbMd9k?=
 =?us-ascii?Q?lNaPrQngD13HLC5Ofr0cr811OqRVNUxPaODG4K4pqMbvMuLVT0dihgZlKydx?=
 =?us-ascii?Q?mUX6DLsfp5tk3+sLs4cksVA31FKW9V3GdtWY695VrxWtKsMBtf/VFhwTF6RF?=
 =?us-ascii?Q?fX0aPy1lSOmO3ibE5Nm1nV+9K79/pI8lUCC9EhWpOXZ2Efi+NCN2av1nKctk?=
 =?us-ascii?Q?PI5ThNCdCxE/uZL/AfVyH6ruzy+ka+TJk9qRmCmsM/8XNnv9wvtLnxiGyq9K?=
 =?us-ascii?Q?z3c3lu1ZwqgKw7ludbDN3m1i1F82leSgwX+/Yd/BglqzLSrfLrcberrmgldl?=
 =?us-ascii?Q?YPhIK/T5/LyNmFm+SqCiwY7ZrN6HNPTFm5IOFJlfk3JPpi+KUaKPnh8UswN2?=
 =?us-ascii?Q?yXyd7bIw8mJcsGBgy9OxRZrYMDzF5sexAf4Avxtvca6/8P8ZJV1lvEObYoxx?=
 =?us-ascii?Q?wwiNp7NfdlVM8SrOT0ty5sojVr2wChXJcbU7caJsFz8Z5jm+YyK2hM5Q5P/N?=
 =?us-ascii?Q?wjF3u/KWxYSogbgR7z8Lx+blpfMnljBdyzvYuAtAVqKdUUaSJxFSCgeTprKP?=
 =?us-ascii?Q?tEETrb+OlYiEd5S7kE74DXcAi8pQDP/B/CReVNv5iO4rWWDKpAOTGI0oJ1Qc?=
 =?us-ascii?Q?t6Y7rwdv54/XbUeVkzuInlnWYHRoAWvLzqiS4o5oKoRzmjwMuKvkk3JjsND4?=
 =?us-ascii?Q?f1rzmRwB6J1IQtC1FoPDM+C+j/ElFmEuBse3AnhlsAJCATWr6VGFRYX29XOV?=
 =?us-ascii?Q?sxWM4l/P6v5966rk+vl5iy2+UUrEG3mhaEWdfop?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: FrThKAT2u6vlUm1QHKHayXpVHEWO7Qznb8ZNs54NWBNW9iAjAslFaPQNVvauv4h/Ty3EwTTa3jIXid6nqtAfoNwZhJFvSVx/pW60ya/FKPTcfT1X3DH/sQLyS/Cdgosx8HbJP/EnGilSjh/2XpiywRxnhfkU2fgd99XYmQk4C8Nc4Rgbvu0OW5wdv7QPerECVQR0hWyO+Mj8rvEY0EfctQ6rsRjw/kiwkDWCXSHJ7f6Qj/7Sy8N5jUm9bQn/0Cah/P62ZAM/u8CqP7UuYsZ1L6QcoQD+qO0I73YvF3WjUddZGf0FgZbdoRJnTwmKQ/D603t/YL0K9BYkYomiUH7+VYhve84mNVAKx/Jlz3F1HCxw09neVuDddo7ZzVNhFJoo6hFt9EB55atuKKWP1fCd7FyLBRs4WKylY35SLzNhLzQ=
X-OriginatorOrg: mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2019 18:53:37.0968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2edbf58-2229-47d0-edda-08d691e49003
X-MS-Exchange-CrossTenant-Id: 64afd9ba-0ecf-4acf-bc36-935f6235ba8b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=64afd9ba-0ecf-4acf-bc36-935f6235ba8b;Ip=[18.9.28.11];Helo=[outgoing.mit.edu]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3204
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 13, 2019 at 10:30:47AM -0600, Vijay Chidambaram wrote:
> Agreed, but another way to view this feature is that it is dynamic
> switching between ordered mode and data journaling mode. We switch to
> data journaling mode exactly when it is required, so you are right
> that most applications would never see a difference. But when it is
> required, this scheme would ensure stronger semantics are provided.
> Overall, it provides data-journaling guarantees all the time, and I
> was thinking some applications would like that peace of mind.

Switching back and forth orderred and data journalling mode is a bit
tricky.  (Insert "one does not simply walk into Morder" meme here).

See the comment in ext4_change_journal_flag() in fs/ext4/inode.c:

	/*
	 * We have to be very careful here: changing a data block's
	 * journaling status dynamically is dangerous.  If we write a
	 * data block to the journal, change the status and then delete
	 * that block, we risk forgetting to revoke the old log record
	 * from the journal and so a subsequent replay can corrupt data.
	 * So, first we make sure that the journal is empty and that
	 * nobody is changing anything.
	 */

What this means is that you have to track a list of blocks that has
ever been data journalled, because before we delete the file, we have
to write revoke all blocks belonging to that file on the list.
Similarly, if you switch from ordered to data journalling mode, all of
those blocks must be revoked.

This should also be done in a way that avoids serializing parallel
writes to the the inode.  That's not something we support today (yet),
but thare are some plans to allow parallel direct I/O writes to the
file.  Speaking of Direct I/O writes, as above, if a block that was
previously written via data journalling, the revoke block must be
submitted --- and committed --- before Direct I/O writes to that block
can be allowed.

> > Since we already have delalloc to pre-stage the dirty pages before the
> > write, we can make a good decision about whether the file data should
> > be written to the journal or directly to the filesystem.

Note that delalloc and data journalling is not compatible.  That being
said, if we are writing to not-yet-allocated block, recent discussions
of changing ext4 so that we only insert the block into the extent tree
in a workqueue triggered by the I/O callback for data block write, is
probably the better way of removing the data=ordered overhead.

Finally, this optimization only makes sense for HDD's, right?  For
SSD's, random writes are mostly free, and the cost of the double
write, not to mention the write amplification effect, probably makes
this not worthwhile.

Cheers,

						- Ted
