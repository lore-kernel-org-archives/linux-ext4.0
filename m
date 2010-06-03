From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Always journal quota file modifications
Date: Thu, 3 Jun 2010 16:19:48 +0200
Message-ID: <20100603141948.GB3814@quack.suse.cz>
References: <1275488593-7237-1-git-send-email-jack@suse.cz>
 <20100603125312.GH24062@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45519 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab0FCOUI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jun 2010 10:20:08 -0400
Content-Disposition: inline
In-Reply-To: <20100603125312.GH24062@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 03-06-10 08:53:12, tytso@mit.edu wrote:
> On Wed, Jun 02, 2010 at 04:23:13PM +0200, Jan Kara wrote:
> > When journaled quota options are not specified, we do writes
> > to quota files just in data=ordered mode. This actually causes
> > warnings from JBD2 about dirty journaled buffer because ext4_getblk
> > unconditionally treats a block allocated by it as metadata. Since
> > quota actually is filesystem metadata, the easiest way to get rid
> > of the warning is to always treat quota writes as metadata...
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'm worried about this patch in the short-term.  In the long-term I
> think the quota file should become a special file much like the
> journal, and then this makes a huge amount of sense.  But I worry
> about what might happen if (a) someone tries writing to the quota file
> directly from userspace, maybe right before quota is enabled (and
> before delayed allocation writes complete, such that some writes are
> happening via the journal in ext4_quota_write and some w/o going
> through the journal in ext4_writepage), and (b) what happens if quota
> is disabled, the quota file is deleted, and some blocks get reused ---
> and then system crashes before a journal commit can happen.
> 
> All of these problems go away if the quota file isn't visible from
> userspace, and it becomes a special file.  In the short term I think
> we could make this change, but I think we would also have to (1) treat
> the quota file as immutable while quotas are enabled (so it cannot be
> opened for writing), (2) force an fsync of the quota file and a
> journal commit before enabling quotas, and (3) force a journal commit
> after disabling quotas.
  Ted, that's what generic quota code actually does for you (unless
DQUOT_QUOTA_SYS_FILE flag is specified but that's not the case of ext?)
- see vfs_load_quota_inode. We do:
sync_filesystem(sb);
invalidate_bdev(sb->s_bdev);
..
inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
..
  So unless someone tries to screw us really hard, we should be fine.

> The other thing we might try that might mostly fix things is to change
> ext4_should_journal_data() in ext4_jbd2.h to return true if it's a
> quota file --- but we don't know which files are the quota files when
> quotas are disabled, so we would still need to do (2) and (3).  But
> this would allow us to write to the quota file while quotas are
> enabled, if we think this is necessary --- although I think it's a bad
> idea, so I'd be in favor of simply not allowing quota files to be
> writable from userspace while quotas are enabled.  Jan, is this going
> to cause any problems with quotautils?
  quotautils do not write to quota files when quota is turned on (only when
it is turned off). They can only read from the files while quota is on
(repquota, warnquota).

> OTOH, I think we have similar races with journaled quotas, and no one
> has complained (although the vast majority of the quota documentation
> on various HOWTO pages still don't talk about journaled quotas, so I
> don't know how many people are using journaled quotas.  :-/ )
  Well, at least in SUSE if you enable in Yast2 that you want quotas on the
filesystem, it will use journaled quotas for a few releases already... So
I think it is used at least by some users.

> >   Ted, this patch fixes some JBD2 warning for me when running XFSQA
> > with quotas enabled. I think this is a move into a direction you are
> > trying to achieve as well. Will you merge the patch or should I do it?
> 
> I'm happy to carry the patch, since I Have Plans to try to make quotas
> be a first class supported filesystem feature (i.e., make the quota
> file a special file, and make quota files be always journaled if they
> are journaled, and make the !@#! magic quota options handling in
> /proc/mounts go away) in the 2.6.36 timeframe.
> 
> So the question is should we try to merge something like this for
> 2.6.35 or 2.6.35.y, and if so, how much bullet-proofing do we feel is
> necessary for some of these races that I've outlined above.
  Yes, I think we can push the patch to 2.6.35 and maybe to 2.6.34.y.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
