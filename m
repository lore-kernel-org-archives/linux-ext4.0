From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] e2fsck: 3 level hash tree directory optimisation
Date: Mon, 30 Jan 2017 16:55:24 -0700
Message-ID: <30C8D695-B0B5-49FB-90BF-5EB6BDF7CF3C@dilger.ca>
References: <CAO3qy=GsANKJADH3NO=n9wpjmZGPVcjhJXrEX+Q7dJWSPuPU6Q@mail.gmail.com> <20170125172346.GH14029@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F98C21FF-937A-445C-AAB0-FE44FC2DE9CD"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Artem Blagodarenko <artem.blagodarenko@seagate.com>,
        linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36689 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdA3Xzv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2017 18:55:51 -0500
Received: by mail-it0-f68.google.com with SMTP id f200so2192044itf.3
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 15:55:30 -0800 (PST)
In-Reply-To: <20170125172346.GH14029@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_F98C21FF-937A-445C-AAB0-FE44FC2DE9CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 25, 2017, at 10:23 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Tue, Jan 24, 2017 at 09:08:20PM +0300, Artem Blagodarenko wrote:
>> e2fsck fixed for partitions with 3 level hash directries.
>> Additional level is added to e2fsck -D codepath.
>>=20
>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>> ---
>> debugfs/htree.c                          |    3 +-
>> e2fsck/e2fsck.h                          |    1 +
>> e2fsck/pass2.c                           |   72 +++++++++++++-----
>> e2fsck/rehash.c                          |  124 =
++++++++++++++++++++++++------
>> tests/d_fallocate_blkmap/expect          |    4 +-
>> tests/d_inline_dump/expect               |   12 ++--
>> tests/f_convert_bmap/expect.1            |    2 +-
>> tests/f_convert_bmap_and_extent/expect.1 |    2 +-
>> tests/f_create_symlinks/expect           |    8 +-
>> 9 files changed, 170 insertions(+), 58 deletions(-)
>>=20
>> diff --git a/debugfs/htree.c b/debugfs/htree.c
>> index 54e55e2..8c18666 100644
>> --- a/debugfs/htree.c
>> +++ b/debugfs/htree.c
>> @@ -287,7 +287,8 @@ void do_htree_dump(int argc, char *argv[])
>>     fprintf(pager, "\t Indirect levels: %d\n", =
rootnode->indirect_levels);
>>     fprintf(pager, "\t Flags: %d\n", rootnode->unused_flags);
>>=20
>> -    ent =3D (struct ext2_dx_entry *) (buf + 24 + =
rootnode->info_length);
>> +    ent =3D (struct ext2_dx_entry *)
>> +        ((char *)rootnode + rootnode->info_length);
>>=20
>>     htree_dump_int_node(current_fs, ino, &inode, rootnode, ent,
>>                 buf + current_fs->blocksize,
>> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
>> index f356810..a4efbdf 100644
>> --- a/e2fsck/e2fsck.h
>> +++ b/e2fsck/e2fsck.h
>> @@ -122,6 +122,7 @@ struct dx_dirblock_info {
>>     blk64_t        phys;
>>     int        flags;
>>     blk64_t        parent;
>> +    blk64_t        previous;
>>     ext2_dirhash_t    min_hash;
>>     ext2_dirhash_t    max_hash;
>>     ext2_dirhash_t    node_min_hash;
>> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
>> index 7ded7bb..9f5cd1b 100644
>> --- a/e2fsck/pass2.c
>> +++ b/e2fsck/pass2.c
>> @@ -85,6 +85,40 @@ struct check_dir_struct {
>>     unsigned long long next_ra_off;
>> };
>>=20
>> +static void update_parents(struct dx_dir_info *dx_dir, int type)
>> +{
>> +    struct dx_dirblock_info *dx_db, *dx_parent, *dx_previous;
>> +    int b;
>> +
>> +    for (b =3D 0, dx_db =3D dx_dir->dx_block;
>> +         b < dx_dir->numblocks;
>> +         b++, dx_db++) {
>> +        dx_parent =3D &dx_dir->dx_block[dx_db->parent];
>> +        if (dx_db->type !=3D type ||
>> +            !(dx_db->flags & (DX_FLAG_FIRST | DX_FLAG_LAST)))
>=20
> The flags check is redundant given the two if clauses.
>=20
>> +            continue;
>> +
>> +        /*
>> +         * XXX Make sure dx_parent->min_hash > dx_db->min_hash
>=20
> "XXX" in a comment makes me think this is unfinished...?
>=20
> Granted, you /did/ just copy & paste the code as-is.  Maybe it's =
better
> to let 15yo code sleep.
>=20
>> +        */
>> +        if (dx_db->flags & DX_FLAG_FIRST) {
>> +            dx_parent->min_hash =3D dx_db->min_hash;
>> +            if (dx_parent->previous) {
>> +                dx_previous =3D
>> +                    &dx_dir->dx_block[dx_parent->previous];
>> +                dx_previous->node_max_hash =3D
>> +                    dx_parent->min_hash;
>> +            }
>> +        }
>> +        /*
>> +         * XXX Make sure dx_parent->max_hash < dx_db->max_hash
>> +         */
>> +        if (dx_db->flags & DX_FLAG_LAST) {
>> +            dx_parent->max_hash =3D dx_db->max_hash;
>> +        }
>> +    }
>> +}
>> +
>> void e2fsck_pass2(e2fsck_t ctx)
>> {
>>     struct ext2_super_block *sb =3D ctx->fs->super;
>> @@ -182,24 +216,11 @@ void e2fsck_pass2(e2fsck_t ctx)
>>          * Find all of the first and last leaf blocks, and
>>          * update their parent's min and max hash values
>>          */
>> -        for (b=3D0, dx_db =3D dx_dir->dx_block;
>> -             b < dx_dir->numblocks;
>> -             b++, dx_db++) {
>> -            if ((dx_db->type !=3D DX_DIRBLOCK_LEAF) ||
>> -                !(dx_db->flags & (DX_FLAG_FIRST | DX_FLAG_LAST)))
>> -                continue;
>> -            dx_parent =3D &dx_dir->dx_block[dx_db->parent];
>> -            /*
>> -             * XXX Make sure dx_parent->min_hash > dx_db->min_hash
>> -             */
>> -            if (dx_db->flags & DX_FLAG_FIRST)
>> -                dx_parent->min_hash =3D dx_db->min_hash;
>> -            /*
>> -             * XXX Make sure dx_parent->max_hash < dx_db->max_hash
>> -             */
>> -            if (dx_db->flags & DX_FLAG_LAST)
>> -                dx_parent->max_hash =3D dx_db->max_hash;
>> -        }
>> +        update_parents(dx_dir, DX_DIRBLOCK_LEAF);
>> +
>> +        /* for 3 level htree: update 2 level parent's min
>> +         * and max hash values */
>> +        update_parents(dx_dir, DX_DIRBLOCK_NODE);
>>=20
>>         for (b=3D0, dx_db =3D dx_dir->dx_block;
>>              b < dx_dir->numblocks;
>> @@ -642,6 +663,10 @@ static void parse_int_node(ext2_filsys fs,
>>             dx_db->flags |=3D DX_FLAG_REFERENCED;
>>             dx_db->parent =3D db->blockcnt;
>>         }
>> +
>> +        dx_db->previous =3D
>> +            i ? ext2fs_le32_to_cpu(ent[i-1].block & 0x0ffffff) : 0;
>=20
> Why the bit masking?  Is it ever the case that the top byte is set?

The block number masking predates this patch, though it has changed from
using a 24-bit mask to a 28-bit mask to allow a larger directory to be =
used.

The reason for the mask on the block numbers is to allow the top bits to =
be
used for storing the "fullness" of the directory leaf block so that the
leaf blocks (and interior htree blocks) can be merged if large numbers =
of
entries in the directory are being deleted (i.e. directory shrink).  =
That
avoids the need to constantly scan adjacent blocks to determine if they =
are
empty enough to be merged, and rather store a fixed-point fraction (in =
1/16ths
of a block) of how full the leaf or htree block is.

The directory shrink hasn't been implemented, but the masking is cheap, =
and
those high bits aren't being used for anything else anyway.  Even with =
this
feature to expand the htree to 3 levels, the largest directory with 4KB =
blocks
is about 540 GB, or (4096/8)^3 =3D 27 bits.

>>         if (hash < min_hash)
>>             min_hash =3D hash;
>>         if (hash > max_hash)
>> @@ -949,6 +974,17 @@ static int check_dir_block(ext2_filsys fs,
>>             return DIRENT_ABORT;
>>     }
>>=20
>> +    /* This will allow (at some point in the future) to punch out =
empty
>> +     * directory blocks and reduce the space used by a directory =
that grows
>> +     * very large and then the files are deleted. For now, all that =
is
>> +     * needed is to avoid e2fsck filling in these holes as part of
>> +     * feature flag. */
>> +    if (db->blk =3D=3D 0 &&
>> +        EXT2_HAS_INCOMPAT_FEATURE(fs->super,
>> +                      EXT4_FEATURE_INCOMPAT_LARGEDIR)) {
>=20
> ext2fs_has_feature_large_dir()
>=20
>> +        return 0;
>> +    }
>> +
>>     if (db->blk =3D=3D 0 && !inline_data_size) {
>>         if (allocate_dir_block(ctx, db, buf, &cd->pctx))
>>             return 0;
>> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
>> index 22a58f3..6d7e3df 100644
>> --- a/e2fsck/rehash.c
>> +++ b/e2fsck/rehash.c
>> @@ -603,6 +603,42 @@ static struct ext2_dx_entry
>> *set_int_node(ext2_filsys fs, char *buf)
>>     return (struct ext2_dx_entry *) limits;
>> }
>>=20
>> +static int alloc_blocks(ext2_filsys fs,
>> +            struct ext2_dx_countlimit **limit,
>> +            struct ext2_dx_entry **prev_ent,
>> +            struct ext2_dx_entry **next_ent,
>> +            int *prev_offset, int *next_offset,
>> +            struct out_dir *outdir, int i,
>> +            int *prev_count, int *next_count)

Should align continued lines after '(' on previous line.

>> +{
>> +    errcode_t    retval;
>> +    char        *block_start;
>> +
>> +    if (*limit)
>> +        (*limit)->limit =3D (*limit)->count =3D
>> +            ext2fs_cpu_to_le16((*limit)->limit);
>> +    *prev_ent =3D (struct ext2_dx_entry *) (outdir->buf + =
*prev_offset);
>> +    (*prev_ent)->block =3D ext2fs_cpu_to_le32(outdir->num);
>> +
>> +    if (i !=3D 1)
>> +        (*prev_ent)->hash =3D
>> +            ext2fs_cpu_to_le32(outdir->hashes[i]);
>> +
>> +    retval =3D get_next_block(fs, outdir, &block_start);
>> +    if (retval)
>> +        return retval;
>> +
>> +    *next_ent =3D set_int_node(fs, block_start);
>> +    *limit =3D (struct ext2_dx_countlimit *)(*next_ent);
>> +    if (next_offset)
>> +        *next_offset =3D ((char *) *next_ent - outdir->buf);
>> +
>> +    *next_count =3D (*limit)->limit;
>> +    (*prev_offset) +=3D sizeof(struct ext2_dx_entry);
>> +    (*prev_count)--;
>> +return 0;
>=20
> Indentation.  Speaking of which, when did all the tabs change to "   =
"?

Right, definitely should be using tabs (8 columns).

Cheers, Andreas

>> +}
>> +
>> /*
>>  * This function takes the leaf nodes which have been written in
>>  * outdir, and populates the root node and any necessary interior =
nodes.
>> @@ -612,13 +648,13 @@ static errcode_t calculate_tree(ext2_filsys fs,
>>                 ext2_ino_t ino,
>>                 ext2_ino_t parent)
>> {
>> -    struct ext2_dx_root_info      *root_info;
>> -    struct ext2_dx_entry         *root, *dx_ent =3D 0;
>> -    struct ext2_dx_countlimit    *root_limit, *limit;
>> +    struct ext2_dx_root_info    *root_info;
>> +    struct ext2_dx_entry        *root, *int_ent, *dx_ent =3D 0;
>> +    struct ext2_dx_countlimit    *root_limit, *int_limit, *limit;
>>     errcode_t            retval;
>>     char                * block_start;
>> -    int                i, c1, c2, nblks;
>> -    int                limit_offset, root_offset;
>> +    int                i, c1, c2, c3, nblks;
>=20
> I defer to Ted on this, but I wonder if all the htree state would all =
be
> better off as a htree cursor structure rather than open coded stack
> variables.  OTOH that's a lot of churn and I don't figure we're likely
> to get to 4-level htree ever.
>=20
>> +    int                limit_offset, int_offset, root_offset;
>>=20
>>     root_info =3D set_root_node(fs, outdir->buf, ino, parent);
>>     root_offset =3D limit_offset =3D ((char *) root_info - =
outdir->buf) +
>> @@ -628,7 +664,7 @@ static errcode_t calculate_tree(ext2_filsys fs,
>>     nblks =3D outdir->num;
>>=20
>>     /* Write out the pointer blocks */
>> -    if (nblks-1 <=3D c1) {
>> +    if (nblks - 1 <=3D c1) {
>>         /* Just write out the root block, and we're done */
>>         root =3D (struct ext2_dx_entry *) (outdir->buf + =
root_offset);
>>         for (i=3D1; i < nblks; i++) {
>> @@ -639,31 +675,24 @@ static errcode_t calculate_tree(ext2_filsys fs,
>>             root++;
>>             c1--;
>>         }
>> -    } else {
>> +    } else if (nblks - 1 <=3D (c1 * ((fs->blocksize - 8) /
>> +                 sizeof(*root)))) {
>=20
> Wishing these were proper helper functions...
>=20
> if (nblks - 1 <=3D ext2fs_htree_intnode_maxrecs(c1)) {
>=20
>>         c2 =3D 0;
>> -        limit =3D 0;
>> +        limit =3D NULL;
>>         root_info->indirect_levels =3D 1;
>>         for (i=3D1; i < nblks; i++) {
>> -            if (c1 =3D=3D 0)
>> +            if (c2 =3D=3D 0 && c1 =3D=3D 0)
>>                 return ENOSPC;
>>             if (c2 =3D=3D 0) {
>> -                if (limit)
>> -                    limit->limit =3D limit->count =3D
>> -        ext2fs_cpu_to_le16(limit->limit);
>> -                root =3D (struct ext2_dx_entry *)
>> -                    (outdir->buf + root_offset);
>> -                root->block =3D ext2fs_cpu_to_le32(outdir->num);
>> -                if (i !=3D 1)
>> -                    root->hash =3D
>> -            ext2fs_cpu_to_le32(outdir->hashes[i]);
>> -                if ((retval =3D  get_next_block(fs, outdir,
>> -                                  &block_start)))
>> +                retval =3D alloc_blocks(fs, &limit,
>> +                             &root,
>> +                             &dx_ent,
>> +                             &root_offset,
>> +                             NULL,
>> +                             outdir, i,
>> +                             &c1, &c2);
>> +                if (retval)
>>                     return retval;
>> -                dx_ent =3D set_int_node(fs, block_start);
>> -                limit =3D (struct ext2_dx_countlimit *) dx_ent;
>> -                c2 =3D limit->limit;
>> -                root_offset +=3D sizeof(struct ext2_dx_entry);
>> -                c1--;
>>             }
>>             dx_ent->block =3D ext2fs_cpu_to_le32(i);
>>             if (c2 !=3D limit->limit)
>> @@ -674,6 +703,51 @@ static errcode_t calculate_tree(ext2_filsys fs,
>>         }
>>         limit->count =3D ext2fs_cpu_to_le16(limit->limit - c2);
>>         limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
>> +    } else {
>> +        c2 =3D 0;
>> +        c3 =3D 0;
>> +        limit =3D NULL;
>> +        int_limit =3D 0;
>> +        root_info->indirect_levels =3D 2;
>> +        for (i =3D 1; i < nblks; i++) {
>> +            if (c3 =3D=3D 0 && c2 =3D=3D 0 && c1 =3D=3D 0)
>> +                return ENOSPC;
>> +            if (c3 =3D=3D 0 && c2 =3D=3D 0) {
>> +                retval =3D alloc_blocks(fs, &int_limit,
>> +                             &root,
>> +                             &int_ent,
>> +                             &root_offset,
>> +                             &int_offset,
>> +                             outdir, i,
>> +                             &c1, &c2);
>> +                if (retval)
>> +                    return retval;
>> +            }
>> +            if (c3 =3D=3D 0) {
>> +                retval =3D alloc_blocks(fs, &limit,
>> +                             &int_ent,
>> +                             &dx_ent,
>> +                             &int_offset,
>> +                             NULL,
>> +                             outdir, i,
>> +                             &c2, &c3);
>> +                if (retval)
>> +                    return retval;
>> +
>> +            }
>> +            dx_ent->block =3D ext2fs_cpu_to_le32(i);
>> +            if (c3 !=3D limit->limit)
>> +                dx_ent->hash =3D
>> +                    ext2fs_cpu_to_le32(outdir->hashes[i]);
>> +            dx_ent++;
>> +            c3--;
>> +        }
>> +        int_limit->count =3D ext2fs_cpu_to_le16(limit->limit - c2);
>> +        int_limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
>> +
>> +        limit->count =3D ext2fs_cpu_to_le16(limit->limit - c3);
>> +        limit->limit =3D ext2fs_cpu_to_le16(limit->limit);
>> +
>>     }
>>     root_limit =3D (struct ext2_dx_countlimit *) (outdir->buf + =
limit_offset);
>>     root_limit->count =3D ext2fs_cpu_to_le16(root_limit->limit - c1);
>> diff --git a/tests/d_fallocate_blkmap/expect =
b/tests/d_fallocate_blkmap/expect
>> index 8ce79ff..f588511 100644
>> --- a/tests/d_fallocate_blkmap/expect
>> +++ b/tests/d_fallocate_blkmap/expect
>> @@ -18,7 +18,7 @@ debugfs: stat /a
>> Inode: 12   Type: regular    Mode:  0666   Flags: 0x0
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 40960
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>=20
> These belong in the patch that removes Directory ACL.
>=20
> --D
>=20
>> Links: 1   Blockcount: 82
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> @@ -30,7 +30,7 @@ debugfs: stat /b
>> Inode: 13   Type: regular    Mode:  0666   Flags: 0x0
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 10240000
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 20082
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> diff --git a/tests/d_inline_dump/expect b/tests/d_inline_dump/expect
>> index c84f64d..f0ba471 100644
>> --- a/tests/d_inline_dump/expect
>> +++ b/tests/d_inline_dump/expect
>> @@ -2,7 +2,7 @@
>> Inode: 13   Type: regular    Mode:  0644   Flags: 0x10000000
>> Generation: 3289262644    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 80
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec6b4:c72e3c00 -- Tue Jul 22 20:16:52 2014
>> @@ -18,7 +18,7 @@ Size of inline data: 80
>> Inode: 18   Type: regular    Mode:  0644   Flags: 0x10000000
>> Generation: 3842229473    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 20
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec6b4:cafecc00 -- Tue Jul 22 20:16:52 2014
>> @@ -35,7 +35,7 @@ Size of inline data: 60
>> Inode: 16   Type: directory    Mode:  0755   Flags: 0x10000000
>> Generation: 3842229469    Version: 0x00000000:00000004
>> User:     0   Group:     0   Size: 132
>> -File ACL: 7    Directory ACL: 0
>> +File ACL: 7
>> Links: 2   Blockcount: 8
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec6e3:27eac000 -- Tue Jul 22 20:17:39 2014
>> @@ -51,7 +51,7 @@ Size of inline data: 132
>> Inode: 20   Type: directory    Mode:  0755   Flags: 0x10000000
>> Generation: 3710818931    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 60
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 2   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec6b4:ca0aa800 -- Tue Jul 22 20:16:52 2014
>> @@ -68,7 +68,7 @@ Size of inline data: 60
>> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x10000000
>> Generation: 3289262643    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 80
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec47f:724db800 -- Tue Jul 22 20:07:27 2014
>> @@ -83,7 +83,7 @@ Fast link dest:
>> "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>> Inode: 19   Type: symlink    Mode:  0777   Flags: 0x0
>> Generation: 3842229474    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 20
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x53cec44c:a1fcc000 -- Tue Jul 22 20:06:36 2014
>> diff --git a/tests/f_convert_bmap/expect.1 =
b/tests/f_convert_bmap/expect.1
>> index 7d2ca86..0291f94 100644
>> --- a/tests/f_convert_bmap/expect.1
>> +++ b/tests/f_convert_bmap/expect.1
>> @@ -2,7 +2,7 @@ debugfs: stat /a
>> Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
>> Generation: 1573716129    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 524288
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 1030
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
>> diff --git a/tests/f_convert_bmap_and_extent/expect.1
>> b/tests/f_convert_bmap_and_extent/expect.1
>> index 7af91aa..eb55db7 100644
>> --- a/tests/f_convert_bmap_and_extent/expect.1
>> +++ b/tests/f_convert_bmap_and_extent/expect.1
>> @@ -2,7 +2,7 @@ debugfs: stat /a
>> Inode: 12   Type: regular    Mode:  0644   Flags: 0x0
>> Generation: 1573716129    Version: 0x00000000:00000001
>> User:     0   Group:     0   Size: 524288
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 1030
>> Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x5457f87a:62ae2980 -- Mon Nov  3 21:49:46 2014
>> diff --git a/tests/f_create_symlinks/expect =
b/tests/f_create_symlinks/expect
>> index dca6e92..4409385 100644
>> --- a/tests/f_create_symlinks/expect
>> +++ b/tests/f_create_symlinks/expect
>> @@ -20,7 +20,7 @@ debugfs -R "stat /l_30" test.img
>> Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 31
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> @@ -29,7 +29,7 @@ debugfs -R "stat /l_70" test.img
>> Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 71
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 0
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> @@ -40,7 +40,7 @@ debugfs -R "stat /l_500" test.img
>> Inode: 14   Type: symlink    Mode:  0777   Flags: 0x80000
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 501
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 2
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> @@ -50,7 +50,7 @@ debugfs -R "stat /l_1023" test.img
>> Inode: 15   Type: symlink    Mode:  0777   Flags: 0x80000
>> Generation: 0    Version: 0x00000000:00000000
>> User:     0   Group:     0   Project:     0   Size: 1024
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>> Links: 1   Blockcount: 2
>> Fragment:  Address: 0    Number: 0    Size: 0
>> Size of extra inode fields: 32
>> --


Cheers, Andreas






--Apple-Mail=_F98C21FF-937A-445C-AAB0-FE44FC2DE9CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWI/SbXKl2rkXzB/gAQhP1w//TzrcywQFROzy5o7TZiEdPtWWrEOZ8vse
W6ExwN6pS21ZiL/45KSz6tLHt33bXew2vnbroXaDFddOA4D/wK0/NsvWWTr8RY76
7kDv0jfzfymYSKMrf7d8H6yP+43JvOgsxp5skfpgUqLysAc2WN4w4GQxyuUA2zSB
gPy1KurEnUCd+KYnRXp23zAO0jo+KbeoiVEVdquF+D86bp5ockCvz6Ufgi0IiWVg
qr+h1YUxU3aSonAqiVx64jX3PP1TdjLj29wp+zO9/qewCQqGUk34He36o0RhrEDG
LZCnemYBasEfFAYLhqS/TA+YPkMdlyl6hWb0wDrbXnUQoqc5G74/jY7wm3ony9XJ
BzpDVjby03cGw+8dHjGtmvXiddDwPQ3Es+vMyn0ZqwyxMpGCAbypTGUULceFeVC8
6Lc8NzC4KHn+D8++fhUYG3qzkmH4QjlQerCkHxk2iTQeI8DyCtu0RJhsk2t/2q3A
lLJKO+MD1eZ++Z6WatULPmziZgNaMIry+SsK81yfqg6rcoVqbwChjelVgULGV2YH
OHMV1z2wiigNVnwWx0bBSBPITuMVYnnC0HsWpocC2LS8R5EV/mVOS5u8ZETV30Sd
kRNm1Ft48WPnV43E0qFGDd3BgmSDMlKsDLOrFZLg2uxwoeRN5shBpeJoVT/PnroY
o5e2ok8PnVs=
=r98K
-----END PGP SIGNATURE-----

--Apple-Mail=_F98C21FF-937A-445C-AAB0-FE44FC2DE9CD--
