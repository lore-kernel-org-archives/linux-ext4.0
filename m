From: Jan Kara <jack@suse.cz>
Subject: Re: REGRESSION: [PATCH 04/12] ext4: Disable merging of
 uninitialized extents
Date: Thu, 14 Feb 2013 17:11:16 +0100
Message-ID: <20130214161116.GB31269@quack.suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
 <1358510446-19174-5-git-send-email-jack@suse.cz>
 <20130209171015.GC8091@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934736Ab3BNQLU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2013 11:11:20 -0500
Content-Disposition: inline
In-Reply-To: <20130209171015.GC8091@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 09-02-13 12:10:15, Ted Tso wrote:
> On Fri, Jan 18, 2013 at 01:00:38PM +0100, Jan Kara wrote:
> > Merging of uninitialized extents creates all sorts of interesting race
> > possibilities when writeback / DIO races with fallocate. Thus
> > ext4_convert_unwritten_extents_endio() has to deal with a case where
> > extent to be converted needs to be split out first. That isn't nice
> > for two reasons:
> > 
> > 1) It may need allocation of extent tree block so ENOSPC is possible.
> > 2) It complicates end_io handling code
> > 
> > So we disable merging of uninitialized extents which allows us to simplify
> > the code. Extents will get merged after they are converted to initialized
> > ones.
> > 
> > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Sorry for not noticing this earlier, but this patch is causing a
> regression.  It is loading to test 113 failing when dioread_nolock is
> used:
> 
> 113	[   47.619363] EXT4-fs error (device vdb): ext4_convert_unwritten_extents_endio:3411: i
> node #10951: comm kworker/u:0: Written extent modified before IO finished: extent logical block
>  1024, len 1024; IO logical block 1024, len 127
> [   47.619363] 
> [   47.623239] EXT4-fs warning (device vdb): ext4_convert_unwritten_extents:4522: inode #10951:
>  block 1024: len 127: ext4_ext_map_blocks returned -5
> [   47.628975] EXT4-fs (vdb): failed to convert unwritten extents to written extents -- potenti
> al data loss!  (inode 10951, offset 4194304, size 520192, error -5)
> 
> 
> As a result, I am considering whether or not I should to drop the
> following patches from the ext4 tree:
> 
> e63dd9c ext4: disable merging of uninitialized extents
> de39534 ext4: remove unnecessary wait for extent conversion in ext4_fallocate()
> 37bf0a8 ext4: ext4_split_extent should take care of extent zeroout
> 
> I know that these patches fix other potential races which causes data
> loss, but they've been around for a while, and in practice seem to be
> relatively rarely hit.
  OK, so I've debugged this. It wasn't actually that hard. The problem is
that mpage_da_map_and_submit() prepares extent with e.g. 256 blocks but
later we submit a shorter bio e.g. because it cannot carry that many pages.
So ->end_io is called only for first 128 blocks or so. I spotted this
problem already before, just it didn't come up when Ted sent me this bug
report.

The fix isn't trivial. What we need to do is to be able to attach multiple
bios to one io_end structure and start the conversion only once they are
all finished. I actually have patches for this in the second part of my
patch set. So for this merge window I'd just do what Dmitry suggested (and
the warning can be triggered really trivially by a sequential write with
dioread_nolock so that definitely has to be hidden by default). And I'll go
off to finish that second part of my patch set so that it can get to Ted's
tree as soon as possible.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
