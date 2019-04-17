Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D44C282DC
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 16:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB854217F4
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 16:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbfDQQ4b (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:56:31 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50587 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731454AbfDQQ4b (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 12:56:31 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HGtvvX009766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 12:55:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id DA50D420497; Wed, 17 Apr 2019 12:55:56 -0400 (EDT)
Date:   Wed, 17 Apr 2019 12:55:56 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/2] fscrypt: cache decrypted symlink target in
 ->i_link
Message-ID: <20190417165556.GI4686@mit.edu>
References: <20190410202115.64501-1-ebiggers@kernel.org>
 <20190410202115.64501-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410202115.64501-3-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 01:21:15PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Path lookups that traverse encrypted symlink(s) are very slow because
> each encrypted symlink needs to be decrypted each time it's followed.
> This also involves dropping out of rcu-walk mode.
> 
> Make encrypted symlinks faster by caching the decrypted symlink target
> in ->i_link.  The first call to fscrypt_get_symlink() sets it.  Then,
> the existing VFS path lookup code uses the non-NULL ->i_link to take the
> fast path where ->get_link() isn't called, and lookups in rcu-walk mode
> remain in rcu-walk mode.
> 
> Also set ->i_link immediately when a new encrypted symlink is created.
> 
> To safely free the symlink target after an RCU grace period has elapsed,
> introduce a new function fscrypt_free_inode(), and make the relevant
> filesystems call it just before actually freeing the inode.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, applied.

					- Ted
