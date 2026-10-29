Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278295;
	b=h8e1jUAoZgEYUltE0khsL7P6Jn2ErPUUSIIQvNgUOU7Ad54Uq87Tqi77D7tXxaQtBNGW
	 W1aAbsr1yKhRxEmopTCVmNcq9ZlPy1Yqd5jGjRdzhICcJNc6ziqiXM/fdousahT08fmuV
	 dUnqGnrshJ7qgmgzLx5eCwI6I0KbaJKEevzM6LwsD9kpF2Ppsj8Ni5nTp40zL8ue0ZIbK
	 7H3/tXruzRS0rvY9TV72LIKE196lZbaT6+P4FRxrkVaT66wWg4o1Zd6O0wxKesVQNOosh
	 y4Q6fpedv2twW0t0hH1GeL/f80aL62jskQgAwYhVE4yxxv7naALNM2nhvndMxJuAUag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278295;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=AbELI6E7cp/Ad03x92xdh+mQfdBS3qqOUYJbrE7YeIg=;
	b=HjYY+3fCKGgqyXsnFGYu2rxYHEAeBi3DGIFE+ljfEGEpFqThg58QzMk3435lBppkK5yq
	 RgWkTLnLulCvPVAPvl+s91O0kobde+Ueca/fiken4OIcbVcqanJFwAsKL/SuEyCOsZZCd
	 aL3eLs22HyIWgGAr0u7X+nJOAggRjI+F+VJylFk8ji2+lMzbHaPZ1cwrG8EjS2BKwRdpy
	 MsLs7sIFVhRB65CDANmZFlUtrgfVjV6d2qF24cuaviwwJnzZ6TddGuSqI8j8SbIDHPHOM
	 71FStF3kWCRz7AlngiYb/qsubMPKwb9VmqLdFpWrRtGYR0WKuXMohVKDEbwD/L0mHDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmUC+kEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6218606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SmUC+kEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D161F01825;
	Thu, 29 Oct 2026 12:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278294;
	bh=AbELI6E7cp/Ad03x92xdh+mQfdBS3qqOUYJbrE7YeIg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SmUC+kEgnwdIsLMyDe6xS1CQmfB51WKjypJyKbc7qgtkMcW/2psqpGKMRzL6cXdwk
	 60sHx05plKolSPQRmnOl9hbFEzx5gkQj2OTBK2mBvjn4QbBusXBgz664jqI220L9w4
	 GNYV5q1hYb/7Goh4IRQJx/Q+Ga65ZcXuoFqttllGWVCZgfOEZPsrYyl+CENQuxVMij
	 HHF0Z5SM9Agj84JyuDwXn82Pjk/6uO9WhykoWSf22us8SraJ+V90RVtRYUeUQd0L86
	 WHmlYzvEKDnc478rmgwN+UHfovq+XTJSZA740UeUGJ4ZWxuivALqbxLfWeUt26aTeZ
	 SnR3410RbohmQ==
Message-ID: <sashiko-outbox-189320@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 08/11] ext4: dirdata feature
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-9-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-9-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:51:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] ext4: missing legacy hash size in ext4_dirent_rec_len() with d=
irdata
- [High] ext4: out-of-bounds read of htree root dirents in ext4_htree_store=
_dirent()
- [High] ext4: out-of-bounds read in ext4_dx_csum_verify() via get_dx_count=
limit()
- [Medium] ext4: uninitialized stack read of fake dirent in ext4_htree_stor=
e_dirent()
--

commit 31cebce918ae1e358449a063cc4a21909275ec8a
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: dirdata feature

