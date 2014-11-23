From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] ext4: cache extent hole in extent status tree for
 ext4_da_map_blocks()
Date: Sun, 23 Nov 2014 00:43:35 -0500
Message-ID: <20141123054335.GA4102@thunk.org>
References: <1415961957-21621-1-git-send-email-jack@suse.cz>
 <1415961957-21621-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45749 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaKWFnp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Nov 2014 00:43:45 -0500
Content-Disposition: inline
In-Reply-To: <1415961957-21621-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 11:45:52AM +0100, Jan Kara wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Currently extent status tree doesn't cache extent hole when a write
> looks up in extent tree to make sure whether a block has been allocated
> or not.  In this case, we don't put extent hole in extent cache because
> later this extent might be removed and a new delayed extent might be
> added back.  But it will cause a defect when we do a lot of writes.  If
> we don't put extent hole in extent cache, the following writes also need
> to access extent tree to look at whether or not a block has been
> allocated.  It brings a cache miss.  This commit fixes this defect.
> Also if the inode doesn't have any extent, this extent hole will be
> cached as well.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

This patch (either when applied alone, or as part of the entire patch
series) is causing an xfstests regression test failure:

FSTYP         -- ext4
PLATFORM      -- Linux/i686 kvm-xfstests 3.18.0-rc3-00537-g932e3f9
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

ext4/003 4s ...	[00:14:39] [00:14:48] - output mismatch (see /results/results-4k/ext4/003.out.bad)
    --- tests/ext4/003.out	2014-10-31 10:13:03.000000000 -0400
    +++ /results/results-4k/ext4/003.out.bad	2014-11-23 00:14:48.935587897 -0500
    @@ -1,3 +1,3 @@
     QA output created by 003
    -wrote 268435456/268435456 bytes at offset 0
    +wrote 241762304/268435456 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    ...
    (Run 'diff -u tests/ext4/003.out /results/results-4k/ext4/003.out.bad'  to see the entire diff)

				- Ted
