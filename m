From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Wed, 17 Dec 2008 09:50:59 -0800
Message-ID: <1229536259.2921.16.camel@bobble.smo.corp.google.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
	 <20081217031210.GA17588@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:14843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYLQRvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 12:51:24 -0500
In-Reply-To: <20081217031210.GA17588@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is just a quick response to one issue; I need to look at the rest
in more detail but they seem valid from a quick skim.

On Tue, 2008-12-16 at 22:12 -0500, Theodore Tso wrote:
> Also, why not use EXT4_NOJOURNAL_MAGIC constant directly, instead of
> assigning it as a constant value to s_nojournal_flag in struct
> ext4_sb_info?  That bloats the data structure for no good reason that
> I can tell.

The way this works (which I did at Andreas' suggestion) is that when
there is no journal the "current handle" is really a pointer to
ext4_sb_info.  I need to distinguish that structure from a valid handle,
so I added the magic field to do so; the first field of a handle_t is a
pointer (to a transaction) so I need something I can distinguish from
that.  (And your comments regarding the magic value are very helpful,
thanks.)

If you look at ext4_handle_valid you'll see where it's actually used.  I
admit this is very non-obvious (so far it has confused at least two
different reviewers); if you have a more clear way to handle it I'm all
ears.

> >  static inline int ext4_should_journal_data(struct inode *inode)
> >  {
> > +	BUG_ON(EXT4_JOURNAL(inode) == NULL &&
> > +	       (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
> > +	        EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL));
> >  	if (!S_ISREG(inode->i_mode))
> >  		return 1;
> >  	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
> 
> This shouldn't be a BUG_ON; this gets triggered if there is an inode
> which is marked as needing data journalling.

Yeah, I have an open issue to remove all of these BUG_ONs after we've
had a chance to test this fairly thoroughly.  In the meantime I was
leaving them in as a sanity check.  I'll remove them from the next
version of the patch I send to you.

> In the case where there is no journal, please remove the KERN_ERR
> printk; that's just excess noise, and some day, Google System
> Administrators will thank you for getting rid of it.  :-)

Heh.  You're probably right.

> Actually, what we should probably do (as a separate patch before this
> one), is to remove ext4_create_journal() and the journal_inum mount
> option altogether.  It's pointless code that was originally added to
> ext3 by Stephen Tweedie back when he wanted to convert ext2
> filesystems to ext3 before e2fsprogs supported tune2fs -j.  It's been
> obsolete for over eight years, in both ext3 and ext4.

If by "we" you mean you, I'll just disregard those bits entirely.  If
you mean me, I'll chat with my manager but I think it's doable since
it's pretty much just ripping out a bit of code.

> In any case, these are all pretty tiny nits; on the whole I think this
> patch is quite clean, so I'll add it to the ext4 patch queue for
> testing.

Thanks!  And thanks for the comments, I will address them and generate a
new patch.  Please think about the magic-number/ext4_sb_info thing,
though, and get back to me.

>   I would appreciate getting an updated patch which addresses
> these suggested cleanups, though.  Also, although I haven't tested it,
> I suspect we need to add a check so that if there is no journal, and
> the EXT4_FEATURE_INCOMPAT_RECOVERY feature is set, the mount should be
> aborted with an error, instead of just clearning the recovery flag and
> moving on.  In actual practice, such a combination should never
> happen, but if it does, failing the mount is probably a safer thing
> to do.

Ah, good point.  If we want to recover the journal and there isn't one
that's probably bad, yes.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

