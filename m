From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 3 Jun 2010 13:10:58 -0400
Message-ID: <20100603171058.GC13179@thunk.org>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <20100603125312.GH24062@thunk.org>
 <20100603141948.GB3814@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60543 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611Ab0FCRLA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jun 2010 13:11:00 -0400
Content-Disposition: inline
In-Reply-To: <20100603141948.GB3814@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 03, 2010 at 04:19:48PM +0200, Jan Kara wrote:
> > All of these problems go away if the quota file isn't visible from
> > userspace, and it becomes a special file.  In the short term I think
> > we could make this change, but I think we would also have to (1) treat
> > the quota file as immutable while quotas are enabled (so it cannot be
> > opened for writing), (2) force an fsync of the quota file and a
> > journal commit before enabling quotas, and (3) force a journal commit
> > after disabling quotas.
>   Ted, that's what generic quota code actually does for you (unless
> DQUOT_QUOTA_SYS_FILE flag is specified but that's not the case of ext?)
> - see vfs_load_quota_inode. We do:
> sync_filesystem(sb);
> invalidate_bdev(sb->s_bdev);
> ..
> inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
> ..
>   So unless someone tries to screw us really hard, we should be fine.

That's good to hear.  I think though we also need to call
sync_filesystem(sb) in dquot_disable().  Currently it calls
sb->s_op->sync_fs(), which forces out the superblock, and
sync_blockdev() which forces out any dirty buffer heads, but it
doesn't actually force a journal commit so that any pending journaled
writes to the quota file are forced out.  We need to either explicitly
sync the quota files, or use sync_filesystem(sb) and sync everything.
The former might be more polite; in fact it might be sufficient in
vfs_load_quota_inode() as well?  Or am I missing something?

		       	  	       - Ted
