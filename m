From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] e2fsprogs: clean up codes for adding new quota type
Date: Mon, 20 Jan 2014 14:40:15 -0800
Message-ID: <20140120224015.GO9229@birch.djwong.org>
References: <CAPTn0cBB=aEunH9sK+DTC=_WsmnaQSdu=ajU0JsXvgfB2fAMew@mail.gmail.com>
 <5FD9AE93-B8AE-4221-AA43-EFCF6BFB5896@dilger.ca>
 <CAPTn0cBVcGo4J=wy3zUP-3eh1WeZqVz=sC4PW0OUQEGxvMdYbA@mail.gmail.com>
 <A6EAF88F-7A38-4D67-8DC1-D80F32CDA8BA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <sihara@ddn.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24600 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaATWkY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jan 2014 17:40:24 -0500
Content-Disposition: inline
In-Reply-To: <A6EAF88F-7A38-4D67-8DC1-D80F32CDA8BA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 02:22:30PM -0700, Andreas Dilger wrote:
> 
> On Jan 17, 2014, at 1:06 AM, Li Xi <pkuelelixi@gmail.com> wrote:
> > Andreas, I've updated the patch which should have fixed most of the
> > problems you pointed out.
> 
> Minor note - if you are resubmitting a patch, please do not copy the
> original patch in the email, since this is a bit confusing.  Just send
> in the new patch.
> 
> > And I'd like to add a sanity test suit to check that MAXQUOTAS is < 32
> > as you said. Where do you think is the place I should add it? Thanks!
> 
> I think that could be a compile-time check:
> 
> #if MAXQUOTAS > 32
> #error "cannot have more than 32 quota types to fit in qtype_bits"
> #endif
> 
> or similar.  This could easily be increased to 64, but I don't think
> it will be a limit we actually hit.
> 
> > Changelog:
> > * V2:
> >  - Change type2* functions to quota_type2*
> >  - Use uncontinuous array of s_quota_inum
> >  - Add quota_type_t
> >  - Fix a problem of quota_write_inode() in the first patch
> >  - Rename USRQUOTA_BIT/GRPQUOTA_BIT/ALLQUOTA_BIT to QUOTA_*_BIT
> >  - Code style change
> > 
> > Signed-off-by: Li Xi <lixi <at> ddn.com>
> > --
> > Index: e2fsprogs.git/lib/e2p/ls.c
> > ===================================================================
> > --- e2fsprogs.git.orig/lib/e2p/ls.c
> > +++ e2fsprogs.git/lib/e2p/ls.c
> > @@ -23,6 +23,7 @@
> > @@ -426,13 +441,12 @@ void list_super2(struct ext2_super_block
> >         fprintf(f, "MMP update interval:      %u\n",
> >             sb->s_mmp_update_interval);
> >     }
> > -    if (sb->s_usr_quota_inum)
> > -        fprintf(f, "User quota inode:         %u\n",
> > -            sb->s_usr_quota_inum);
> > -    if (sb->s_grp_quota_inum)
> > -        fprintf(f, "Group quota inode:        %u\n",
> > -            sb->s_grp_quota_inum);
> > -
> > +    for (type = 0; type < MAXQUOTAS; type++) {
> > +        if (sb->s_quota_inum[quota_type2offset(type)])
> > +            fprintf(f, "%s quota inode:         %u\n",
> 
> (minor) This will misalign the inode numbers, because the name lengths
> are different.  I don't know if that is a huge deal or not.
> 
> > Index: e2fsprogs.git/lib/quota/mkquota.c
> > ===================================================================
> > --- e2fsprogs.git.orig/lib/quota/mkquota.c
> > +++ e2fsprogs.git/lib/quota/mkquota.c
> > @@ -211,9 +210,11 @@ static void quota_dnode_free(dnode_t *no
> > /*
> >  * Set up the quota tracking data structures.
> >  */
> > -errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
> > +errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
> > +                 unsigned int qtype_bits)
> 
> (style) this should align after '(' from the previous line
> 
> > Index: e2fsprogs.git/e2fsck/unix.c
> > ===================================================================
> > --- e2fsprogs.git.orig/e2fsck/unix.c
> > +++ e2fsprogs.git/e2fsck/unix.c
> > @@ -1623,14 +1623,14 @@ print_unsupp_features:
> >         journal_size = -1;
> > 
> >     if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
> > +        quota_type_t i;
> 
> (style) It wouldn't be bad to use a different variable name than "i"
> for the quota type in all of these loops, like "qtype".
> 
> >         /* Quotas were enabled. Do quota accounting during fsck. */
> > +        for (i = 0; i < MAXQUOTAS; i++) {
> > +            if (sb->s_quota_inum[quota_type2offset(i)])
> > +                qtype_bits |= 1 << i;
> > +        }
> > Index: e2fsprogs.git/lib/quota/quotaio.c
> > ===================================================================
> > --- e2fsprogs.git.orig/lib/quota/quotaio.c
> > +++ e2fsprogs.git/lib/quota/quotaio.c
> > @@ -37,15 +37,31 @@ struct disk_dqheader {
> > /**
> >  * Convert type of quota to written representation
> >  */
> > -const char *type2name(int type)
> > +const char *quota_type2name(quota_type_t type)
> 
> (style) use "qtype" as variable name for consistency with the name
> in quota_type2ino().
> 
> > {
> >     return extensions[type];
> > }
> > 
> > +ext2_ino_t quota_type2ino(quota_type_t qtype)
> > +{
> > +    switch (qtype) {
> > +    case USRQUOTA:
> > +        return EXT4_USR_QUOTA_INO;
> > +        break;
> > +    case GRPQUOTA:
> > +        return EXT4_GRP_QUOTA_INO;
> > +        break;
> > +    default:
> > +        return 0;
> > +        break;
> > +    }
> > +    return 0;
> > +}
> 
> Are there ever cases where these functions are called with qtype that
> is not from 0..MAXQUOTAS?  Otherwise, quota_type2name() will overflow
> the array, and quota_type2ino() will return an invalid inode that will
> be used by the caller.
> 
> > Index: e2fsprogs.git/lib/quota/quotaio.h
> > ===================================================================
> > --- e2fsprogs.git.orig/lib/quota/quotaio.h
> > +++ e2fsprogs.git/lib/quota/quotaio.h
> > @@ -158,8 +166,26 @@ void update_grace_times(struct dquot *q)
> >    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
> > #define QUOTA_NAME_LEN 16
> > 
> > 
> > +static inline int quota_type2offset(quota_type_t qtype)
> > +{
> > +    switch (qtype) {
> > +        case USRQUOTA:
> > +            return 0;
> > +        case GRPQUOTA:
> > +            return 1;
> > +        /* Skip s_overhead_blocks like this */
> > +        /*
> > +        case PRJQUOTA:
> > +            return 3;
> > +        */
> > +        default:
> > +            return -1;
> 
> Since the callers of this function do not check for errors, returning
> "-1" for bad qtype means that it will dereference the field before
> s_quota_inum[], namely s_mount_opts[].  That means callers of this
> function need to ensure they always call it with a valid qtype.
> 
> It might make sense to have it return some very large negative value
> to try and hit a segfault in this case (e.g. 0x80000000), or just add
> an assert() here?  I'm not sure what Ted prefers.

I suppose one could change the function to pass in the base pointer to the
array and return a (possibly NULL) pointer to the appropriate array member, so
that invalid inputs produce immediate crashes.

(I'm not so big of a fan of returning huge numbers and hoping that causes
segfaults.)

> > Index: e2fsprogs.git/debugfs/set_fields.c
> > ===================================================================
> > --- e2fsprogs.git.orig/debugfs/set_fields.c
> > +++ e2fsprogs.git/debugfs/set_fields.c
> > @@ -147,8 +147,8 @@ static struct field_set_info super_field
> >       NULL, 8, parse_uint },
> >     { "snapshot_list", &set_sb.s_snapshot_list, NULL, 4, parse_uint },
> >     { "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
> > -    { "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
> > -    { "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
> > +    { "quota_inum", &set_sb.s_quota_inum, NULL, 4, parse_uint, FLAG_ARRAY,
> > +      2 },
> 
> I wonder if it makes sense to keep the usr_quota_inum and grp_quota_inum
> options here for compatibility and ease of use?  I suspect it is easier
> to understand what "usr_quota_inum" is, compared to "quota_inum[0]"...

It would certainly be less churn for anyone pumping scripts into debugfs.

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


