Return-Path: <SRS0=X8xt=SS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B5AC10F13
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 23:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8852075B
	for <linux-ext4@archiver.kernel.org>; Tue, 16 Apr 2019 23:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfDPXJI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 16 Apr 2019 19:09:08 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47708 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727382AbfDPXJI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Apr 2019 19:09:08 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3GN8evq017669
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Apr 2019 19:08:41 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3DC7F420497; Tue, 16 Apr 2019 19:08:40 -0400 (EDT)
Date:   Tue, 16 Apr 2019 19:08:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 1/5] fscrypt: clean up and improve dentry revalidation
Message-ID: <20190416230840.GB14623@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:09AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make various improvements to fscrypt dentry revalidation:
> 
> - Don't try to handle the case where the per-directory key is removed,
>   as this can't happen without the inode (and dentries) being evicted.
> 
> - Flag ciphertext dentries rather than plaintext dentries, since it's
>   ciphertext dentries that need the special handling.
> 
> - Avoid doing unnecessary work for non-ciphertext dentries.
> 
> - When revalidating ciphertext dentries, try to set up the directory's
>   i_crypt_info to make sure the key is really still absent, rather than
>   invalidating all negative dentries as the previous code did.  An old
>   comment suggested we can't do this for locking reasons, but AFAICT
>   this comment was outdated and it actually works fine.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
