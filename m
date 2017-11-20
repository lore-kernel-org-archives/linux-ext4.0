From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2 1/7] e2fsck: add support for dirdata feature
Date: Mon, 20 Nov 2017 15:58:55 -0700
Message-ID: <5C7E26EA-503D-4111-BDE8-9DB1E9C62253@dilger.ca>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
 <20171114070440.79510-2-artem.blagodarenko@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_29A76C9F-D09B-448B-BE77-6595FCF89538";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Zhenyu Xu <bobijam.xu@intel.com>,
        Manisha Salve <msalve@ddn.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:34586 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdKTW7C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Nov 2017 17:59:02 -0500
Received: by mail-it0-f50.google.com with SMTP id m11so5625238iti.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 14:59:01 -0800 (PST)
In-Reply-To: <20171114070440.79510-2-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_29A76C9F-D09B-448B-BE77-6595FCF89538
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 14, 2017, at 12:04 AM, Artem Blagodarenko =
<artem.blagodarenko@gmail.com> wrote:
>=20
> From: Andreas Dilger <andreas.dilger@intel.com>
>=20
> Add support for the INCOMPAT_DIRDATA feature, which allows
> storing extra data in the directory entry beyond the name.
> This allows the Lustre File IDentifier to be accessed in
> an efficient manner, and would be useful for expanding a
> filesystem to allow more than 2^32 inodes in the future.
>=20
> Include this patches:
>=20
> e2fsck: e2fsck -D does not change dirdata content
>=20
> Fix dir optimization to preserve dirdata content for dot
> and dotdot entries.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-1774
> Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
> Change-Id: Iae190794da75a2080a8e5cc5b95a49e0c894f72f
>=20
> e2fsprogs: Consider DIRENT_LUFID flag in link_proc().
>=20
> While adding the new file entry in directory block, link_proc()
> calculates minimum record length of the existing directory entry
> without considering the dirent data size and which leads to
> corruption. Changed the code to use EXT2_DIR_REC_LEN() which will
> return correct record length including dirent data size.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-2462
> Signed-off-by: Manisha Salve <msalve@ddn.com>
> Change-Id: Ic593c558c47a78183143ec8e99d8385ac94d06f7
>=20
> libext2fs, e2fsck: don't use ext2_dir_entry_2
>=20
> Due to endian issues, do not use ext2_dir_entry_2 because it will
> have the wrong byte order on directory entries that are swabbed.
> Instead, use the standard practice of mask-and-shift to access the
> file_type and dirdata flags.
>=20
> Lustre-bug: https://jira.hpdd.intel.com/browse/LU-4677
> Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> ---
>=20
> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
> index 1b0504c8..1a719b2f 100644
> --- a/e2fsck/pass2.c
> +++ b/e2fsck/pass2.c
> +/*
> + * check for dirent data in ext3 dirent.
> + * return 0 if dirent data is ok.
> + * return 1 if dirent data does not exist.
> + * return 2 if dirent was modified due to error.
> + */
> +int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
> +			     unsigned int offset, struct problem_context =
*pctx)
> +{
> +	if (!(ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
> +		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +			/* clear dirent extra data flags. */
> +			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) =
{
> +				de->name_len &=3D (EXT2_FT_MASK << 8) |
> +						EXT2_NAME_LEN;
> +				return 2;
> +			}
> +		}
> +		return 1;
> +	}

This part is OK for LUFID, since we can reconstruct the FID from the =
inode
xattr.  However, for 64-bit inodes it would not be safe to drop the =
extra
dirdata fields.  It makes sense that e2fsck would force INCOMPAT_DIRDATA
to be set if INCOMPAT_INODE64 is set (and set INODE64 for > 2^32 =
inodes),
and tune2fs would not allow DIRDATA to be cleared in this case.

That isn't something to add in this patch, but please check it is done =
in
the inode64 patches.

