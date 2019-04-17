Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17459C282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5F23206BA
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 14:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732373AbfDQOGf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:06:35 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44300 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729395AbfDQOGe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 10:06:34 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HE6Agt002081
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 10:06:11 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3DD27420497; Wed, 17 Apr 2019 10:06:10 -0400 (EDT)
Date:   Wed, 17 Apr 2019 10:06:10 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-unionfs@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@chromium.org>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: Re: [PATCH v2 3/5] fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when
 unaliasing directory
Message-ID: <20190417140610.GC4686@mit.edu>
References: <20190320183913.12686-1-ebiggers@kernel.org>
 <20190320183913.12686-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320183913.12686-4-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Mar 20, 2019 at 11:39:11AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make __d_move() clear DCACHE_ENCRYPTED_NAME on the source dentry.  This
> is needed for when d_splice_alias() moves a directory's encrypted alias
> to its decrypted alias as a result of the encryption key being added.
> 
> Otherwise, the decrypted alias will incorrectly be invalidated on the
> next lookup, causing problems such as unmounting a mount the user just
> mount()ed there.
> 
> Note that we don't have to support arbitrary moves of this flag because
> fscrypt doesn't allow dentries with DCACHE_ENCRYPTED_NAME to be the
> source or target of a rename().
> 
> Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
> Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
