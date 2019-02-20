Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1788C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC7A20859
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 23:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+WemA1p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfBTXwx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:52:53 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38080 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTXww (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Feb 2019 18:52:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so27966668wrw.5;
        Wed, 20 Feb 2019 15:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bXn1MSg7nGUrGBUXSV79vPQ0bHNvPC/jWxEr1whYJIs=;
        b=O+WemA1p/1S4wt+Bl/K+tRjwAaenEexY0TidU+ZySmuVEuWJ7Ug/g6CTWhZvcD/UHf
         1dRQmnPQu8M+Uaymmi6dRQdsr8/Dm9qr7Uky31tP7dm2xMDrYPHkxTam/WksamB/SH5M
         HpLBRWozs8cq1wKmRFwdIamzN9bucI7lxc0Y3HHrfrG2jjZbBBl6cfzO1Hwd6Ymu7P6B
         kEms4BiioT0GJHc+2z0ZhHxcw1mryWujl6MkUhvg5wJFZaPY+O256jxsse1Qqtuyq4Lg
         yBZWzCJuSS26NM18me+nv1Fzw88tjdJYHpGJq+Oellj92UDoxdaffvAHCvbAbDQnDrfM
         FC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bXn1MSg7nGUrGBUXSV79vPQ0bHNvPC/jWxEr1whYJIs=;
        b=mVZ5dDVrMZ8P9g/LyjzKmuaGtEHdSGGdZgduhBVy/4nz2o6U/Gqq8HoOaA6t+g60Kz
         DV4H6SAOS/cycghTrae/SCdZwOteYj6soFo2PXwX+oVpjhK6xsXrlITV0lDqy0rzAm3q
         C/0VOODh9gN/JJWIqZSob6o8jqLPoRf7wI0CAXVfHpEB4w4cu4e2HMg4v2IQ1dI7SD38
         qOmo3uQZ6grF8KNcpxsSDT24tZNf1xWE6BySyqTpzBkZMrEj38C7cC1rZ5bUx41gIHco
         OZyULXLBGeJurwXWuo3eeZw+Um6MR5uhF9u0TkyOB6AtkoQwzDrFxTmfHyGm/xqUcF3n
         p99w==
X-Gm-Message-State: AHQUAuZu7ylty3ro+kj69pa9UTcD9Yvd5acXXkh69ly08s6krqKpIqv0
        zJwShynaBAHvr301YBk9IaRVK5j9JiUMFLU8Y3q4QA==
X-Google-Smtp-Source: AHgI3IbReHJ6iG0+/2cT3ZekujlLxbX9fjFlHwEFbbEk9mOhZMCLku8d86VZGQ19dSNqN+r4b6rFJmhSn03z+qZn6GI=
X-Received: by 2002:adf:b646:: with SMTP id i6mr27184136wre.262.1550706770166;
 Wed, 20 Feb 2019 15:52:50 -0800 (PST)
MIME-Version: 1.0
References: <20190220065249.32099-1-ebiggers@kernel.org> <20190220065249.32099-8-ebiggers@kernel.org>
In-Reply-To: <20190220065249.32099-8-ebiggers@kernel.org>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 21 Feb 2019 00:52:38 +0100
Message-ID: <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> +
> +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> +
> +static void format_fs_keyring_description(
> +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> +                       const struct super_block *sb)
> +{
> +       sprintf(description, "fscrypt-%s", sb->s_id);
> +}

I fear ->s_id is not the right thing.
For filesystems such as ext4 ->s_id is the name of the backing block device,
so it is per filesysem instance unique.
But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
So the names will clash.

-- 
Thanks,
//richard