This commit enables the EXT4_FEATURE_INCOMPAT_DIRDATA feature flag and upda=
tes
directory entry handling across htree, inline directory, and directory entry
insertion paths to account for variable-length dirdata records stored after
the filename.

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 38911ae2bcfc0..15816f2a5f472 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -483,27 +483,43 @@ void ext4_htree_free_dir_info(struct dir_private_in=
fo *p)
>   * The decrypted filename is passed in via ent_name.  parameter.
>   */
>  int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
> -			     __u32 minor_hash,
> +			     __u32 minor_hash, int buf_size,
>  			    struct ext4_dir_entry_2 *dirent,
>  			    struct fscrypt_str *ent_name)
>  {
>  	struct rb_node **p, *parent =3D NULL;
>  	struct fname *fname, *new_fn;
>  	struct dir_private_info *info;
> +	int extra_data =3D 0;
> =20
>  	info =3D dir_file->private_data;
>  	p =3D &info->root.rb_node;
> =20
>  	/* Create and allocate the fname structure */
> -	new_fn =3D kzalloc_flex(*new_fn, name, ent_name->len + 1);
> +	if (dirent->file_type & ~EXT4_FT_MASK) {
> +		unsigned int rec_len =3D
> +			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
> +		extra_data =3D ext4_dirent_get_data_len(dirent, rec_len);
> +	}

[Severity: Medium]
Can this read uninitialized stack memory from fake.file_type and fake.name[]
when called from ext4_inlinedir_to_tree()?

In fs/ext4/inline.c, ext4_inlinedir_to_tree() declares struct ext4_dir_entr=
y_2
fake on the stack without initializing it, and populates it for the "." and
".." entries:

fs/ext4/inline.c:ext4_inlinedir_to_tree() {
    struct ext4_dir_entry_2 fake;
    ...
        if (pos =3D=3D 0) {
            fake.inode =3D cpu_to_le32(inode->i_ino);
            fake.name_len =3D 1;
            memcpy(fake.name, ".", 2);
            fake.rec_len =3D ext4_rec_len_to_disk(
                      ext4_dirent_rec_len(fake.name_len, NULL),
                      inline_size);
            ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
            de =3D &fake;
            pos =3D EXT4_INLINE_DOTDOT_OFFSET;
}

However, ext4_set_de_type() only writes de->file_type when the filetype
feature is enabled:

fs/ext4/ext4.h:ext4_set_de_type() {
    if (ext4_has_feature_filetype(sb))
        de->file_type =3D ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
}

On a filesystem with inline_data and dir_index enabled but without
EXT4_FEATURE_INCOMPAT_FILETYPE, fake.file_type and fake.name[2..3] remain
uninitialized on the stack when ext4_inlinedir_to_tree() passes de =3D &fak=
e to
ext4_htree_store_dirent().

If any upper bit of the uninitialized fake.file_type is non-zero,
ext4_dirent_get_data_len(&fake, 12) reads ddh->ddh_length from uninitialized
stack bytes fake.name[2..3] and unsafe_memcpy() copies those uninitialized
bytes into new_fn->name.

The later commit in the series ("ext4: add dirdata set/get helpers") gates
this check on ext4_has_feature_dirdata() and also calls ext4_dirdata_get() =
on
de in ext4_inlinedir_to_tree(), but neither ext4_feature_set_ok() nor
ext4_dirdata_get() requires EXT4_FEATURE_INCOMPAT_FILETYPE when
EXT4_FEATURE_INCOMPAT_DIRDATA is enabled, and fake.file_type is still left
uninitialized before ext4_set_de_type().

Should ext4_inlinedir_to_tree() initialize fake.file_type =3D EXT4_FT_UNKNO=
WN
before calling ext4_set_de_type(), matching ext4_insert_dentry_data()?

[ ... ]

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index e54608950fb34..30bbf6a56bf64 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -402,23 +402,32 @@ static struct dx_countlimit *get_dx_countlimit(stru=
ct inode *inode,
>  {
>  	struct ext4_dir_entry_2 *de;
>  	struct dx_root_info *root;
> -	int count_offset;
> +	int count_offset, dotdot_rec_len;
>  	int blocksize =3D EXT4_BLOCK_SIZE(inode->i_sb);
>  	unsigned int rlen =3D ext4_rec_len_from_disk(dirent->rec_len, blocksize=
);
> =20
> -	if (rlen =3D=3D blocksize)
> +	if (rlen =3D=3D blocksize) {
>  		count_offset =3D sizeof(struct dx_node);
> -	else if (rlen =3D=3D 12) {
> -		de =3D (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
> -		if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=3D blocksize - 12)
> +	} else {
> +		if (rlen < EXT4_BASE_DIR_LEN ||
> +		    rlen + EXT4_BASE_DIR_LEN > blocksize)
> +			return NULL;
> +		de =3D (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
> +		if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=3D
> +		    (unsigned int)(blocksize - rlen))
>  			return NULL;
> -		root =3D (struct dx_root_info *)(((void *)de + 12));
> +		/* de->rec_len covers whole dx_root block, calculate actual length.
> +		 * This is the '..' entry, which never carries the casefold+fscrypt
> +		 * hash, so pass NULL for dir regardless of the directory's flags */
> +		dotdot_rec_len =3D ext4_dir_entry_len(de, blocksize, NULL);
> +		if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) > blocksize)
> +			return NULL;
> +		root =3D (struct dx_root_info *)(((char *)de + dotdot_rec_len));
>  		if (root->reserved_zero ||
>  		    root->info_length !=3D sizeof(struct dx_root_info))
>  			return NULL;
> -		count_offset =3D 32;
> -	} else
> -		return NULL;
> +		count_offset =3D root->info_length + rlen + dotdot_rec_len;
> +	}
> =20
>  	if (offset)
>  		*offset =3D count_offset;

[Severity: High]
Does get_dx_countlimit() allow a 4-byte out-of-bounds read past the end of
bh->b_data in ext4_dx_csum_verify() and ext4_dx_csum_set()?

The bounds check in get_dx_countlimit() checks:

    if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) > blocksize)
        return NULL;

