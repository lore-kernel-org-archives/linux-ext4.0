Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A42C282DD
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71463217F4
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732410AbfDQOHV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:07:21 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44458 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732288AbfDQOHV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 10:07:21 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HE72dN002538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 10:07:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 9F263420497; Wed, 17 Apr 2019 10:07:01 -0400 (EDT)
Date:   Wed, 17 Apr 2019 10:07:01 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 4/5] fscrypt: only set dentry_operations on ciphertext
 dentries
Message-ID: <20190417140701.GD4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-5-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:12AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Plaintext dentries are always valid, so only set fscrypt_d_ops on
> ciphertext dentries.
> 
> Besides marginally improved performance, this allows overlayfs to use an
> fscrypt-encrypted upperdir, provided that all the following are true:
> 
>     (1) The fscrypt encryption key is placed in the keyring before
> 	mounting overlayfs, and remains while the overlayfs is mounted.
> 
>     (2) The overlayfs workdir uses the same encryption policy.
> 
>     (3) No dentries for the ciphertext names of subdirectories have been
> 	created in the upperdir or workdir yet.  (Since otherwise
> 	d_splice_alias() will reuse the old dentry with ->d_op set.)
> 
> One potential use case is using an ephemeral encryption key to encrypt
> all files created or changed by a container, so that they can be
> securely erased ("crypto-shredded") after the container stops.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
