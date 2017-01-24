From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/4] ext4: fix deadlock between inline_data and
 ext4_expand_extra_isize_ea()
Date: Tue, 24 Jan 2017 13:27:22 +0100
Message-ID: <20170124122722.GE20153@quack2.suse.cz>
References: <20170112034938.5934-1-tytso@mit.edu>
 <20170112034938.5934-4-tytso@mit.edu>
 <20170120135317.GC10446@quack2.suse.cz>
 <20170122222527.ylc26specpuvydcx@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux@sciencehorizons.net, stable@vger.kernel.org, #@thunk.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170122222527.ylc26specpuvydcx@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 22-01-17 17:25:27, Ted Tso wrote:
> > > @@ -1497,12 +1493,11 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
> > >  	int error = 0, tried_min_extra_isize = 0;
> > >  	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
> > >  	int isize_diff;	/* How much do we need to grow i_extra_isize */
> > > +	int no_expand;
> > > +
> > > +	if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
> > > +		return 0;
> > 
> > Why do you play tricks with trylock here? ext4_mark_inode_dirty() checks
> > EXT4_STATE_NO_EXPAND and thus we should not ever get here if we already
> > hold xattr_sem...
> 
> The problem is still a lock inversion in the truncate code path.  The
> simplest way of dealing with it to simply avoiding doing the
> expand_isize operation on truncates.  In the case where this is
> happening on the deletion of an inode, doing the expansion is
> pointless anyway.

I see, thanks for explanation. Well seeing all these problems with
ext4_expand_extra_isize() wouldn't we be better off by not calling it from
ext4_mark_inode_dirty() but rather explicitely from several well-defined
places? Because this implicit calling looks like it causes us too much
trouble.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
