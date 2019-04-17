Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB2CC282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8915520872
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbfDQOZF (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:25:05 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48590 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729356AbfDQOZF (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 10:25:05 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HEOawa011053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 10:24:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E7C39420497; Wed, 17 Apr 2019 10:24:35 -0400 (EDT)
Date:   Wed, 17 Apr 2019 10:24:35 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 5/5] fscrypt: fix race where ->lookup() marks
 plaintext dentry as ciphertext
Message-ID: <20190417142435.GE4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-6-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> ->lookup() in an encrypted directory begins as follows:
> 
> 1. fscrypt_prepare_lookup():
>     a. Try to load the directory's encryption key.
>     b. If the key is unavailable, mark the dentry as a ciphertext name
>        via d_flags.
> 2. fscrypt_setup_filename():
>     a. Try to load the directory's encryption key.
>     b. If the key is available, encrypt the name (treated as a plaintext
>        name) to get the on-disk name.  Otherwise decode the name
>        (treated as a ciphertext name) to get the on-disk name.
> 
> But if the key is concurrently added, it may be found at (2a) but not at
> (1a).  In this case, the dentry will be wrongly marked as a ciphertext
> name even though it was actually treated as plaintext.
> 
> This will cause the dentry to be wrongly invalidated on the next lookup,
> potentially causing problems.  For example, if the racy ->lookup() was
> part of sys_mount(), then the new mount will be detached when anything
> tries to access it.  This is despite the mountpoint having a plaintext
> path, which should remain valid now that the key was added.
> 
> Of course, this is only possible if there's a userspace race.  Still,
> the additional kernel-side race is confusing and unexpected.
> 
> Close the kernel-side race by changing fscrypt_prepare_lookup() to also
> set the on-disk filename (step 2b), consistent with the d_flags update.
> 
> Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
