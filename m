Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119A8C10F01
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 07:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48B921773
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 07:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550649249;
	bh=tLOAeQqo8uWF4VkUGKhfz71PVfoAaoBcFMjA2Hj/aW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sC2Ok0Vd/SyZ2bHsaswOK1GOs+zCVNd/pm6RpO2ovSRhk7gaE7NECKm7qKSzGTUU6
	 QUteIINJztXf+T8plbe+hwt81vQTyTMG/pK9HwDhvyE4uJZYLvwtkOUjkzCOLA8W7J
	 gtt16wGs3ORLSeWEOguhzfd/N7ls5NdRLT9IrNYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfBTHyI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:54:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfBTHyI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 02:54:08 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 440E12083B;
        Wed, 20 Feb 2019 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550649247;
        bh=tLOAeQqo8uWF4VkUGKhfz71PVfoAaoBcFMjA2Hj/aW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKU7DBXp0Hq4FeA1WZfTzMFWadwa1LkoRF0dY1fWJnZzqaXsWKu0MxvnvLR4xhY/x
         N4GzMOv6bJBGyoKjWblU/NQBBWCJVWZ3EjomIutqG/+Cp/IswqT1iNP09jb+GiEy1z
         Px/6RiDKz01hM58Rv3p9YP2CEnzugDFeckUdhp8Q=
Date:   Tue, 19 Feb 2019 23:54:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 00/18] fscrypt: key management improvements
Message-ID: <20190220075404.GA974@sol.localdomain>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <1660609D-3525-4485-9652-57976DB020F4@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660609D-3525-4485-9652-57976DB020F4@dilger.ca>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 11:18:21PM -0800, Andreas Dilger wrote:
> On Feb 19, 2019, at 10:52 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > Hello,
> > 
> > This patchset makes major improvements to how keys are added, removed,
> > and derived in fscrypt, aka ext4/f2fs/ubifs encryption.  It does this by
> > adding new ioctls that add and remove encryption keys directly to/from
> > the filesystem, and by adding a new encryption policy version ("v2")
> > where the user-provided keys are only used as input to HKDF-SHA512 and
> > are identified by their cryptographic hash.
> 
> Just to confirm for the layman reader - the fact that the crypto keys
> are registered with the filesystem and not with the user process doesn't
> prevent user(s) from having different crypto keys for different subdirs
> in a single filesystem?

Correct, that hasn't changed.  Different directories can use different keys.

> 
> Secondly, does this progress fscrypt toward allowing multiple master keys
> to decrypt a single per-file key?
> 

It's not a goal of this patchset as no one has really been asking for it yet.
Per-file keys are still derived from the master key.

Note that it's already possible to wrap the master keys in userspace.  Thus you
can already have multiple passwords that unlock the same encrypted directory.
You just can't do this with *individual files*.  Maybe that's good enough.

However, this patchset does fix the denial of service vulnerabilities that
currently exist when users share an encrypted directory.  Also, since it adds a
real KDF, it makes it much easier to derive a wrapping key to wrap the per-file
keys if that were to become a requirement.  (The master key could be used as the
wrapping key directly, but that's inflexible and more error-prone.)

- Eric
