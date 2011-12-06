From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 07/22] ext4: Create bitmap checksum helper functions
Date: Tue, 6 Dec 2011 10:19:12 -0700
Message-ID: <3DBC0B29-0498-47B7-9E79-98FF4BFDC56E@dilger.ca>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232703.19194.55084.stgit@elm3c44.beaverton.ibm.com> <20111205163329.GC32031@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:36893 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab1LFRTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 12:19:10 -0500
In-Reply-To: <20111205163329.GC32031@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-05, at 9:33, Ted Ts'o <tytso@mit.edu> wrote:
> Note: it's strictly speaking not necessary to mix in the group and
> s_csum_seed here.  It's useful for the inode table blocks (ITB's)
> because the checksum for a particular ITB is located *in* the ITB
> itself.  So if an ITB gets written to the wrong place, and in
> particular, on top of another ITB, we want to be able to know which
> cloned copy was written to the wrong place on disk.
> 
> But in the case of the inode and block allocation bitmaps, the
> checksums are stored in the block group descriptors; so if the bitmap
> is written to the wrong place (and on top of another bitmap), the
> checksum will fail to verify, independent of whether we've mixed in
> the fs-specific csum seed and the group number.
> 
> So I'd suggest dropping this, which will shave a few cycles off of the
> checksum calculation, and it will also simplify the code since we
> won't need this particular function.

I wouldn't mind keeping the group just to be consistent with all of the other checksums that are used in the filesystem, which are largely inside the structure being checked.

The s_uuid is definitely useful to keep as the seed because the block and inode bitmaps are not initialized at mke2fs time with uninit_bg, and it is possible to read a stale bitmap from disk that might belong to an earlier instance of the filesystem in case of a failed or misplaced write of the correct bitmap. 

That isn't important for e2fsck, since it doesn't really use the bitmaps, but it is important for the kernel not to use bad bitmaps and corrupt the filesystem further. 

Cheers, Andreas