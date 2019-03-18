Return-Path: <SRS0=HZ/b=RV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3D1C10F0D
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 23:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D9C22175B
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Mar 2019 23:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552950516;
	bh=yaB68QR3BXIzS0jW8UvCblXcYCpbjRQp3yuZ8DGGTpc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1HqFAl4W1Y4MBrORIT4KZt92cXB55CUoJWUvrikpV2k26tICQTetMLQJI+GYrxTQG
	 k6YHD5dNDLsF3T0neaecQzr8v5OFfBPN+yNJ4XWfvgoGZSYwV7hNUIP2T5AilfuKLg
	 PW3ZJD7YcjJ8GO07voADKSic44JmclPpgcT5qmL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfCRXIe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Mar 2019 19:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfCRXIe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Mar 2019 19:08:34 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 124CC2171F;
        Mon, 18 Mar 2019 23:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552950513;
        bh=yaB68QR3BXIzS0jW8UvCblXcYCpbjRQp3yuZ8DGGTpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fVuP1bwp4qmwXuBEvQMzUcBL0DEML8mQuvOZjDIbo/hmgqOFAq7vxSswNifRzfR0S
         va+BLDsDjL4v+yCLWDNFQ/b10o7IhvPcrbIucRrLwNQP/dq0vijSHsN/NhZzjuaJTy
         +X/Krnpq3t96XnzWfpFjU0mupEVoaHUvA3St6n9U=
Date:   Mon, 18 Mar 2019 16:08:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Message-ID: <20190318230830.GA40545@gmail.com>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
 <20190221054938.GA12467@sol.localdomain>
 <2024630.T9XyBPH5Ub@blindfold>
 <20190221184203.GB140206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221184203.GB140206@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Richard,

On Thu, Feb 21, 2019 at 10:42:03AM -0800, Eric Biggers wrote:
> On Thu, Feb 21, 2019 at 10:33:12AM +0100, Richard Weinberger wrote:
> > Eric,
> > 
> > Am Donnerstag, 21. Februar 2019, 06:49:39 CET schrieb Eric Biggers:
> > > Hi Richard,
> > > 
> > > On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> > > > On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > > > > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > > > > +
> > > > > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > > > > +
> > > > > +static void format_fs_keyring_description(
> > > > > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > > > > +                       const struct super_block *sb)
> > > > > +{
> > > > > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > > > > +}
> > > > 
> > > > I fear ->s_id is not the right thing.
> > > > For filesystems such as ext4 ->s_id is the name of the backing block device,
> > > > so it is per filesysem instance unique.
> > > > But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> > > > So the names will clash.
> > > > 
> > > 
> > > What name do you suggest using for UBIFS filesystems?  The keyring name could be
> > > set by the filesystem via a fscrypt_operations callback if needed.
> > 
> > IMHO the BDI name should be used. 

I tried using sb->s_bdi->name, but it's still "ubifs" for all UBIFS filesystems.

Perhaps there's a way you can make ->s_id for UBIFS unique?  There are already
existing places that log ->s_id, so perhaps you should do it anyway regardless
of this patchset?

> > 
> > > Note that the keyring name isn't particularly important, since the ioctls will
> > > work regardless.  But we might as well choose something logical, since the
> > > keyring name will still show up in /proc/keys.
> > 
> > I'm not done with reviewing your patches, but will it be possible to use keyctl?
> > For the a unique name is helpful. :)
> > 
> 
> Not for adding keys, removing keys, or getting a key's status -- those are what
> the ioctls are for.
> 
> See e.g. the discussion in patch 7 ("fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY
> ioctl") for why the keyrings syscalls are a poor fit for fscrypt.
> 

Anyway, perhaps I should reconsider whether fscrypt should even use the keyrings
subsystem at all, even just "internally", as its quirks still leak out a bit.
I'd prefer a nice clean API without any quirks like having to name the keyrings
and assign SELinux labels to the keys just to make the keyrings subsystem happy.

- Eric
