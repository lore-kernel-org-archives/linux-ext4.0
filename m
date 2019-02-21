Return-Path: <SRS0=OaGm=Q4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D69C4360F
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 09:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F204721734
	for <linux-ext4@archiver.kernel.org>; Thu, 21 Feb 2019 09:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfBUJdR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Feb 2019 04:33:17 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:36892 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfBUJdR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Feb 2019 04:33:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5E19D6083265;
        Thu, 21 Feb 2019 10:33:14 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dbO284T6jKnl; Thu, 21 Feb 2019 10:33:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id DD3AC6083268;
        Thu, 21 Feb 2019 10:33:13 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id izVKilIaD7-H; Thu, 21 Feb 2019 10:33:13 +0100 (CET)
Received: from blindfold.localnet (unknown [82.150.214.1])
        by lithops.sigma-star.at (Postfix) with ESMTPSA id 4BB0F6083265;
        Thu, 21 Feb 2019 10:33:13 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date:   Thu, 21 Feb 2019 10:33:12 +0100
Message-ID: <2024630.T9XyBPH5Ub@blindfold>
In-Reply-To: <20190221054938.GA12467@sol.localdomain>
References: <20190220065249.32099-1-ebiggers@kernel.org> <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com> <20190221054938.GA12467@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Eric,

Am Donnerstag, 21. Februar 2019, 06:49:39 CET schrieb Eric Biggers:
> Hi Richard,
> 
> On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> > On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > > +
> > > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > > +
> > > +static void format_fs_keyring_description(
> > > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > > +                       const struct super_block *sb)
> > > +{
> > > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > > +}
> > 
> > I fear ->s_id is not the right thing.
> > For filesystems such as ext4 ->s_id is the name of the backing block device,
> > so it is per filesysem instance unique.
> > But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> > So the names will clash.
> > 
> 
> What name do you suggest using for UBIFS filesystems?  The keyring name could be
> set by the filesystem via a fscrypt_operations callback if needed.

IMHO the BDI name should be used. 

> Note that the keyring name isn't particularly important, since the ioctls will
> work regardless.  But we might as well choose something logical, since the
> keyring name will still show up in /proc/keys.

I'm not done with reviewing your patches, but will it be possible to use keyctl?
For the a unique name is helpful. :)

Thanks,
//richard