> +	if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
> +		if (de->rec_len >=3D EXT2_DIR_REC_LEN(de) ||
> +		    de->rec_len + offset =3D=3D =
EXT2_BLOCK_SIZE(ctx->fs->super)) {
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 =
EXT2_DIRENT_LUFID) %
> +			    EXT2_DIRENT_LUFID_SIZE =3D=3D 1 /*size*/ + 1 =
/*NULL*/)
> +				return 0;
> +		}

See comments below about ext2_get_dirent_dirdata_size() NOT returning =
the NUL
byte, since that makes this code less clear, but it would need to be =
added
into the next check.

> +		/* just clear dirent data flags for now, we should fix =
FID data
> +		 * in lustre specific pass.
> +		 */
> +		if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
> +			ext2_fix_dirent_dirdata(de);
> +			if (ext2_get_dirent_dirdata_size(de,
> +							 =
EXT2_DIRENT_LUFID) !=3D
> +			    EXT2_DIRENT_LUFID_SIZE)
> +				de->name_len &=3D ~(EXT2_DIRENT_LUFID << =
8);
> +
> +			return 2;
> +		}

This will need to be smarter for INODE64.  It should preferably keep the
INO64 field over LUFID, since it is both smaller, and more important.
It would need to verify the field size is valid (=3D=3D 5), otherwise =
e2fsck
will have to fix this itself.  It would probably need to look for 64-bit
inodes in lost+found to match up with any entries that are pointing at
incorrect inodes, but that is for a later patch.

