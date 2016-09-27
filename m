From: Jan Kara <jack@suse.cz>
Subject: Re: SECRM, UNRM, COMPR flags
Date: Tue, 27 Sep 2016 10:35:08 +0200
Message-ID: <20160927083508.GE1139@quack2.suse.cz>
References: <20160926091149.GA7733@quack2.suse.cz>
 <20160926150621.rp2s5uhkbqzjzixn@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbcI0IfJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Sep 2016 04:35:09 -0400
Content-Disposition: inline
In-Reply-To: <20160926150621.rp2s5uhkbqzjzixn@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 26-09-16 11:06:21, Ted Tso wrote:
> On Mon, Sep 26, 2016 at 11:11:49AM +0200, Jan Kara wrote:
> > 
> > in ext4 we have these SECRM, UNRM, COMPR flags which users can set, they
> > can read them, but which actually don't do anything. This is actually
> > somewhat confusing - e.g. I've just got report about one tool which
> > apparently sets SECRM flag on a file in a hope that it is somehow safer.
> > Also this is a waste of flags.
> 
> I agree it doesn't seem very likely we'll be using UNRM any time soon.
> I can imagine using SECRM and COMPR, but in particular for COMPR it
> will probably be in a different way (the package manager would install
> a file that would be compressed in userspace, and then using a
> *different* ioctl from IOC_SETFLAGS, the COMPR flag would be set and
> that would make the file immutable and the decompression would be done
> in userspace).
> 
> > I've checked other filesystems (xfs, btrfs) and they report EOPNOTSUPP if
> > these flags are not really supported. Should not we do the same in ext4? I
> > know there is a concern about breaking userspace but since other major
> > filesystems already behave this way I think there is a good chance tools
> > handle this reasonably... What do people thing?
> 
> What we've been doing for other flags that we don't set is that we
> simply mask them off (see EXT4_FL_USER_MODIFIABLE) so attempt so set
> them will be a no-op.

Yeah. This is better than what we currently have but still the problem is
that application can be tricked into thinking it got some functionality
when it actually did not (when ioctl succeeds, apps usually don't recheck
whether the bit actually got set - especially when other filesystems return
error in such case).

What I'd like is: Remove UNRM, SECRM and COMPR from USER_MODIFIABLE
bitmask. Return -EOPNOTSUPP when (flags & ~USER_MODIFIABLE) != 0.
This way we flag possible issues early and also using the so far unused
flags for any functionality in future is safe (otherwise you cannot be sure
whether some apps just randomly don't leave unused bits set). Whether some
apps won't get broken by this is a question but I'd hope not since as I
said other filesystems already behave this way and get away with that...
Are people willing to try this out?

> What I think would make sense is to simply remove UNRM, SECRM, and
> UNRM from the USER_MODIFIABLE bitmask.  I also suspect it might be
> useful to define a new ioctl which returns the USER_VISIBLE and
> USER_MODIFIABLE bitmasks, so that tools can know how to expect (and
> give warning or error messages as desired).

Well the GET/SETFLAGS ioctl is used by several filesystems these days so
we'd better check with other filesystems whether they are able to support
this functionality. I think they should be and it could be useful for app
to know which info it is able to get/set so that it doesn't have to
research through trial and error. But this is IMO a separate issue to the
above ext4-specific problem.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
