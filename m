Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66717C433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 19 May 2022 03:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiESDnw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 18 May 2022 23:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiESDnv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2022 23:43:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C0A6E8D6
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2022 20:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA079B80DFD
        for <linux-ext4@vger.kernel.org>; Thu, 19 May 2022 03:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6C0C385B8;
        Thu, 19 May 2022 03:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652931827;
        bh=6Iu/4CtpYTZNyk/uv3M2H9o1IfB0D2LmMQjOXVY7ChQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aYXiPZQkJgvh6ExTh17nBbK9NL7gHRPYRxIVGfqDRdqBuBLuedm0Z85PqEDngbPik
         LOebjGrM7aFraoERtOaD8pWe2hcJ/eMaXrZUCG4YmR9yPfTzry00yFW0NAbvsHfOwq
         Evx8/WIqCada6Y3u3rMUYgCLNHLZwTjAUV0797HvjAQp7j863hBQ2O7bUzNRZ/3GjJ
         ltUlg/cXrLkvZeBgNkOLa7cqa2+uAG2N4+Oping5tnkACTfPVBOKZgz9BzqzMPihLw
         odeKcIiIVgZAQz8SqwQS8TDTVCI3eezgZ/zow5VlUiYFXhtE4+LPR7W+xpVgLhWlka
         +vVcIDM72ac/w==
Date:   Wed, 18 May 2022 20:43:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        kernel@collabora.com
Subject: Re: [PATCH v6 5/8] f2fs: Reuse generic_ci_match for ci comparisons
Message-ID: <YoW88YCdwmUi9wTt@sol.localdomain>
References: <20220519014044.508099-1-krisman@collabora.com>
 <20220519014044.508099-6-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519014044.508099-6-krisman@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, May 18, 2022 at 09:40:41PM -0400, Gabriel Krisman Bertazi wrote:
> Now that ci_match is part of libfs, make f2fs reuse it instead of having
> a different implementation.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> 
> ---
> Changes since v3:
>   - Drop cast (eric)
>   - fix unused variable iff !CONFIG_UNICODE (lkp)
> ---
>  fs/f2fs/dir.c | 58 ++++-----------------------------------------------
>  1 file changed, 4 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 167a04074a2e..4e4b2b190188 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -217,58 +217,6 @@ static struct f2fs_dir_entry *find_in_block(struct inode *dir,
>  	return f2fs_find_target_dentry(&d, fname, max_slots);
>  }
>  
> -#if IS_ENABLED(CONFIG_UNICODE)
> -/*
> - * Test whether a case-insensitive directory entry matches the filename
> - * being searched for.
> - *
> - * Returns 1 for a match, 0 for no match, and -errno on an error.
> - */
> -static int f2fs_match_ci_name(const struct inode *dir, const struct qstr *name,
> -			       const u8 *de_name, u32 de_name_len)
> -{
> -	const struct super_block *sb = dir->i_sb;
> -	const struct unicode_map *um = sb->s_encoding;
> -	struct fscrypt_str decrypted_name = FSTR_INIT(NULL, de_name_len);
> -	struct qstr entry = QSTR_INIT(de_name, de_name_len);
> -	int res;
> -
> -	if (IS_ENCRYPTED(dir)) {
> -		const struct fscrypt_str encrypted_name =
> -			FSTR_INIT((u8 *)de_name, de_name_len);
> -
> -		if (WARN_ON_ONCE(!fscrypt_has_encryption_key(dir)))
> -			return -EINVAL;
> -
> -		decrypted_name.name = kmalloc(de_name_len, GFP_KERNEL);
> -		if (!decrypted_name.name)
> -			return -ENOMEM;
> -		res = fscrypt_fname_disk_to_usr(dir, 0, 0, &encrypted_name,
> -						&decrypted_name);
> -		if (res < 0)
> -			goto out;
> -		entry.name = decrypted_name.name;
> -		entry.len = decrypted_name.len;
> -	}
> -
> -	res = utf8_strncasecmp_folded(um, name, &entry);
> -	/*
> -	 * In strict mode, ignore invalid names.  In non-strict mode,
> -	 * fall back to treating them as opaque byte sequences.
> -	 */
> -	if (res < 0 && !sb_has_strict_encoding(sb)) {
> -		res = name->len == entry.len &&
> -				memcmp(name->name, entry.name, name->len) == 0;
> -	} else {
> -		/* utf8_strncasecmp_folded returns 0 on match */
> -		res = (res == 0);
> -	}
> -out:
> -	kfree(decrypted_name.name);
> -	return res;
> -}
> -#endif /* CONFIG_UNICODE */
> -
>  static inline int f2fs_match_name(const struct inode *dir,
>  				   const struct f2fs_filename *fname,
>  				   const u8 *de_name, u32 de_name_len)
> @@ -277,8 +225,10 @@ static inline int f2fs_match_name(const struct inode *dir,
>  
>  #if IS_ENABLED(CONFIG_UNICODE)
>  	if (fname->cf_name.name)
> -		return f2fs_match_ci_name(dir, &fname->cf_name,
> -					  de_name, de_name_len);
> +		return generic_ci_match(dir, fname->usr_fname,
> +					&fname->cf_name,
> +					de_name, de_name_len);
> +
>  #endif

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