without accounting for sizeof(struct dx_countlimit) (unlike dx_get_dx_info(=
),
which includes sizeof(struct dx_entry) in its upper-bound check).

On a corrupted or crafted image where rlen + dotdot_rec_len +
sizeof(struct dx_root_info) =3D=3D blocksize, get_dx_countlimit() sets
count_offset =3D blocksize and returns (struct dx_countlimit *)(((void *)di=
rent)
+ blocksize), which points directly past the end of the directory block
buffer.

Both ext4_dx_csum_verify() and ext4_dx_csum_set() immediately dereference
c->limit and c->count before validating count_offset against blocksize:

fs/ext4/namei.c:ext4_dx_csum_verify() {
    c =3D get_dx_countlimit(inode, dirent, &count_offset);
    if (!c) {
        EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck -D.");
        return 0;
    }
    limit =3D le16_to_cpu(c->limit);
    count =3D le16_to_cpu(c->count);
    if (count_offset + (limit * sizeof(struct dx_entry)) >
        EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct ext4_dir_entry_tail))
        ...
}

Should the check in get_dx_countlimit() include sizeof(struct dx_countlimit)
so that the returned struct dx_countlimit pointer is guaranteed to lie with=
in
the block?

[ ... ]

> @@ -1252,6 +1264,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u=
32 start_hash,
>  		tmp_str.name =3D de->name;
>  		tmp_str.len =3D de->name_len;
>  		err =3D ext4_htree_store_dirent(dir_file, 0, 0,
> +					      dir->i_sb->s_blocksize,
>  					      de, &tmp_str);
>  		if (err !=3D 0)
>  			goto errout;
> @@ -1263,6 +1276,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u=
32 start_hash,
>  		tmp_str.name =3D de->name;
>  		tmp_str.len =3D de->name_len;
>  		err =3D ext4_htree_store_dirent(dir_file, 2, 0,
> +					      dir->i_sb->s_blocksize,
>  					      de, &tmp_str);
>  		if (err !=3D 0)
>  			goto errout;

[Severity: High]
Could ext4_htree_fill_tree() and ext4_htree_store_dirent() read past the end
of frames[0].bh->b_data when storing the "." and ".." entries from an htree
root block?

In dx_probe() -> dx_get_dx_info(), the code steps from "." to ".." using
ext4_dir_entry_len():

fs/ext4/namei.c:dx_get_dx_info() {
    if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
                   blocksize) < EXT4_BASE_DIR_LEN)
        return ERR_PTR(-EFSCORRUPTED);
    de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);
}

By contrast, get_dx_countlimit() and ext4_htree_fill_tree() advance from "."
to ".." using dot_de->rec_len (via ext4_next_entry(de, dir->i_sb->s_blocksi=
ze))
without verifying that dot_de->rec_len matches ext4_dir_entry_len(dot_de,
blocksize, NULL).

