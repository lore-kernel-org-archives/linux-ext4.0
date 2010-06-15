From: Jan Kara <jack@suse.cz>
Subject: Re: delalloc makes data=writeback safer
Date: Tue, 15 Jun 2010 16:08:02 +0200
Message-ID: <20100615140801.GC18513@atrey.karlin.mff.cuni.cz>
References: <877hm8jt4g.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753136Ab0FOOIC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jun 2010 10:08:02 -0400
Content-Disposition: inline
In-Reply-To: <877hm8jt4g.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Everybody know that writeback mode for ext3 is potentially result in
> stale data in case of unclean umount. The same is true for ext4 with
> nodelalloc.
> But as far as i can see things is getting better in case of delalloc.
> In case of delalloc we have following calltrace:
> [writeback thread]
> ext4_da_writepages
>   journal_start()
>   ext4_map_blocks() -> real block allocation
>   mpage_da_submit_io() -> submit_bh() -> submit_bio()
>   journal_stop()
> So journal will be closed only after data was issued. 
> And if journal->j_dev == journal->j_fs_dev (which is usually the case)
> data will be serialized with metadata. So it looks like it is impassible
> to see stale data even after unclean umount.
> 
> Do I miss something? May be this was already discussed before, 
> if so please post a link to previous discussion.
  Well, we turn off delayed allocation when a filesystem gets close to
ENOSPC so it's not completely reliable. But besides this, your observation
looks correct to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
