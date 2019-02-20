Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE8EC4360F
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DBA21841
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfV443U0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfBTXUK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:20:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35436 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBTXUK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2019 18:20:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id y15so8125227wma.0;
        Wed, 20 Feb 2019 15:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Ins5SyXMErLIBGwpAEI4+DBCUKf26tDWyMTuCKUOUc=;
        b=NfV443U0Jcnfy6bnrxZteDTcKePL/CRtH8s/kdhxdgg4urIsLioKO8RfpVs3buxjrL
         uqRH/GhD+8rvjqkGiLC45VUpcJ3JJ3b6AHSEDYP/1T8hrp+HXNOiQu0s0kBL0jzEW44g
         tfw+f9Zw/zXB0PgtqqAhkyf9Rmittt/Jf3oT7NS1ka/zCoc9ovcAYW5CduzuU1WEcgkM
         FwMCP7+p517q6ImLXhUnSUcPjc8eIFv5x1NJ5NAGzPBCJmc98bRwkw0laUu5QE2I9dIH
         puscTPDMWPZcgqfbsTrNf8G+Y7zU3ZrbZXPkCMcM0LJVJn3ijgd7A5UlQZYFKHWR9vG9
         NtAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Ins5SyXMErLIBGwpAEI4+DBCUKf26tDWyMTuCKUOUc=;
        b=KuEtSwedK2aJI9L58ctcCw1Gqe9xun2eidfJIUgK+K7akX4Odp2HDy9RxZwtabxy0Q
         PH4KO3ibmFYjP4/jm0oNAuz4IYLjTgr7S1e+wQIFoe7Kil3isYcSaTFhmxPXFYhKltIu
         jn51X/UbusN5uSytSLlrqBck4RCJ8ZPGrrAs8UM6sLlBdqyDIqSnrXb7dpBWN8loqE/f
         hcEPypnkX3aK0g9wMWiI4pteV7/q//kv6GdGYk7+sbCFigLX99R7PQ6sG27yKGAnPz3a
         ieaeC/tsAsCZXDEB2ESGPSYagt1lBv/2f38LsJwru/bvMLvaCeNJm8GxTwTmBLGBE0kH
         eUww==
X-Gm-Message-State: AHQUAua70JCchPsw+YS45WOLpNbufh7Xd27cCCJWeYHW5A2bSBx4cGkS
        7ydMs6THTBnZ9xk8xe+neLnm5S871jRCszYvREkp/g==
X-Google-Smtp-Source: AHgI3Iam+0XE6fSvTXehqi+p9lvz9Zn5TXYAUy2xKlS2Wf6cWRWWndzfq69Q09+NpDaZfma0KI14mqqq8AZCbYgookg=
X-Received: by 2002:a1c:1fc8:: with SMTP id f191mr3491639wmf.110.1550704806748;
 Wed, 20 Feb 2019 15:20:06 -0800 (PST)
MIME-Version: 1.0
References: <20190220065249.32099-1-ebiggers@kernel.org> <20190220065249.32099-5-ebiggers@kernel.org>
In-Reply-To: <20190220065249.32099-5-ebiggers@kernel.org>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 21 Feb 2019 00:19:54 +0100
Message-ID: <CAFLxGvxLYL1raaXZPyyMS7CUUak3L6GncZ_GKYz2SSsGHEHpnQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/18] fs: add ->s_master_keys to struct super_block
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add an ->s_master_keys keyring to 'struct super_block'.  New fscrypt
> ioctls will allow adding and removing encryption keys from this keyring.
> This will enable solving multiple interrelated problems with how fscrypt
> keys are provided and managed currently, including:
>
> - Making the key status (which is currently per-process) match the
>   filesystem-level status of which encrypted files are "unlocked".
>
> - Supporting a proper API to remove encryption keys, "locking" the
>   corresponding encrypted files.
>
> - Caching an HMAC transform for each master key, allowing the use of
>   HKDF while still retaining good performance.
>
> - Preventing denial of service via keyctl_invalidate().
>
> Similar to the existing ->s_cop, the keyring is added to the VFS-level
> superblock struct rather than separately to the ext4, f2fs, and ubifs
> superblock structs so that it can be used by the shared code in
> fs/crypto/.  To minimize overhead, the keyring will only be allocated if
> userspace actually adds a key; otherwise will stay NULL.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/super.c         | 3 +++
>  include/linux/fs.h | 1 +
>  2 files changed, 4 insertions(+)
>
> diff --git a/fs/super.c b/fs/super.c
> index 48e25eba8465..7ca05dda905c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -291,6 +291,9 @@ static void __put_super(struct super_block *s)
>                 security_sb_free(s);
>                 put_user_ns(s->s_user_ns);
>                 kfree(s->s_subtype);
> +#ifdef CONFIG_FS_ENCRYPTION
> +               key_put(s->s_master_keys);
> +#endif

Please wrap this in a static inline function such that you can get rid
of the ifdef here.
Just like put_user_ns() does.

-- 
Thanks,
//richard
