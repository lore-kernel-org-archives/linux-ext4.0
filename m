Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B27C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 05:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58E32086C
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 05:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550728184;
	bh=i2gB2WiF3pXqcwwpFZZxSn9+PuXQgQG4KD3gpU79voc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mq686GW1BhLE5b/4F7myURqULe7Gm/KpBaYe4QQmOam/aUCYbtF9weKhIAkJ7OF0Q
	 LdGdEp23wDz+hJEBEjKIzCdCluzFpevwjnXluBRzE5zvWqRi2N1kUyLIcEukAF75oq
	 PQTNNTBYl9KvsyV29LgGLcTHpsiWV8G9inAgGB8c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfBUFtm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbfBUFtm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Feb 2019 00:49:42 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E22692084F;
        Thu, 21 Feb 2019 05:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550728181;
        bh=i2gB2WiF3pXqcwwpFZZxSn9+PuXQgQG4KD3gpU79voc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MaQLabSmwIvE9NyktnSQZfB8cleojLpn5vsGGgBOtuYuBc2aWPKfr8i59/5FmfxyM
         QksNlTgmtEBvLgDNvxTrI8wgupS8SKQzdpEfNmZwANw/6VP027PaWg3CRFdERMfvXg
         7UF0rzCP2zX1hUQv5qBHqMW8aADuCXMTJkZBq8Po=
Date:   Wed, 20 Feb 2019 21:49:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard.weinberger@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Message-ID: <20190221054938.GA12467@sol.localdomain>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <20190220065249.32099-8-ebiggers@kernel.org>
 <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Richard,

On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > +
> > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > +
> > +static void format_fs_keyring_description(
> > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > +                       const struct super_block *sb)
> > +{
> > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > +}
> 
> I fear ->s_id is not the right thing.
> For filesystems such as ext4 ->s_id is the name of the backing block device,
> so it is per filesysem instance unique.
> But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> So the names will clash.
> 
> -- 
> Thanks,
> //richard

What name do you suggest using for UBIFS filesystems?  The keyring name could be
set by the filesystem via a fscrypt_operations callback if needed.

Note that the keyring name isn't particularly important, since the ioctls will
work regardless.  But we might as well choose something logical, since the
keyring name will still show up in /proc/keys.

- Eric
