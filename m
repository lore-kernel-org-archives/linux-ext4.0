Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB86C4360F
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 17:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D13621929
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554138686;
	bh=bVz8EWNOD7U2ZdTxmnpm0giLJvx5jIQYLqWiOb4vouY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bD8Ah251/Riy7Q5104BdvM8hv82Nwbau2HhVAyyeaL872K64T2ZkE+K81/msbu14I
	 c3Y217sxmADIwwKWnnxpFdtpSs1d/5aroCw33dAxDZP5spy/1IWDBB5xkVS5wx+ROW
	 9Zr8D1dmUcp7nlTXrScJog89LmNT5Crw1XbGH+P4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfDARLZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 13:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbfDARLY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 1 Apr 2019 13:11:24 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78B26206B8;
        Mon,  1 Apr 2019 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554138682;
        bh=bVz8EWNOD7U2ZdTxmnpm0giLJvx5jIQYLqWiOb4vouY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vm02uAjrn53nwk9HjpcmQ9hyhfts8IMLGNZbObqcdg5m/f6dUA30E5mJiysVdASwX
         syloEVqNRPd86BXToQN9xgIu7SEavlW2J1b2eUNZGEzVY2f4YgRWeP0skJyTrwQ6aX
         sigUn90POxEA/f/X0Beg8yDzU7w0OUi0F7JRUUig=
Date:   Mon, 1 Apr 2019 10:11:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 0/5] fscrypt: d_revalidate fixes and cleanups
Message-ID: <20190401171119.GC131675@gmail.com>
References: <20190320183913.12686-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:08AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This patch series improves dentry revalidation in fscrypt.
> 
> To recap, fscrypt (aka ext4/f2fs/ubifs encryption) encrypts both file
> contents and file names in individual directory trees.  A single
> filesystem can contain many encrypted directory trees using many
> different encryption keys.  Major users of fscrypt require the ability
> to delete encrypted files when their encryption key is unavailable, e.g.
> when the system needs to delete a removed user's home directory or free
> up space from a logged-out user's cache directory.
> 
> Therefore fscrypt allows listing, looking up, and deleting files in
> encrypted directories via encoded ciphertext names, but only before the
> key is added.  After the key is added, the ciphertext names are
> invalidated via ->d_revalidate() and plaintext names are shown instead.
> 
> fscrypt isn't a stacked filesystem, and it's explicitly for storage
> encryption, not OS-level access control.  Thus, whether each directory
> inode has its key or not is a global state, not per-process.  Also, the
> inode keeps its key until it's evicted from the inode cache.  So,
> plaintext names shouldn't ever get invalidated by ->d_revalidate().
> 
> This patch series makes the following improvements:
> 
> - Only assign ->d_revalidate() to ciphertext filenames, thus allowing
>   overlayfs to use an fscrypt-encrypted upperdir in some cases.
>   (Previous discussion: https://lkml.org/lkml/2019/3/13/255)
> 
> - Fix cases where plaintext filenames would wrongly be invalidated,
>   including a real-world bug recently reported on Chromium OS.
> 
> - Fix cases where ciphertext filenames would wrongly not be invalidated.
> 
> - Allow rcu-walk lookups in encrypted directories with the key, which
>   improves performance.
>   (Previous attempt: https://patchwork.kernel.org/patch/10594133/)
> 
> - Fix cases where rename() and link() could succeed on ciphertext names.
> 
> Changed since v1:
> 
> - Fixed comment in fscrypt_d_revalidate() to explain that dget_parent()
>   is actually still required.
> 
> - Moved clearing DCACHE_ENCRYPTED_NAME into fscrypt.h, to avoid an extra
>   #ifdef and cluttering up dcache.c.
> 
> Eric Biggers (5):
>   fscrypt: clean up and improve dentry revalidation
>   fscrypt: fix race allowing rename() and link() of ciphertext dentries
>   fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
>   fscrypt: only set dentry_operations on ciphertext dentries
>   fscrypt: fix race where ->lookup() marks plaintext dentry as
>     ciphertext
> 
>  fs/crypto/crypto.c      | 58 ++++++++++++++++---------------
>  fs/crypto/fname.c       |  1 +
>  fs/crypto/hooks.c       | 28 ++++++++++-----
>  fs/dcache.c             |  2 ++
>  fs/ext4/ext4.h          | 62 +++++++++++++++++++++++++--------
>  fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++-------------
>  fs/f2fs/namei.c         | 17 +++++----
>  fs/ubifs/dir.c          |  8 ++---
>  include/linux/dcache.h  |  2 +-
>  include/linux/fscrypt.h | 61 +++++++++++++++++++++++----------
>  10 files changed, 208 insertions(+), 107 deletions(-)
> 
> -- 
> 2.21.0.225.g810b269d1ac-goog
> 

Any more comments on these patches?  I'd like to apply them to the fscrypt tree
for 5.2.  Richard, can you check whether these solve your overlayfs use case?
Also, patch 5 could use Acks from ext4, f2fs, and ubifs people.

- Eric
