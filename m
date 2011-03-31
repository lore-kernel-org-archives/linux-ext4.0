From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Thu, 31 Mar 2011 19:14:36 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1103311910080.3522@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com> <20110331164319.GG21524@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, Eric Sandeen <esandeen@redhat.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573Ab1CaROo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2011 13:14:44 -0400
In-Reply-To: <20110331164319.GG21524@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 31 Mar 2011, Jan Kara wrote:

> On Wed 30-03-11 17:32:06, Lukas Czerner wrote:
> > Hello,
> > 
> > I have hit BUG_ON while running xfstest 234 in the loop
> > on the ext4. Backtrace below .
> > 
> > I thought that this problem was solved with
> > 67eeb5685d2a211c0252ac7884142e503c759500 however it is still present.
> > I might be a bit hard to hit, but once you run
> > 
> > while true; do sync; sleep 0.3; done
> > 
> > concurrently it is reproducible almost all the time. I have tried to
> > understand what is going on but only thing I can see is this course
> > of action:
> > 
> > ext4_write_dquot
> >   ext4_journal_start <- h_buffer_credits = 2
> >   dquot_commit
> >     v2_write_dquot
> >       qtree_write_dquot
> >         ext4_quota_write
> >           ext4_handle_dirty_metadata	<- this takes one block reserved
> > 	  				   for journal
> > 					   h_buffer_credits--
> >     v2_write_file_info
> >       ext4_quota_write
> >         ext4_handle_dirty_metadata	<- this takes second block reserved
> > 	  				   for journal
> > 					   h_buffer_credits--
> >   ext4_journal_stop
> > 
> > However apparently I am missing something, because according to the
> > backtrace the second call of jbd2_journal_dirty_metadata() may end up
> > with BUG_ON -> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> > 
> > So someone else is touching our handle apparently, but I go not exacly
> > know what is going on. From my simple debugging printk information I
> > have put with before ext4_handle_dirty_metadata() in ext4_quota_write()
> > we can see:
> > 
> > [  226.450263] ext4_quota_write: len 48, off 5136, type 0 h_ref 1
> > credits 2
> > [  226.458950] ext4_quota_write: len 24, off 8, type 0 h_ref 1 credits 0
> > 
> > It is clear someone changed handle between v2_write_dquot() and
> > v2_write_file_info() does anyone have idea what is going on ?
>   It's simpler than that I believe. ext4_write_dquot() does also
>         inode->i_mtime = inode->i_ctime = CURRENT_TIME;
>         ext4_mark_inode_dirty(handle, inode);
> and that eats another credit. Looking at the comment before
> EXT4_QUOTA_TRANS_BLOCKS, we in fact counted with inode and data update but
> didn't count with the info update. It's actually a race that we ended up
> doing info update in our transaction - someone marked info dirty and before
> he managed to write it, we went in, saw the dirty flag and wrote it for
> him. So the attached patch should fix the problem for you.
> 
> 									Honza
> 

Hrm, I have been cracking my head with this bug and miss the obvious
ext4_mark_inode_dirty(). Thanks Honzo, I'll test the patch and let you
know.

Thanks!
-Lukas