> @@ -528,6 +609,13 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
> 	int	filetype =3D ext2fs_dirent_file_type(dirent);
> 	int	should_be =3D EXT2_FT_UNKNOWN;
> 	struct ext2_inode	inode;
> +	__u8    dirdata =3D 0;
> +
> +	if (ctx->fs->super->s_feature_incompat &
> +			EXT4_FEATURE_INCOMPAT_DIRDATA) {

(style) align continued line after '(' on previous line.  Actually, this
should be using the ext2fs_has_feature_inode64() helper...

> @@ -1035,7 +1122,7 @@ inline_read_fail:
> 	if (((inline_data_size & 3) ||
> 	     (inline_data_size > EXT4_MIN_INLINE_DATA_SIZE &&
> 	      inline_data_size < EXT4_MIN_INLINE_DATA_SIZE +
> -				 EXT2_DIR_REC_LEN(1))) &&
> +				 __EXT2_DIR_REC_LEN(1))) &&
> 	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
> 		errcode_t err =3D fix_inline_dir_size(ctx, ino,
> 						    &inline_data_size, =
&pctx,

This reminds me - I heard that dirdata doesn't play nicely with =
inline_data
for very small directories?  We don't use inline_data together with =
Lustre,
but it might be something to check out in the future.  For now it =
probably
makes sense to disallow setting dirdata + inline_data at the same time =
until
this has been tested/fixed.

> diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
> index 6a975b36..8ed871ff 100644
> --- a/e2fsck/pass3.c
> +++ b/e2fsck/pass3.c
> @@ -717,11 +718,18 @@ static int fix_dotdot_proc(struct ext2_dir_entry =
*dirent,
> 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
> 	}
> 	dirent->inode =3D fp->parent;
> +
> +	dirdata  =3D dirent->name_len & (~EXT2_FT_MASK << 8);
> +
> 	if (ext2fs_has_feature_filetype(fp->ctx->fs->super))
> 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
> 	else
> 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
>=20
> +	if (fp->ctx->fs->super->s_feature_incompat &
> +	    EXT4_FEATURE_INCOMPAT_DIRDATA)

Should use ext2fs_has_feature_dirdata() helper function.

> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 486e1f21..8656c417 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
>=20
> static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char =
*buf,
> -				    ext2_ino_t ino, ext2_ino_t parent)
> +					ext2_ino_t ino, ext2_ino_t =
parent,
> +					struct ext2_dir_entry *dot_de,
> +					struct ext2_dir_entry =
*dotdot_de)
> {
> -	struct ext2_dir_entry 		*dir;
> -	struct ext2_dx_root_info  	*root;
> +	struct ext2_dir_entry		*dir;

(style) This would be better named as "dirent"

> +	struct ext2_dx_root_info	*root;
> 	struct ext2_dx_countlimit	*limits;
> -	int				filetype =3D 0;
> 	int				csum_size =3D 0;
> -
> -	if (ext2fs_has_feature_filetype(fs->super))
> -		filetype =3D EXT2_FT_DIR;
> +	int				offset;
> +	int				rec_len;
>=20
> 	memset(buf, 0, fs->blocksize);
> 	dir =3D (struct ext2_dir_entry *) buf;
> 	dir->inode =3D ino;
> -	dir->name[0] =3D '.';
> -	ext2fs_dirent_set_name_len(dir, 1);
> -	ext2fs_dirent_set_file_type(dir, filetype);
> -	dir->rec_len =3D 12;
> -	dir =3D (struct ext2_dir_entry *) (buf + 12);
> +
> +	ext2fs_dirent_set_name_len(dir, dot_de->name_len);
> +	dir->rec_len =3D dot_de->rec_len;
> +	rec_len	=3D EXT2_DIR_REC_LEN(dot_de);
> +	memcpy(dir->name, dot_de->name, rec_len);
> +	offset =3D rec_len;
> +
> +	dir =3D (struct ext2_dir_entry *) (buf + offset);

There is a macro NEXT_DIRENT() in pass2.c that could be used here:

	dir =3D NEXT_DIRENT(dir);

> +	/* set to jump over the index block */
> +
> 	dir->inode =3D parent;
> -	dir->name[0] =3D '.';
> -	dir->name[1] =3D '.';
> -	ext2fs_dirent_set_name_len(dir, 2);
> -	ext2fs_dirent_set_file_type(dir, filetype);
> -	dir->rec_len =3D fs->blocksize - 12;
>=20
> -	root =3D (struct ext2_dx_root_info *) (buf+24);
> +	ext2fs_dirent_set_name_len(dir, dotdot_de->name_len);
> +	dir->rec_len =3D fs->blocksize - rec_len;
> +	rec_len =3D EXT2_DIR_REC_LEN(dotdot_de);
> +	memcpy(dir->name, dotdot_de->name, rec_len);
> +	offset +=3D rec_len;
> +
> +	root =3D (struct ext2_dx_root_info *) (buf + offset);
> +
> 	root->reserved_zero =3D 0;
> 	root->hash_version =3D fs->super->s_def_hash_version;
> -	root->info_length =3D 8;
> +	root->info_length =3D sizeof(struct ext2_dx_root_info);

(style) sizeof(*root)

> 	root->indirect_levels =3D 0;
> 	root->unused_flags =3D 0;
> +	offset +=3D sizeof(struct ext2_dx_root_info);

	offset +=3D root->info_length;

> 	if (ext2fs_has_feature_metadata_csum(fs->super))
> 		csum_size =3D sizeof(struct ext2_dx_tail);
>=20
> -	limits =3D (struct ext2_dx_countlimit *) (buf+32);
> -	limits->limit =3D (fs->blocksize - (32 + csum_size)) /
> +	limits->limit =3D (fs->blocksize - (offset + csum_size)) /
> 			sizeof(struct ext2_dx_entry);
> +	limits =3D (struct ext2_dx_countlimit *) (buf + offset);

(defect) "limits" needs to be initialized before "limits->limit" is set?

> 	limits->count =3D 0;
>=20
> 	return root;
> @@ -647,7 +660,9 @@ static int alloc_blocks(ext2_filsys fs,
> static errcode_t calculate_tree(ext2_filsys fs,
> 				struct out_dir *outdir,
> 				ext2_ino_t ino,
> -				ext2_ino_t parent)
> +				ext2_ino_t parent,
> +				struct ext2_dir_entry *dot_de,
> +				struct ext2_dir_entry *dotdot_de)
> {
> 	struct ext2_dx_root_info	*root_info;
> 	struct ext2_dx_entry		*root, *int_ent, *dx_ent =3D 0;
> @@ -657,7 +672,9 @@ static errcode_t calculate_tree(ext2_filsys fs,
> 	int				i, c1, c2, c3, nblks;
> 	int				limit_offset, int_offset, =
root_offset;
>=20
> -	root_info =3D set_root_node(fs, outdir->buf, ino, parent);
> +	root_info =3D set_root_node(fs, outdir->buf, ino, parent, =
dot_de,
> +				  dotdot_de);
> +
> 	root_offset =3D limit_offset =3D ((char *) root_info - =
outdir->buf) +
> 		root_info->info_length;
> 	root_limit =3D (struct ext2_dx_countlimit *) (outdir->buf + =
limit_offset);
> @@ -944,11 +961,10 @@ resort:
> 	if (retval)
> 		goto errout;
>=20
> -	free(dir_buf); dir_buf =3D 0;

(defect) this looks like it is leaking memory now?

It would be better to use e2fsck_allocate_memory() instead of malloc(), =
so that
it would catch such leaks, but that is something to fix in a different =
patch.

> diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
> index 54b27772..e524139b 100644
> --- a/lib/ext2fs/dirblock.c
> +++ b/lib/ext2fs/dirblock.c
> @@ -50,6 +50,40 @@ errcode_t ext2fs_read_dir_block3(ext2_filsys fs, =
blk64_t block,
> 	return ext2fs_read_dir_block4(fs, block, buf, flags, 0);
> }
>=20
> +/*
> + * Compute the total directory entry data length.
> + * This includes the filename and an implicit NUL terminator (always =
present),

This part of the comment is incorrect (likely my fault for historical =
reasons).
The returned size does not include the filename length.

> + * and optional extensions.  Each extension has a bit set in the high =
4 bits of
> + * de->file_type, and the extension length is the first byte in each =
entry.
> + */
> +int ext2_get_dirent_dirdata_size(struct ext2_dir_entry *de,
> +				 char dirdata_flags)
> +{
> +	char *len =3D de->name + (de->name_len & EXT2_NAME_LEN) + 1 /* =
NUL */;

This should probably be renamed "lenp" since it is a pointer to the =
field
length, not the length itself.

> +	__u8 extra_data_flags =3D (de->name_len & ~(EXT2_FT_MASK << 8)) =
>> 12;
> +	int dlen =3D 0;
> +
> +	dirdata_flags >>=3D 4;
> +	while ((extra_data_flags & dirdata_flags) !=3D 0) {
> +		if (extra_data_flags & 1) {
> +			if (dirdata_flags & 1)
> +				dlen +=3D *len;
> +
> +			len +=3D *len;
> +		}
> +		extra_data_flags >>=3D 1;
> +		dirdata_flags >>=3D 1;
> +	}
> +
> +	/* add NUL terminator byte to dirdata length */
> +	return dlen + (dlen !=3D 0);

I think this NUL byte should be added to ext2_get_dirent_size() below,
but not into the return value of ext2_get_dirent_dirdata_size(), since
that adds complexity to the caller (e.g. e2fsck_check_dirent_data())
and makes it harder to understand what is being returned.

> +}
> +
> +int ext2_get_dirent_size(struct ext2_dir_entry *de)

This is a bit of a confusing name, since it doesn't return the dirent =
size,
but the dirdata size.  I suspect, based on the comment above, that this
_used_ to return the full dirent size, but it no longer does. It would =
be
better to rename this function "ext2_get_dirdata_size()" and the =
previous
function "ext2_get_dirdata_field_size()" or similar?

> +{
> +	return ext2_get_dirent_dirdata_size(de, ~EXT2_FT_MASK);
> +}
> +
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 6774e32c..b653012f 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
>=20
> +_INLINE_ struct ext2_dx_root_info *get_ext2_dx_root_info(ext2_filsys =
fs,
> +							 char *buf)
> +{
> +	struct ext2_dir_entry *de =3D (struct ext2_dir_entry *)buf;
> +
> +	if (!(fs->super->s_feature_incompat & =
EXT4_FEATURE_INCOMPAT_DIRDATA))
> +		return (struct ext2_dx_root_info *)(buf +
> +						    =
__EXT2_DIR_REC_LEN(1) +
> +						    =
__EXT2_DIR_REC_LEN(2));
> +
> +	/* get dotdot first */
> +	de =3D (struct ext2_dir_entry *)((char *)de + de->rec_len);
> +
> +	/* dx root info is after dotdot entry */
> +	de =3D (struct ext2_dir_entry *)((char *)de + =
EXT2_DIR_REC_LEN(de));

These would also benefit from the "NEXT_ENTRY()" macro, possibly renamed
to EXT2_DIRENTRY_NEXT() or similar for public use?

> +	return (struct ext2_dx_root_info *)de;
> +}
> +
> diff --git a/lib/ext2fs/lfsck.h b/lib/ext2fs/lfsck.h
> new file mode 100644
> index 00000000..9401cd0c
> --- /dev/null
> +++ b/lib/ext2fs/lfsck.h
> @@ -0,0 +1,42 @@
> +#ifndef LFSCK_H
> +#define LFSCK_H
> +
> +/* This is unfortunately needed for older lustre_user.h to be usable =
*/
> +#define LASSERT(cond)		do { } while (0)
> +
> +#ifdef HAVE_LUSTRE_LUSTREAPI_H
> +#include <lustre/lustreapi.h>
> +#elif HAVE_LUSTRE_LIBLUSTREAPI_H
> +#include <lustre/liblustreapi.h>
> +#endif

I don't think there is much value in including the Lustre headers here.
That was done long ago when the Lustre fsck was implemented as part of
e2fsck, but that is now gone.  Better to just #define the few fields
needed below as they are now.

> +#ifndef DFID
> +#define DFID "[%#llx:0x%x:0x%x]"
> +#define PFID(fid) ((unsigned long long)fid_seq(fid),\
> +		fid_oid(fid), fid_ver(fid))
> +struct lu_fid {
> +	__u64   f_seq;
> +	__u32   f_oid;
> +	__u32   f_ver;
> +};
> +#endif /* !DFID */
> +
> +/* Unfortunately, neither the 1.8 or 2.x lustre_idl.h file is =
suitable
> + * for inclusion by userspace programs because of external =
dependencies.
> + * Define the minimum set of replacement functions here until that is =
fixed.
> + */
> +#ifndef HAVE_LUSTRE_LUSTRE_IDL_H
> +#define fid_seq(fid) ((fid)->f_seq)
> +#define fid_oid(fid) ((fid)->f_oid)
> +#define fid_ver(fid) ((fid)->f_ver)
> +
> +static inline void fid_be_to_cpu(struct lu_fid *dst, struct lu_fid =
*src)
> +{
> +	dst->f_seq =3D ext2fs_be64_to_cpu(src->f_seq);
> +	dst->f_oid =3D ext2fs_be32_to_cpu(src->f_oid);
> +	dst->f_ver =3D ext2fs_be32_to_cpu(src->f_ver);
> +}
> +#endif
> +
> +#endif /* LFSCK_H */


Cheers, Andreas






--Apple-Mail=_29A76C9F-D09B-448B-BE77-6595FCF89538
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFaE14wpIg59Q01vtYRAr+UAJ9isa6T1X39ZLNAnIDdgBr87Rq3wwCg2xus
6jO6T4NgTsFCGcZJZIsgDlc=
=GCJr
-----END PGP SIGNATURE-----

--Apple-Mail=_29A76C9F-D09B-448B-BE77-6595FCF89538--
