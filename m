From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] quota: Handle Q_GETNEXTQUOTA when quota is disabled
Date: Mon, 4 Apr 2016 11:40:14 +0200
Message-ID: <20160404094014.GD8372@quack.suse.cz>
References: <1459267904-10755-1-git-send-email-jack@suse.cz>
 <20160401143956.GD29897@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160401143956.GD29897@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 01-04-16 10:39:56, Ted Tso wrote:
> On Tue, Mar 29, 2016 at 06:11:43PM +0200, Jan Kara wrote:
> > Currently we oopsed when Q_GETNEXTQUOTA got called when quota was
> > disabled. Properly check whether quota is enabled for the filesystem
> > before calling into quota format handler.
> > 
> > diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> > index ba827daea5a0..ff21980d0119 100644
> > --- a/fs/quota/dquot.c
> > +++ b/fs/quota/dquot.c
> > @@ -2047,11 +2047,20 @@ int dquot_get_next_id(struct super_block *sb, struct kqid *qid)
> >  	struct quota_info *dqopt = sb_dqopt(sb);
> >  	int err;
> >  
> > -	if (!dqopt->ops[qid->type]->get_next_id)
> > -		return -ENOSYS;
> > +	mutex_lock(&dqopt->dqonoff_mutex);
> > +	if (!sb_has_quota_active(sb, qid->type)) {
> > +		err = -ESRCH;
> > +		goto out;
> > +	}
> > +	if (!dqopt->ops[qid->type]->get_next_id) {
> > +		err = -ENOSYS;
> > +		goto out;
> > +	}
> 
> Don't you also have to test if dqopt->ops[qid->type] is NULL?  e.g.,
> if the quota inode hasn't been loaded for that quota type?

Well, we first setup ->ops[type], then load quota inode, and only after
that enable flags which sb_has_quota_active() is checking so I don't see a
need for additional checking of dqopt->ops[qid->type].

> Also, I notice you have this queued on the for_next branch and not the
> for_linus branch.  I was hoping you could push this to Linus sooner
> than the next merge cycle, since this is (a) making my testing hard,
> and (b) it makes it easy for an attacker to crash the system.  For
> similar reasons, perhaps this should have a cc: stable@vger.kernel.org
> tag?

The problematic code was merged in this merge window so no point to cc
stable. I want to push the fix to Linus for rc3 (likely today or tomorrow)
so you should be able to get that soon. Sorry for complications.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
