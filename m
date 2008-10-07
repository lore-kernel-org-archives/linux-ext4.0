From: Theodore Tso <tytso@mit.edu>
Subject: Re: No-journal option for ext4
Date: Tue, 7 Oct 2008 01:45:30 -0400
Message-ID: <20081007054530.GI9337@mit.edu>
References: <929ffc5e0810061839l6d5977b4o96ea1699c8451446@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Rubin <mrubin@google.com>,
	Frank Mayhar <fmayhar@google.com>
To: Peter Kukol <pkukol@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47793 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbYJGFpd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 01:45:33 -0400
Content-Disposition: inline
In-Reply-To: <929ffc5e0810061839l6d5977b4o96ea1699c8451446@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 06:39:50PM -0700, Peter Kukol wrote:
> Due to some interest in having an ext4 option not to use a journal at
> all (for various reasons that I'd rather not get into right now), 

That's OK, I think most of us know why already.  :-)

> To start with, I added an "incompat" option to ext4 allow the journal
> not to be present - when the right option string is given at mount
> time, the journaling functionality is disabled. The exact naming and
> mechanism by which this happens  actually doesn't seem terribly
> important to the real "guts" of the making the feature work, but if
> anyone feels strongly that it should be done in a certain way please
> do let me know.

Um, no.  You shouldn't need an mount option string, and there is
already a compat flag which indicates that a journal is present.
Namely, EXT4_FEATURE_COMPAT_HAS_JOURNAL; this is the feature flag
which indicates that journal is present.  Currently, both the ext3 and
ext4 filesystems require that this flag be set; if the flag is not
set, indicating that a journal is not present, ext4 will fail the
mount.

So what your patches should do is to enhance the ext4 filesystem so
that it can mount filesystems that don't have the COMPAT has_journal
feature.  This has the nice side-effect of allowing the ext4
filesystem code to be able to mount not only ext3 filesystems, but
also ext2 filesystems.

> My first attempt at actually implementing the no-journal option was to
> disable all of the journaling logic "early" - i.e. not create handles
> and journal instances, and so on. This ran into a bit of trouble in
> the handful of journaling functions that only accept handles and have
> no obvious way of determining whether journaling is disabled or not
> (other than the handle being NULL, which seems like a poor
> determinant). In addition to this, I ran into a few places where tests
> for a handle being non-NULL guard code that is needed even when
> journaling is disabled....

Yeah, the problem is that in some cases a NULL handle can mean that
there is an error.  Here's one idea:

#define NO_HANDLE ((handle_t *) ~0)
#define VALID_HANDLE(x) ((x != 0) && (x != NO_HANDLE))

So you can distinguish between NULL handle (which could be from an
error) and NO_HANDLE (which means there's no journal).

Yeah, it's a little gross, but this sort of game has been played
before --- see how SIG_IGN is defined for sigaction().

> So, in the end, I
> went back to disabling journal-only functionality "early", i.e.
> typically at the points where the ext4_ or jbd2_ functions are called
> in ext4 code, and storing the "no-journal" bit in the superblock (not
> the journal superblock but the "main" sb of the file system).

As mentioned above, we already have a "has journal" bit in the
superblock, but in many places, it will be much more efficient to test
for a null s_journal field in the ext4_sb_info structure.  There is no
error handling we need to worry about, since today, s_journal is
assumed to ALWAYS be non-NULL, as it is how we access the core jbd2
structure.  So simply checking for !EXT4_SB(sb)->s_journal should be
much more easier to read, type, and more efficient to execute.

So for example, ext4_force_commit() might look like this:

int ext4_force_commit(struct super_block *sb)
{
	journal_t *journal = EXT4_SB(sb)->s_journal;;
	int ret;

	if ((sb->s_flags & MS_RDONLY) || !journal)
	   return 0;

	sb->s_dirt = 0;
	return ext4_journal_force_commit(journal);
}

and once you set up ext4_journal_start_sb() to start like this:


handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
{
	journal_t *journal = EXT4_SB(sb)->s_journal;

	if (sb->s_flags & MS_RDONLY)
	   return ERR_PTR(-EROFS);

	if (!journal)
	   return NO_HANDLE;

	   ...
}

and you can just arrange to have __ext4_journal_get_write_access()
look like this:

#define ext4_journal_get_undo_access(handle, bh) \
	if ((handle) != NO_HANDLE) __ext4_journal_get_undo_access(__func__, (handle), (bh))

This should keep the patch relatively small, easier to audit, and the
code will be much cleaner and easier to understand in the long-run.

Given all of these benefits, I think the tiny grossness of casting ~0
or 1 to a pointer is well worth it, don't you think?  :-)

> The bottom line is, I'm wondering if folks are interested in having an
> option to disable journaling in ext4 to begin with, 

Yep, we're interested; especially since this allows the ext4
filesystem to be a full functional superset of the ext2 and ext3
filesystem code, which is quite pleasing from an aesthetic point of
view.

I hope the suggestions given above are helpful, and should hopefully
provide for much cleaner approach.

Regards,

						- Ted
