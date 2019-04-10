Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECCBC282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F6F5217D6
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554869058;
	bh=mZRQz5Xmi/KFd58YP9IplBrCBIFKwz68VQIXLNPiAUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QmRYzmjWon+SIVu0x9aBhOEgktk7nOqT3Gm1SK7L4M7ZpzmXHEREHICK20IDcV+z8
	 /YhRYjim2g6c4n+Zrvv28Y8giLzfc7QXccqJUcJocAAk8g8ApCL0Jb5+FH/tlf7VCa
	 K/S2jDH0OEsfzA6q3QmUkxAfD5G6Pk5rWHfT2B+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfDJEER (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 00:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfDJEER (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 00:04:17 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0922064A;
        Wed, 10 Apr 2019 04:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554869057;
        bh=mZRQz5Xmi/KFd58YP9IplBrCBIFKwz68VQIXLNPiAUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O0iB/ohaer2v5eAop1Wsgnsw6fq3oYk7JK18X4QzO6+JTHzch8NF18Insdg9idXf3
         ZulUIkVmjQgtZNmGR27hSm7RJWcaltwb4rst9kVqOQAKqxa4cFDZSkw/vKT8aGQAe4
         ty8q+iuK/m5CbNLmMDSeXqqrJnGwRAvzOS8J19uA=
Date:   Tue, 9 Apr 2019 21:04:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410040413.GC7140@sol.localdomain>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
 <20190410012247.GB2454@sol.localdomain>
 <20190410013934.GV2217@ZenIV.linux.org.uk>
 <20190410025808.GA7140@sol.localdomain>
 <20190410034414.GW2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410034414.GW2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 04:44:14AM +0100, Al Viro wrote:
> On Tue, Apr 09, 2019 at 07:58:08PM -0700, Eric Biggers wrote:
> 
> > It could check a flag IOP_GET_LINK in ->i_opflags instead, so it would be the
> > same number of checks.  See patch below.
> 
> With that patch ->i_link is completely unused if ->get_link() is non-NULL,
> so you get a method call on each traversal...
> 

.get_link would be left NULL in all inode_operations that currently use
simple_get_link, then simple_get_link() would be removed.  My example patch just
changed it in ext4 as an example.

> > Benefits are that we get code that isn't actively misleading (via
> > simple_get_link() existing but actually never being called), and filesystems can
> > cache a symlink target in ->i_link if it becomes available later, i.e. if it's
> > not immediately available at iget() time.  Otherwise a filesystem-private field
> > has to be used instead.  (For fscrypt, I'd probably use fscrypt_info::ci_link.)
> 
> What's to stop you from doing just that right now?  You'd need to take
> care with barriers, but you'd need that anyway... As soon as ->i_link is set
> you'll get no more ->get_link() on that sucker, using the cached value
> from that point on.  IDGI...

1.) The VFS won't know to drop of RCU-walk mode, so waiting an RCU grace period
    before freeing the symlink target becomes mandatory.  (Which I'd like to do
    for fscrypt anyway, but doing it sanely appears to require implementing
    .destroy_inode() for ext4, f2fs, and ubifs.  I hoped I could do non-RCU mode
    as a simpler first step.)

2.) The VFS won't know to use a read memory barrier when loading i_link.
    The VFS could issue one unconditionally, but it would be unnecessary for
    regular fast symlinks.

- Eric
