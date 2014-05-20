From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Mon, 19 May 2014 23:23:50 -0400
Message-ID: <20140520032350.GB10122@thunk.org>
References: <1400185026-3972-1-git-send-email-jack@suse.cz>
 <1400185026-3972-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50490 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaETDX4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 23:23:56 -0400
Content-Disposition: inline
In-Reply-To: <1400185026-3972-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 15, 2014 at 10:17:06PM +0200, Jan Kara wrote:
> Shuffle code around in ext4_orphan_add() and ext4_orphan_del() so that
> we avoid taking global s_orphan_lock in some cases and hold it for
> shorter time in other cases.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Hi Jan,

With this patch applies, xfstests is hanging after ext4/001 runs:

BEGIN TEST: Ext4 4k block Tue May 20 03:18:49 UTC 2014
Device: /dev/vdb
mk2fs options: -q
mount options: -o block_validity
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.15.0-rc2-00052-g0f430fc
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc

ext4/001 4s ...	 [03:19:05] [03:19:09] 4s

It just stops here, and never runs the next test.

If I revert this commit, the test run continus with ext4/002, and then
onto the rest of the tests.

Could you take a look?

Thanks!!

						- Ted
