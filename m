From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: SECRM, UNRM, COMPR flags
Date: Wed, 28 Sep 2016 19:30:12 -0400
Message-ID: <20160928233012.kstjjomqjd7w7jb4@thunk.org>
References: <20160926091149.GA7733@quack2.suse.cz>
 <20160926150621.rp2s5uhkbqzjzixn@thunk.org>
 <20160927083508.GE1139@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42804 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754637AbcI2BRw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Sep 2016 21:17:52 -0400
Content-Disposition: inline
In-Reply-To: <20160927083508.GE1139@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 27, 2016 at 10:35:08AM +0200, Jan Kara wrote:
> 
> What I'd like is: Remove UNRM, SECRM and COMPR from USER_MODIFIABLE
> bitmask. Return -EOPNOTSUPP when (flags & ~USER_MODIFIABLE) != 0.
> This way we flag possible issues early and also using the so far unused
> flags for any functionality in future is safe (otherwise you cannot be sure
> whether some apps just randomly don't leave unused bits set). Whether some
> apps won't get broken by this is a question but I'd hope not since as I
> said other filesystems already behave this way and get away with that...
> Are people willing to try this out?

I'm uncomfortable returning an error but also making changes to the
flags.  If we return an error, we shouldn't be modifying the flags.

I'm happy adding a new ioctl which returns an error without making any
changes --- but that's something all file systems would have to
support.

I'm also happy having an ioctl which returns the current
USER_MODIFIABLE bitmap (which is per-file system, by the way).

> 
> > What I think would make sense is to simply remove UNRM, SECRM, and
> > UNRM from the USER_MODIFIABLE bitmask.  I also suspect it might be
> > useful to define a new ioctl which returns the USER_VISIBLE and
> > USER_MODIFIABLE bitmasks, so that tools can know how to expect (and
> > give warning or error messages as desired).
> 
> Well the GET/SETFLAGS ioctl is used by several filesystems these days so
> we'd better check with other filesystems whether they are able to support
> this functionality.

As mentioned about, the USER_MODIFIABLE bitmask is a per-file system
thing, so we can change it for ext4 without needing to consult with
the other file systems.  (It's EXT4_USER_MODIFIABLE_FL, IIRC).

But I don't think we can return an error but also make changes to the
flag fields, or make any changes to the actual behavior of the current
ioctl without consulting the other file systems.

That's why I think the better approach is to define a new ioctl that
returns the user modifialbe and user visible bitmasks, and teach
userspace to give warning messages (or error out entirely) if the user
tries to set a flag which the file system is going to ignore.

If the ioctl isn't defined for the other file systems, we'll fall back
to the current behavior --- or if you like we can follow up the
SETFLAGS with a GETFLAGS and then report a warning if the flags aren't
checked.

This to me is much more of an user interface issue for chattr than
anything else, so I thin kit's better to fix this in chattr.

	       	    	       	      	 - Ted
