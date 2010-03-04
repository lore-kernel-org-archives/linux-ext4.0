From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 1/3] ext4: Fix insertion point of extent in
	mext_insert_across_blocks()
Date: Thu, 4 Mar 2010 00:50:33 -0500
Message-ID: <87f94c371003032150q64046db9h815d4cb630bb7a12@mail.gmail.com>
References: <4B8E0679.8060706@rs.jp.nec.com> <20100304012508.GD3530@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55923 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0CDFuf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Mar 2010 00:50:35 -0500
Received: by gwb15 with SMTP id 15so1068822gwb.19
        for <linux-ext4@vger.kernel.org>; Wed, 03 Mar 2010 21:50:34 -0800 (PST)
In-Reply-To: <20100304012508.GD3530@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> P.S. =A0Here's another random idea for how we might aggressively test
> the EXT4_IOC_MOVE_EXT ioctl: (1) create an empty filesystem, (2)
> create a tool which randomly sets 50% of the bits in the block
> allocation bitmap, marking them as in use, and making the free space
> look very badly fragmented. =A0(3) write a large number of files into
> the filesystem. =A0(4) calculate the checksums for all of the files.
> (5) run e2fsck on the filesystem to fix up the block allocation
> bitmap. =A0(6) defrag all of the files on the filesystem. =A0(7) use
> e2fsck to make sure the filesystem is still consistent. =A0(8) calcul=
ate
> the checksums for all of the files to make sure they still contain
> their original data.

Even that does not address issues with files in use during defrag.

ie. Defrag'ing a mysql database file while in use seems like an
important test case that is missing above.

Also, one issue with repetitive testing via the e4defrag tool, is you
only end up moving everything once and then in theory extra passes
have little to do.

The ohsm project has written a userspace "relocate" tool that calls
ext4_ioc_move_ext() to move files around on the filesystem.

In the absense of any ext4 ohsm kernel patches the blocks allocated to
the donor file would just use the normal block allocators.  Therefore
it should be relatively easy to introduce an effect of just randomly
using ext4_ioc_move_ext() to change out the underlying blocks.  It
maybe a useful in building up a test suite for ext4_ioc_move_ext().

In addition, for static files such as you describe above, we plan to
use the 60 GB or so of real world public domain data at
http://edrm.net/activities/projects/dataset as potential well known /
well defined real world data.  That data already has published MD5
values available, so data corruption at any point in the process
should be readily identifiable.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
