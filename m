From: Theodore Ts'o <tytso@mit.edu>
Subject: REGRESSION: [PATCH 04/12] ext4: Disable merging of uninitialized
 extents
Date: Sat, 9 Feb 2013 12:10:15 -0500
Message-ID: <20130209171015.GC8091@thunk.org>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47521 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760757Ab3BIRKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Feb 2013 12:10:36 -0500
Content-Disposition: inline
In-Reply-To: <1358510446-19174-5-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 01:00:38PM +0100, Jan Kara wrote:
> Merging of uninitialized extents creates all sorts of interesting race
> possibilities when writeback / DIO races with fallocate. Thus
> ext4_convert_unwritten_extents_endio() has to deal with a case where
> extent to be converted needs to be split out first. That isn't nice
> for two reasons:
> 
> 1) It may need allocation of extent tree block so ENOSPC is possible.
> 2) It complicates end_io handling code
> 
> So we disable merging of uninitialized extents which allows us to simplify
> the code. Extents will get merged after they are converted to initialized
> ones.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Sorry for not noticing this earlier, but this patch is causing a
regression.  It is loading to test 113 failing when dioread_nolock is
used:

113	[   47.619363] EXT4-fs error (device vdb): ext4_convert_unwritten_extents_endio:3411: i
node #10951: comm kworker/u:0: Written extent modified before IO finished: extent logical block
 1024, len 1024; IO logical block 1024, len 127
[   47.619363] 
[   47.623239] EXT4-fs warning (device vdb): ext4_convert_unwritten_extents:4522: inode #10951:
 block 1024: len 127: ext4_ext_map_blocks returned -5
[   47.628975] EXT4-fs (vdb): failed to convert unwritten extents to written extents -- potenti
al data loss!  (inode 10951, offset 4194304, size 520192, error -5)


As a result, I am considering whether or not I should to drop the
following patches from the ext4 tree:

e63dd9c ext4: disable merging of uninitialized extents
de39534 ext4: remove unnecessary wait for extent conversion in ext4_fallocate()
37bf0a8 ext4: ext4_split_extent should take care of extent zeroout

I know that these patches fix other potential races which causes data
loss, but they've been around for a while, and in practice seem to be
relatively rarely hit.

Jan, Dmitry, any chance you can take a look at this, and give me
suggestions about how to proceed at this point?

Thanks,

						- Ted
