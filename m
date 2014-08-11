From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: journal recovery problems with metadata_csum, *non-64bit*
Date: Mon, 11 Aug 2014 00:10:25 -0700
Message-ID: <20140811071025.GE19223@birch.djwong.org>
References: <BLU437-SMTP3407533C3883653626BD3DFDEC0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaHKHKd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 03:10:33 -0400
Content-Disposition: inline
In-Reply-To: <BLU437-SMTP3407533C3883653626BD3DFDEC0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 10, 2014 at 06:35:33PM -0400, TR Reardon wrote:
> Ok, I found the problem in jbd2, and have a solution, though it's
> debatable what the ideal solution is.  For now, the simplest patch is
> below, though a similar patch in lib/ext2fs/kernel-jbd.h is required
> to get e2fsck back in sync.
> 
> The original c3900875 commit adding metadata_csum (ie
> journal_checksum_v2) to jbd2 added 2 extra bytes for the block
> checksums, in addition to re-allocating 2 bytes from the 4 bytes of
> flags.  However, a decision was made to only retain the lower 16-bits
> of the crc32c, and thus those extra 2 bytes were unneeded.  But those
> 2 extra bytes were never "deallocated" from journal_tag_bytes().

Hrmm... yes, I remember trying to push for full 32-bit checksums on journal
blocks, and our subsequent decision not to put in the two bytes.  Oops.

(This looks more like a coding error on my part.)

I suppose it would help to be able to use debugfs or something to create
journal transactions just to see if they'll replay correctly in the
kernel/e2fsck.  I've wondered for a while if the e2fsck jbd code ought to be
pushed into libext2fs (or libjbd2) to make this easier.  A long ago fuse2fs
patchbomb actually did this so that fuse2fs could at least replay the journal.

> Unfortunately, different code relies on JBD_TAG_SIZE32/64 constants
> directly rather than the journal_tag_bytes() utility function, in
> particular the recovery code which is common to e2fsck and jbd2.  This
> led different tools to think they were looking at a 64bit journal when
> actually it was 32bit.  Code that relied on journal_tag_bytes()
> remained safe, so the block iterators were fine, but any direct use of
> those constants [including the hideous greater-than comparison in
> read_tag_bytes()] went awry, and journal replay will fail.

Hmm... I thought recovery.c sets tag_bytes to journal_tag_bytes()?

(It's late, I'll have another look in the morning.)

> As far as I can tell, metadata_csum + journal checksum has never
> worked for 32bit filesystems. By a little bit of padding luck, 64bit
> worked fine.
`
D'oh. :(

FWIW, 64bit is recommended for metadata_csum since it enables full 32-bit
bitmap checksums.

> Now, as to the solution: depends on whether one feels that existing
> in-the-wild journals matter. The original commit was May 2012, are we
> past early-adopters now?  If this patch is taken, you shrink the

Definitely not past the early adopter stage.  The e2fsprogs code will be in
1.43, which means that most people can't use metadata_csum yet.

So, thank you very much for helping us to smoke test. :)

> journal block tags to the intended size but in-the-wild journals will
> be broken.  But they already are, so...?  This opens up the
> possibility of now using those extra 2 bytes and retaining full 32-bit
> crc32c for the block tags.  If going that route, debugs/logdump needs
> a fix in addition to changes to jbd2.

In theory the only wild journals should be on test FSes anyway, so breaking
them isn't the end of the world.

But as you point out, the space is already getting used because journal_csum_v2
is the gate for the extra 2 bytes to be turned on, so I guess we could just use
the extra 2 bytes and store the full checksum.

> FWIW, the "JBD2: Out of memory during recovery." error in
> fs/jbd2/recovery.c was opaque at best and should be changed to always
> include the block# that caused the problem.

recovery.c line 611, correct?

--D
> 
> +Reardon
> 
> ---
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 67b8e30..dc27d09 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2166,15 +2166,11 @@ int jbd2_journal_blocks_per_page(struct inode *inode)
>  size_t journal_tag_bytes(journal_t *journal)
>  {
>         journal_block_tag_t tag;
> -       size_t x = 0;
> -
> -       if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2))
> -               x += sizeof(tag.t_checksum);
> 
>         if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
> -               return x + JBD2_TAG_SIZE64;
> +               return JBD2_TAG_SIZE64;
>         else
> -               return x + JBD2_TAG_SIZE32;
> +               return JBD2_TAG_SIZE32;
>  }
> 
>  /*
