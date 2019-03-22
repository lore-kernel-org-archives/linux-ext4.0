Return-Path: <SRS0=JWMb=RZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655DAC43381
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 22:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A442190A
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Mar 2019 22:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfCVWCz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 22 Mar 2019 18:02:55 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:35062 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbfCVWCz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2019 18:02:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 22AD4608A395;
        Fri, 22 Mar 2019 23:02:52 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id bxgElapSClzg; Fri, 22 Mar 2019 23:02:51 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B507760F6D61;
        Fri, 22 Mar 2019 23:02:51 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SkcTucd3wTxy; Fri, 22 Mar 2019 23:02:51 +0100 (CET)
Received: from blindfold.localnet (213-47-184-186.cable.dynamic.surfer.at [213.47.184.186])
        by lithops.sigma-star.at (Postfix) with ESMTPSA id 1D02D608A395;
        Fri, 22 Mar 2019 23:02:51 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date:   Fri, 22 Mar 2019 23:02:49 +0100
Message-ID: <4190811.5ckf3pJJgb@blindfold>
In-Reply-To: <20190318230830.GA40545@gmail.com>
References: <20190220065249.32099-1-ebiggers@kernel.org> <20190221184203.GB140206@gmail.com> <20190318230830.GA40545@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Ericm

Am Dienstag, 19. März 2019, 00:08:31 CET schrieb Eric Biggers:
> I tried using sb->s_bdi->name, but it's still "ubifs" for all UBIFS filesystems.

hmpf.
 
> Perhaps there's a way you can make ->s_id for UBIFS unique?  There are already
> existing places that log ->s_id, so perhaps you should do it anyway regardless
> of this patchset?

Yes, let me implement that.
ubifs does:
super_setup_bdi_name(sb, "ubifs_%d_%d", c->vi.ubi_num, c->vi.vol_id);

So, I try to set ->s_id also to ubifs_%d_%d.

> > > 
> > > > Note that the keyring name isn't particularly important, since the ioctls will
> > > > work regardless.  But we might as well choose something logical, since the
> > > > keyring name will still show up in /proc/keys.
> > > 
> > > I'm not done with reviewing your patches, but will it be possible to use keyctl?
> > > For the a unique name is helpful. :)
> > > 
> > 
> > Not for adding keys, removing keys, or getting a key's status -- those are what
> > the ioctls are for.
> > 
> > See e.g. the discussion in patch 7 ("fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY
> > ioctl") for why the keyrings syscalls are a poor fit for fscrypt.
> > 
> 
> Anyway, perhaps I should reconsider whether fscrypt should even use the keyrings
> subsystem at all, even just "internally", as its quirks still leak out a bit.
> I'd prefer a nice clean API without any quirks like having to name the keyrings
> and assign SELinux labels to the keys just to make the keyrings subsystem happy.

IMHO the keys subsytem is a good fit. For example for stuff like this one:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1945778.html

We use UBIFS on many embedded systems with crypto hardware.

Thanks,
//richard


