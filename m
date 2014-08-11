From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: journal_checksum_v2 on-disk format change? (was: Re: journal
 recovery problems with metadata_csum, *non-64bit*)
Date: Mon, 11 Aug 2014 12:25:29 -0700
Message-ID: <20140811192529.GG2808@birch.djwong.org>
References: <BLU437-SMTP3407533C3883653626BD3DFDEC0@phx.gbl>
 <20140811071025.GE19223@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: TR Reardon <thomas_reardon@hotmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46423 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaHKTZj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 15:25:39 -0400
Content-Disposition: inline
In-Reply-To: <20140811071025.GE19223@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Mr. Reardon has discovered that due to a bug in journal_tag_bytes(), if the the
"journal csum v2" feature flag is turned on, block tag records are being
written with two extra bytes of space because we don't need to execute
"x += sizeof(tag.t_checksum);".  In 32-bit mode, other parts of the journal
then perform incorrect size comparisons, leading to BUG() being called.  In
64-bit mode, there's enough padding that bad things won't happen.

This is a remnant of the days when I tried to enlarge journal_block_tag_t to
hold the full 32-bit checksum for a data block that's stored in the journal.
Back in 2011, we decided (though sadly I can't find the link; I think we might
have discussed this in the concall) that it was better not to change the size
of journal_block_tag_t than it was to make it bigger so that it could hold the
full checksum.

A simple fix for the problem has been proposed by Mr. Reardon which fixes
journal_tag_bytes() and leaves everything else unchanged.  However, that is
technically a disk format change since the size of journal_block_tag_t on disk
changes, albeit only for people running experimental metadata_csum filesystems.
Since we've been allocating disk space for the enlarged checksum this whole
time, if we apply that patch, anyone with an unclean 64bit FS will not be able
to recover the journal.  (Anyone with an unclean 32-bit FS has been broken the
whole time, and still will be.)

The other thing we could do is actually use the two bytes to store the high
16-bits of the checksum, fix the jbd2 helper functions to reflect that reality
(so that they don't BUG()), and change the checksum verify routine to pass the
block if either the full checksum matches, or if the lower 16 bits match and
the upper 16 bits are zero.  With this route, anybody with an uncleanly
unmounted FS could still recover the journal, since we're not changing the size
of anything.

Fortunately, journal tag blocks are fairly ephemeral and nobody ought to be
using metadata_csum on a production filesystem, so at this point we can
probably change the disk format without too many repercussions.  If you make
sure to cleanly unmount the filesystem when changing kernel/e2fsprogs versions,
there will be no problems.

So, uh... comments?  How should we proceed?

--D

On Mon, Aug 11, 2014 at 12:10:25AM -0700, Darrick J. Wong wrote:
> On Sun, Aug 10, 2014 at 06:35:33PM -0400, TR Reardon wrote:
> > Ok, I found the problem in jbd2, and have a solution, though it's
> > debatable what the ideal solution is.  For now, the simplest patch is
> > below, though a similar patch in lib/ext2fs/kernel-jbd.h is required
> > to get e2fsck back in sync.
> > 
> > The original c3900875 commit adding metadata_csum (ie
> > journal_checksum_v2) to jbd2 added 2 extra bytes for the block
> > checksums, in addition to re-allocating 2 bytes from the 4 bytes of
> > flags.  However, a decision was made to only retain the lower 16-bits
> > of the crc32c, and thus those extra 2 bytes were unneeded.  But those
> > 2 extra bytes were never "deallocated" from journal_tag_bytes().
> 
> Hrmm... yes, I remember trying to push for full 32-bit checksums on journal
> blocks, and our subsequent decision not to put in the two bytes.  Oops.
> 
> (This looks more like a coding error on my part.)
> 
> I suppose it would help to be able to use debugfs or something to create
> journal transactions just to see if they'll replay correctly in the
> kernel/e2fsck.  I've wondered for a while if the e2fsck jbd code ought to be
> pushed into libext2fs (or libjbd2) to make this easier.  A long ago fuse2fs
> patchbomb actually did this so that fuse2fs could at least replay the journal.
> 
> > Unfortunately, different code relies on JBD_TAG_SIZE32/64 constants
> > directly rather than the journal_tag_bytes() utility function, in
> > particular the recovery code which is common to e2fsck and jbd2.  This
> > led different tools to think they were looking at a 64bit journal when
> > actually it was 32bit.  Code that relied on journal_tag_bytes()
> > remained safe, so the block iterators were fine, but any direct use of
> > those constants [including the hideous greater-than comparison in
> > read_tag_bytes()] went awry, and journal replay will fail.
> 
> Hmm... I thought recovery.c sets tag_bytes to journal_tag_bytes()?
> 
> (It's late, I'll have another look in the morning.)
> 
> > As far as I can tell, metadata_csum + journal checksum has never
> > worked for 32bit filesystems. By a little bit of padding luck, 64bit
> > worked fine.
> `
> D'oh. :(
> 
> FWIW, 64bit is recommended for metadata_csum since it enables full 32-bit
> bitmap checksums.
> 
> > Now, as to the solution: depends on whether one feels that existing
> > in-the-wild journals matter. The original commit was May 2012, are we
> > past early-adopters now?  If this patch is taken, you shrink the
> 
> Definitely not past the early adopter stage.  The e2fsprogs code will be in
> 1.43, which means that most people can't use metadata_csum yet.
> 
> So, thank you very much for helping us to smoke test. :)
> 
> > journal block tags to the intended size but in-the-wild journals will
> > be broken.  But they already are, so...?  This opens up the
> > possibility of now using those extra 2 bytes and retaining full 32-bit
> > crc32c for the block tags.  If going that route, debugs/logdump needs
> > a fix in addition to changes to jbd2.
> 
> In theory the only wild journals should be on test FSes anyway, so breaking
> them isn't the end of the world.
> 
> But as you point out, the space is already getting used because journal_csum_v2
> is the gate for the extra 2 bytes to be turned on, so I guess we could just use
> the extra 2 bytes and store the full checksum.
> 
> > FWIW, the "JBD2: Out of memory during recovery." error in
> > fs/jbd2/recovery.c was opaque at best and should be changed to always
> > include the block# that caused the problem.
> 
> recovery.c line 611, correct?
> 
> --D
> > 
> > +Reardon
> > 
> > ---
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 67b8e30..dc27d09 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -2166,15 +2166,11 @@ int jbd2_journal_blocks_per_page(struct inode *inode)
> >  size_t journal_tag_bytes(journal_t *journal)
> >  {
> >         journal_block_tag_t tag;
> > -       size_t x = 0;
> > -
> > -       if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
> > -               x += sizeof(tag.t_checksum);
> > 
> >         if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
> > -               return x + JBD2_TAG_SIZE64;
> > +               return JBD2_TAG_SIZE64;
> >         else
> > -               return x + JBD2_TAG_SIZE32;
> > +               return JBD2_TAG_SIZE32;
> >  }
> > 
> >  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
