From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 09/37] e2fsck: Verify and correct inode checksums
Date: Mon, 5 Sep 2011 12:05:28 -0700
Message-ID: <20110905190528.GT12086@tux1.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003609.1176.69789.stgit@elm3c44.beaverton.ibm.com> <602E4E43-7583-4E33-92FB-46CFB14A567F@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43584 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1IETFb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Sep 2011 15:05:31 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p85IvVQO029364
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 12:57:31 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p85J5VIX162070
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 13:05:31 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p85D5TsG009960
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 07:05:30 -0600
Content-Disposition: inline
In-Reply-To: <602E4E43-7583-4E33-92FB-46CFB14A567F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 04, 2011 at 12:17:49PM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:36 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > Detect mismatches of the inode and checksum, and prompt the user to fix the
> > situation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > e2fsck/pass1.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > e2fsck/problem.c |   15 +++++++++++++++
> > e2fsck/problem.h |    9 +++++++++
> > 3 files changed, 76 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> > index ba17b30..e9b0876 100644
> > --- a/e2fsck/pass1.c
> > +++ b/e2fsck/pass1.c
> > @@ -540,6 +540,50 @@ extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
> >        *ret = 0;
> > }
> > 
> > +static int validate_inode_checksum(ext2_filsys fs,
> > +                   e2fsck_t ctx,
> > +                   struct problem_context *pctx,
> > +                   ext2_ino_t ino,
> > +                   struct ext2_inode_large *inode)
> > +{
> > +    struct ext2_inode_large *linode = (struct ext2_inode_large *)inode;
> > +
> > +    /* Ignore non-Linux filesystems */
> > +    if (fs->super->s_creator_os != EXT2_OS_LINUX)
> > +        return 0;
> > +
> > +    /* Check for checksums present even w/o feature flag */
> > +    if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +                    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
> > +        linode->i_checksum &&
> > +        fix_problem(ctx, PR_1_INODE_CSUM_NONZERO, pctx)) {
> > +        e2fsck_write_inode(ctx, ino, inode, "pass1");
> > +        return PR_1_INODE_CSUM_NONZERO;
> > +    }
> > +
> > +    /* Check for invalid inode checksum */
> > +    if (ext2fs_inode_csum_verify(fs, ino, linode))
> > +        return 0;
> > +
> > +    /*
> > +     * TODO: Change the following check to use the inode badness patch.
> > +     * For the moment we'll just assume that the user wants to clear the
> > +     * bad inode.
> > +     */
> > +    if (fix_problem(ctx, PR_1_INODE_CORRUPT, pctx)) {
> > +        e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
> 
> IMHO this would make the checksums _less_ robust than the current code. 
> 
> Currently it is possible to handle minor corruptions without erasing the
> whole inode.  If there was a problem that affected the whole filesystem (e.g.
> if the METADATA_CSUM flag is set with debugfs, change the filesystem UUID,
> etc) this would irrevocably erase the entire filesystem when "e2fsck -p/-y"
> was run. 
> 
> I think making it contribute to the inode badness in e2fsck is the only way
> to go. For the kernel it is OK to treat a bad checksum as -EIO, since that
> doesn't actually cause the inode to be erased, unlike this check. 

I wonder, what is the status of that badness patch?  I don't see it in upstream
e2fsprogs.

As I was writing all this e2fsck code the thought occurred to me that perhaps
the checksum should be verified last, and if it's found bad, then we simply
offer to reset the checksum.  That way, if the metadata is really defective,
the earlier structural checks will catch it, and if the metadata simply has an
incorrect checksum (and everything else is ok) then we let it live.

> > +        if (ino == EXT2_BAD_INO)
> > +            ext2fs_mark_inode_bitmap2(ctx->inode_used_map,
> > +                          ino);
> > +        return PR_1_INODE_CORRUPT;
> > +    } else if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, pctx)) {
> > +        e2fsck_write_inode(ctx, ino, inode, "pass1");
> > +        return PR_1_INODE_CSUM_INVALID;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > void e2fsck_pass1(e2fsck_t ctx)
> > {
> >    int    i;
> > @@ -707,8 +751,10 @@ void e2fsck_pass1(e2fsck_t ctx)
> > 
> >    while (1) {
> >        old_op = ehandler_operation(_("getting next inode from scan"));
> > +        ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
> >        pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
> >                              inode, inode_size);
> > +        ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
> >        ehandler_operation(old_op);
> >        if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
> >            return;
> > @@ -740,6 +786,12 @@ void e2fsck_pass1(e2fsck_t ctx)
> >            }
> >        }
> > 
> > +        check_inode_extra_space(ctx, &pctx);
> 
> This is already being called once per inode (later on) so there is no reason to call it twice for every inode. 

Ok.

--D

> > +        /* Validate inode checksum.  i_extra_isize must be sane. */
> > +        if (validate_inode_checksum(fs, ctx, &pctx, ino, inode) ==
> > +            PR_1_INODE_CORRUPT)
> > +            continue;
> > +
> >        /*
> >         * Test for incorrect extent flag settings.
> >         *
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index c5bebf8..b5176d4 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -905,6 +905,21 @@ static struct e2fsck_problem problem_table[] = {
> >      N_("Error converting subcluster @b @B: %m\n"),
> >      PROMPT_NONE, PR_FATAL },
> > 
> > +    /* inode checksum probably not set */
> > +    { PR_1_INODE_CSUM_INVALID,
> > +      N_("@i %i checksum incorrect.  "),
> > +      PROMPT_FIX, PR_PREEN_OK },
> > +
> > +    /* inode checksum probably set, but does not match */
> > +    { PR_1_INODE_CORRUPT,
> > +      N_("@i %i checksum shows corruption.  "),
> > +      PROMPT_CLEAR, PR_PREEN_OK },
> > +
> > +    /* inode checksumming disabled, yet checksum is probably set? */
> > +    { PR_1_INODE_CSUM_NONZERO,
> > +      N_("@i %i checksum should not be set.  "),
> > +      PROMPT_CLEAR, PR_PREEN_OK },
> > +
> >    /* Pass 1b errors */
> > 
> >    /* Pass 1B: Rescan for duplicate/bad blocks */
> > diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> > index a4d96ae..4e353b7 100644
> > --- a/e2fsck/problem.h
> > +++ b/e2fsck/problem.h
> > @@ -529,6 +529,15 @@ struct problem_context {
> > /* Failed to convert subcluster bitmap */
> > #define PR_1_CONVERT_SUBCLUSTER        0x010061
> > 
> > +/* inode checksum probably not set */
> > +#define PR_1_INODE_CSUM_INVALID        0x010062
> > +
> > +/* inode checksum probably set, but does not match */
> > +#define PR_1_INODE_CORRUPT        0x010063
> > +
> > +/* inode checksum should not be set */
> > +#define PR_1_INODE_CSUM_NONZERO        0x010064
> > +
> > /*
> >  * Pass 1b errors
> >  */
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