Even with the additional rlen checks added in the later commit ("ext4: Add
EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries"),
dx_get_dx_info() permits rlen <=3D blocksize on "." and validates the ".." =
entry
and dx_root_info at offset ext4_dir_entry_len(dot_de) (for example, offset =
12)
rather than at offset rlen.

As a result, on a crafted image where dot_de has ext4_dir_entry_len(dot_de)=
 =3D=3D
12 (with valid ".." and dx_root_info at offsets 12 and 24) but dot_de->rec_=
len
decodes to rlen =3D=3D blocksize (or blocksize - 4), dx_probe() succeeds and
ext4_htree_fill_tree() then advances de =3D ext4_next_entry(de, s_blocksize=
) to
frames[0].bh->b_data + rlen, reading de->name_len, de->inode, de->file_type,
and de->rec_len out of bounds.

Similarly, if dot_de->rec_len decodes to an offset near the end of the block
(such as 4000), ext4_htree_fill_tree() passes "." and ".." to
ext4_htree_store_dirent() without calling ext4_check_dir_entry(). In
ext4_htree_store_dirent(), rec_len =3D ext4_rec_len_from_disk(dirent->rec_l=
en,
buf_size) is passed directly to ext4_dirent_get_data_len(dirent, rec_len)
without checking that (char *)dirent + rec_len or dirent->name +
dirent->name_len fits within frames[0].bh->b_data + s_blocksize, allowing
memcpy() and unsafe_memcpy() to read past the end of the block buffer.

[ ... ]

> @@ -2118,13 +2136,10 @@ int ext4_find_dest_de(struct inode *dir, struct b=
uffer_head *bh,
>  	return 0;
>  }
> =20
> -void ext4_insert_dentry(struct inode *dir,
> -			struct inode *inode,
> -			struct ext4_dir_entry_2 *de,
> -			int buf_size,
> -			struct ext4_filename *fname)
> +void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
> +			     struct ext4_dir_entry_2 *de, int buf_size,
> +			     struct ext4_filename *fname, void *data)
>  {
> -
>  	int nlen, rlen;
> =20
>  	nlen =3D ext4_dir_entry_len(de, buf_size, dir);
> @@ -2141,6 +2156,10 @@ void ext4_insert_dentry(struct inode *dir,
>  	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
>  	de->name_len =3D fname_len(fname);
>  	memcpy(de->name, fname_name(fname), fname_len(fname));
> +	/* 'data' (the LUFID payload) and the CFHASH are written by
> +	 * ext4_dirdata_set(), which is introduced in the next patch that adds
> +	 * the dirdata set/get helpers.  Until then, only the casefold hash is
> +	 * stored at the legacy fixed offset for encrypted+casefolded dirs. */
>  	if (ext4_hash_in_dirent(dir)) {
>  		struct dx_hash_info *hinfo =3D &fname->hinfo;
> =20

[Severity: Critical]
Does enabling EXT4_FEATURE_INCOMPAT_DIRDATA in EXT4_FEATURE_INCOMPAT_SUPP
while ext4_dirent_rec_len() omits sizeof(struct ext4_dir_entry_hash) cause
hash corruption and 8-byte out-of-bounds reads in encrypted, casefolded
directories when EXT4_DIRENT_CFHASH is not set on an entry?

In fs/ext4/ext4.h, ext4_dirent_rec_len() only reserves
sizeof(struct ext4_dir_entry_hash) when dirdata is not enabled on the
superblock:

fs/ext4/ext4.h:ext4_dirent_rec_len() {
    if (dir && ext4_hash_in_dirent(dir) &&
        !ext4_has_feature_dirdata(dir->i_sb))
        rec_len +=3D sizeof(struct ext4_dir_entry_hash);
    return (rec_len & ~EXT4_DIR_ROUND);
}

This commit adds EXT4_FEATURE_INCOMPAT_DIRDATA to EXT4_FEATURE_INCOMPAT_SUP=
P,
making ext4_has_feature_dirdata(dir->i_sb) true on mounted dirdata
filesystems.

At this commit, ext4_insert_dentry_data() still writes the casefold hash at
EXT4_DIRENT_HASHES(de) without setting EXT4_DIRENT_CFHASH in de->file_type.
Because ext4_dirent_get_data_len() returns 0 and ext4_dirent_rec_len() omits
sizeof(struct ext4_dir_entry_hash), ext4_dir_entry_len(de, buf_size, dir)
returns a length 8 bytes too small, and splitting the entry at nlen =3D
ext4_dir_entry_len() overwrites the 8-byte hash.

Even after the follow-up commit ("ext4: add dirdata set/get helpers") adds
ext4_dirdata_set() and ext4_dirdata_get(), all hash readers
(ext4_inlinedir_to_tree(), ext4_search_dir() -> ext4_match(), ext4_readdir(=
),
htree_dirblock_to_tree(), and dx_make_map()) fall back to reading
EXT4_DIRENT_HASH(de) and EXT4_DIRENT_MINOR_HASH(de) at the legacy fixed off=
set
whenever EXT4_DIRENT_CFHASH is not set in de->file_type (or when
ext4_dirdata_get() returns an error).

However, __ext4_check_dir_entry() and ext4_search_dir() validate entry boun=
ds
using ext4_dir_entry_len() and ext4_dirent_rec_len():

fs/ext4/dir.c:__ext4_check_dir_entry() {
    else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir=
)))
        error_msg =3D "rec_len is too small for name_len";
}

fs/ext4/namei.c:ext4_search_dir() {
    if (de->name + de->name_len <=3D dlimit &&
        (!ext4_hash_in_dirent(dir) ||
         (char *)de + ext4_dirent_rec_len(de->name_len, dir) <=3D dlimit) &&
        ext4_match(dir, fname, de)) {
}

When ext4_has_feature_dirdata(dir->i_sb) is true and an entry in an
encrypted, casefolded directory does not have a valid EXT4_DIRENT_CFHASH
extension (for example, an un-migrated entry or a crafted entry with rec_le=
n =3D
12 and name_len =3D 4 at the end of dir_buf in ext4_inlinedir_to_tree() or =
at
dlimit - 12 in ext4_search_dir()), bounds validation passes without requiri=
ng
the 8-byte hash, and the fallback to EXT4_DIRENT_HASHES(de) reads 8 bytes p=
ast
the end of the kmalloc(inline_size) buffer or directory block buffer.
Likewise, ext4_dir_entry_len() omits the 8-byte legacy hash for un-migrated
entries lacking EXT4_DIRENT_CFHASH, causing ext4_insert_dentry_data(),
dx_move_dirents(), and dx_pack_dirents() to overwrite their hashes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D8
