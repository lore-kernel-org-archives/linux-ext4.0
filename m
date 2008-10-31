From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [RFC PATCH 1/1] Allow ext4 to run without a journal.
Date: Fri, 31 Oct 2008 14:55:32 -0700
Message-ID: <1225490132.8190.10.camel@bobble.smo.corp.google.com>
References: <1225397281.19114.13.camel@bobble.smo.corp.google.com>
	 <20081030234037.GU3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>,
	Peter Kukol <pkukol@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:55316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYJaVzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 17:55:38 -0400
In-Reply-To: <20081030234037.GU3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-10-30 at 17:40 -0600, Andreas Dilger wrote: 
> On Oct 30, 2008  13:08 -0700, Frank Mayhar wrote:
> > We have a need to run ext4 on existing ext2 file systems.  To get there
> > we need to be able to run ext4 without a journal.  I've managed to come
> > up with an early patch that gets us at least partway there.
> > 
> > This patch just allows ext4 to mount and run with an ext2 root; I
> > haven't tried it with anything else yet.  It also scribbles in the
> > superblock, so it takes an fsck to get it back to ext2 compatibility.
> 
> What is the reason for this?  In the final form all that should happen
> is the normal ext2 "mark filesystem dirty" operation.

I haven't yet had a chance to track this down, but it's setting the ext3
"needs_recovery" flag.  Almost certainly an oversight somewhere.

> > @@ -2842,7 +2842,7 @@ void ext4_ext_truncate(struct inode *ino
> > -	if (IS_SYNC(inode))
> > +	if (handle && IS_SYNC(inode))
> >  		handle->h_sync = 1;
> 
> It would be nice to have a helper function that does this transparently:
> 
> static inline void ext4_handle_sync(handle)
> {
> 	if (handle)
> 		handle->h_sync = 1;
> }
>  
> This could be submitted before the rest of the patch without "if (handle)"
> and then you only need to change the code in one place.

Okay, I'll submit that bit separately.  I'll try to send it out today.

> > -		BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
> > -		err = ext4_journal_dirty_metadata(handle, bh2);
> > +		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
> > +		err = ext4_handle_dirty_metadata(handle, NULL, bh2);
> 
> With this change are you removing the older ext4_journal_*() functions
> completely (ensuring that all callers have to be fixed to use ext4_handle*()
> instead), or are they still available?  Unfortunately, this part of the
> patch is missing.
> 
> If the ext4_journal_*() functions are still available this exposes us to
> endless bugs from code that doesn't get fixed to work in unjournalled mode,
> but 99% of users won't notice it.

Not sure how this bit of the patch got dropped, but in any event, the
ext4_journal_dirty_metadata() function is now gone, replaced by
ext4_handle_dirty_metadata().  The underlying function
__ext4_journal_dirty_metadata() still exists, however.  The rest of the
ext4_journal_xxx() functions still exist but have been modified to check
their 'handle' parameter (or, in a few cases, the superblock
COMPAT_HAS_JOURNAL flag).

> > @@ -645,7 +645,8 @@ repeat_in_this_group:
> > -			err = ext4_journal_get_write_access(handle, bitmap_bh);
> > +			err = ext4_journal_get_write_access(handle,
> > +								    bitmap_bh);
> 
> I'm not sure why that was changed.

This has gone through a couple of iterations, this may be an artifact of
that.  I'll clean it up.

> > @@ -653,15 +654,17 @@ repeat_in_this_group:
> >  			/* we lost it */
> > -			jbd2_journal_release_buffer(handle, bitmap_bh);
> > +			if (handle)
> > +				jbd2_journal_release_buffer(handle, bitmap_bh);
> 
> This should probably also be wrapped in ext4_handle_release_buffer() so we
> don't need to expose all of the callsites to this check.

Good point.

> > @@ -881,7 +888,8 @@ int ext4_get_blocks_handle(handle_t *han
> >  	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
> > -	J_ASSERT(handle != NULL || create == 0);
> > +	/*J_ASSERT(handle != NULL || create == 0);*/
> 
> I would predicate this assertion on sbi->s_journal instead of just
> removing it:
> 
> 	J_ASSERT(create == 0 ||
> 		 (handle != NULL) == (EXT4_SB(inode->i_sb)->s_journal != NULL));

Thanks.  I had intended to come back to that anyway.

> In any case, I'm not sure if this code is completely correct, since the
> previous code allowed calling ext4_dirty_inode() without first starting
> a journal handle, and now it would just silently do nothing and cause
> filesystem corruption for the journalled case.

I was hoping to avoid in-band magic numbers (as well as any change that
would touch jbd2).  I'll see if I can continue that; regardless it
sounds like the null-handle thing is the wrong way to go, at least in a
few cases.

> > @@ -4673,7 +4705,7 @@ int ext4_change_inode_journal_flag(struc
> >  
> >  	err = ext4_mark_inode_dirty(handle, inode);
> >  	handle->h_sync = 1;
> 
> Isn't this missing a handle != NULL check?  This is called from ext4_ioctl()
> with EXT4_IOC_SETFLAGS, and it should still be possible to set the "+j"
> inode flag even if the filesystem is unjournaled.

Yeah, I missed that one.  Thanks.

> > @@ -2756,6 +2807,8 @@ static int ext4_create_journal(struct su
> >  
> > +	BUG_ON(!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL));
> 
> This is also broken, because the whole point of ext4_create_journal()
> is to create a new journal file on an existing ext2 filesystem, and
> the COMPAT_HAS_JOURNAL flag is not set until this happens successfully.

Ah.  Thanks for this explanation.

> To be honest, we could just get rid of ext4_create_journal().  This was
> a very old way of upgrading an ext2 filesystem to ext4 before tune2fs
> could do this.  That this code sets COMPAT flags from within the ext4
> code is frowned upon these days also (this should be done by the admin
> with tune2fs).

I'll look into this.

Again, thanks for your review, this helps a lot.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

