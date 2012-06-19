From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Tue, 19 Jun 2012 09:56:10 -0400
Message-ID: <20120619135610.GA10637@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120616000825.GE7363@thunk.org>
 <20120618055836.GA30557@thor.bakeyournoodle.com>
 <20120618171257.GA16017@thunk.org>
 <20120619054751.GA2660@thor.bakeyournoodle.com>
 <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51265 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab2FSN4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2012 09:56:16 -0400
Content-Disposition: inline
In-Reply-To: <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 19, 2012 at 12:01:54AM -0600, Andreas Dilger wrote:
> 
> That is what I would do, though perhaps with macro names that are not
> so confusingly similar to the actual macro names, which might otherwise
> cause confusion if someone doesn't read the code very closely.  Like:
> 
> #ifdef ENABLE_MMP
> ...
> #define EXT2_LIB_INCOMPAT_SUPP_MMP EXT4_FEATURE_INCOMPAT_MMP
> #else
> #define EXT2_LIB_INCOMPAT_SUPP_MMP (0)
> #endif

either name is fine with me; I'm not particularly picky here, since
the only place the #define would get used is the header file, the
opportunities for confusion are pretty limited.

> > 2) in debugfs you have a command table (debug_cmds.ct or similar) there
> > doesn't seem to be a way to exclude commands based on the state of
> > CONFIG_MMP.  Is it a problem the expose a debugfs command that will do
> > nothing when built with --disable-mmp, or should I look at extending
> > the command table generator to support the conditionals?

I'd have it print an error of some kind, i.e., "MMP not supported"


> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -1366,6 +1366,7 @@ errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
> > 			ext2_ino_t ino, int flags);
> > 
> > /* mmp.c */
> > +#ifdef CONFIG_MMP
> > errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
> > errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
> > errcode_t ext2fs_mmp_clear(ext2_filsys fs);
> > @@ -1374,6 +1375,7 @@ errcode_t ext2fs_mmp_start(ext2_filsys fs);
> > errcode_t ext2fs_mmp_update(ext2_filsys fs);
> > errcode_t ext2fs_mmp_stop(ext2_filsys fs);
> > unsigned ext2fs_mmp_new_seq(void);
> > +#endif /* CONFIG_MMP */
> 
> These should all conditionally become static inline no-op functions
> here (returning zero as needed) so that the calling code does not need
> messy #ifdefs everywhere.

If we've removed MMP from the list of supported features, a much
simpler thing we can do is to just add at the beginning of each of the
functions in mmp.c:

#ifndef CONFIG_MMP
	return EXT2_ET_OP_NOT_SUPPORTED;
#endif

and then letting the compiler optimize out the rest of the code in the
function; I wouldn't worry about using static inlines, since it's not
something we really need to optimize in this case.  The mmp functions
don't get called all that often anyway.

I also wouldn't bother commenting out the function signatures in
ext2fs.h.  For programs which are including ext2fs.h, they're not
going to be including the config.h which has CONFIG_* or ENABLE_*
autoconf #defines anyway.

Arguably all of the EXT2_LIB_* defines shouldn't be in ext2fs.h for
that reason; they should be in ext2fsP.h, and the only reason why they
aren't is due to history (since we didn't have ext2fsP.h when they
were first introduced).  At some point I'll probably move that logic
into ext2fsP.h, just to keep ext2fs.h smaller/cleaner for application
programs.

Regards,

						- Ted

P.S.  I'm debating whether or not it makes sense to create a special
static library just for bootloaders which is stripped down and
read-only.  I realized while looking at things that there is a pretty
large amount of coding getting dragged in due to namei.c pulling in
dir_iterate.c pulling in block_iterate.c pulling in extent.c, which
then pulls in a lot of code since we might need to allocate or
deallocate blocks.  If we made a read-only variant of the library, it
could significantly reduce the size of the statically linked
bootloader.  I'm not entirely sure it's worth it, since you don't seem
to be worrying about the compiled binary size of yaboot, but it's
something we could do if it was interesting.  What do you think?
