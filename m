From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v1 5/10] ext4: Add DX_HASH_SIPHASH24 support
Date: Tue, 23 Sep 2014 21:12:10 +0200
Message-ID: <0765A511-D5E2-4F00-8F2F-F5A8E76C0B03@dilger.ca>
References: <20140923101612.930.qmail@ns.horizon.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:57214 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbaIWUV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Sep 2014 16:21:57 -0400
Received: by mail-we0-f173.google.com with SMTP id x48so3680503wes.32
        for <linux-ext4@vger.kernel.org>; Tue, 23 Sep 2014 13:21:55 -0700 (PDT)
In-Reply-To: <20140923101612.930.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 23, 2014, at 12:16, "George Spelvin" <linux@horizon.com> wrote:
> 
> This uses SipHash-2-4 for directory hashing.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> The actual feature.  Pretty simple, no?

Simple, except that it introduces a serious bug in the code. It duplicates
the previous on-disk encoding of:
  DX_HASH_LEGACY | DX_HASH_UNSIGNED_DELTA = 3

with:
  DX_HASH_SIPHASH24    3

and that will mean old filesystems would be considered corrupted. 

Due to the changes of your previous patch, it is not at all clear at the
definition of DX_HASH_* that the values 3, 4, 5 are already used.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cda8dd9c..13420bd4 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1737,6 +1737,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
> #define DX_HASH_LEGACY        0
> #define DX_HASH_HALF_MD4    1
> #define DX_HASH_TEA        2
> +#define DX_HASH_SIPHASH24    3

This should still explicitly #define the DX_HASH_LEGACY_UNSIGNED
values so that it is clear the values are already in use, otherwise we
expose ourselves to this bug repeatedly in the future. 

Cheers, Andreas
> /*
>  * For historical reasons, the first three hash algorithms
> @@ -1744,7 +1745,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
>  * use only, define some extra values outside the range of
>  * what's allowed on disk.
>  */
> -#define DX_HASH_UNSIGNED_DELTA    3
> +#define DX_HASH_UNSIGNED_DELTA    4
> 
> #define DX_HASH_LEGACY_UNSIGNED   (DX_HASH_LEGACY   + DX_HASH_UNSIGNED_DELTA)
> #define DX_HASH_HALF_MD4_UNSIGNED (DX_HASH_HALF_MD4 + DX_HASH_UNSIGNED_DELTA)
> diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> index 5186e09a..584639f4 100644
> --- a/fs/ext4/hash.c
> +++ b/fs/ext4/hash.c
> @@ -140,6 +140,7 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
> {
>    __u32    hash;
>    __u32    minor_hash = 0;
> +    __u64    hash64;
>    int    i;
>    __u32    in[8], buf[4];
>    void    (*str2hashbuf)(const char *, int, __u32 *, int) =
> @@ -192,6 +193,11 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
>        hash = buf[0];
>        minor_hash = buf[1];
>        break;
> +    case DX_HASH_SIPHASH24:
> +        hash64 = siphash24(name, len, hinfo->seed);
> +        hash = (__u32)hash64;
> +        minor_hash = hash64 >> 32;
> +        break;
>    default:
>        hinfo->hash = 0;
>        return -1;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 9e6eced1..922d6b48 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -685,7 +685,8 @@ dx_probe(const struct qstr *d_name, struct inode *dir,
>        goto fail;
>    }
>    root = (struct dx_root *) bh->b_data;
> -    if (root->info.hash_version != DX_HASH_TEA &&
> +    if (root->info.hash_version != DX_HASH_SIPHASH24 &&
> +        root->info.hash_version != DX_HASH_TEA &&
>        root->info.hash_version != DX_HASH_HALF_MD4 &&
>        root->info.hash_version != DX_HASH_LEGACY) {
>        ext4_warning(dir->i_sb, "Unrecognised inode hash code %d",
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
