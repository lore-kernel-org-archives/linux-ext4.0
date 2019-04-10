Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABC3C10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD0DC217D6
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554869786;
	bh=6Tm/kYmmW/sLgnjhtsq5NqVafuKCWEF71UBQEpZeAxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pT0r3IwlU4qY35cdTzm0RvyvSTO1AtLmk84pD93m47fX8wU+Bvb4SErZ5awqGUuZ9
	 033g+mOkqkLSWAVrZ9FTTLEYuyjeQzN69pFmNx/DuutmiSIZ+IDxd7S56zUYlK12C6
	 es0pOvxiJyuAfK6YSSbFnoqigyIYQOcDW3Ta1Q2Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbfDJEQ0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 00:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfDJEQ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 00:16:26 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 328EB2082E;
        Wed, 10 Apr 2019 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554869785;
        bh=6Tm/kYmmW/sLgnjhtsq5NqVafuKCWEF71UBQEpZeAxE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G7cn+1cyy86BStCYV3WdPoQuvnWK1W7bmzPbBd41IoBWBpTlhqIm+S1LkVKhoPb5W
         AkLTHfLux2p0u7d1hRsm3S+yXWFmshgqw29obD7x1kAoPsoSQFu2pz/5whalqJZhZT
         zpl8WIo84MrqaC4qO/qfVqjWnMiE2MuG5kUXjlHg=
Date:   Tue, 9 Apr 2019 21:16:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410041623.GD7140@sol.localdomain>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
 <20190410012247.GB2454@sol.localdomain>
 <20190410013934.GV2217@ZenIV.linux.org.uk>
 <20190410025808.GA7140@sol.localdomain>
 <20190410034414.GW2217@ZenIV.linux.org.uk>
 <20190410040413.GC7140@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410040413.GC7140@sol.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 09:04:15PM -0700, Eric Biggers wrote:
> On Wed, Apr 10, 2019 at 04:44:14AM +0100, Al Viro wrote:
> > On Tue, Apr 09, 2019 at 07:58:08PM -0700, Eric Biggers wrote:
> > 
> > > It could check a flag IOP_GET_LINK in ->i_opflags instead, so it would be the
> > > same number of checks.  See patch below.
> > 
> > With that patch ->i_link is completely unused if ->get_link() is non-NULL,
> > so you get a method call on each traversal...
> > 
> 
> .get_link would be left NULL in all inode_operations that currently use
> simple_get_link, then simple_get_link() would be removed.  My example patch just
> changed it in ext4 as an example.
> 
> > > Benefits are that we get code that isn't actively misleading (via
> > > simple_get_link() existing but actually never being called), and filesystems can
> > > cache a symlink target in ->i_link if it becomes available later, i.e. if it's
> > > not immediately available at iget() time.  Otherwise a filesystem-private field
> > > has to be used instead.  (For fscrypt, I'd probably use fscrypt_info::ci_link.)
> > 
> > What's to stop you from doing just that right now?  You'd need to take
> > care with barriers, but you'd need that anyway... As soon as ->i_link is set
> > you'll get no more ->get_link() on that sucker, using the cached value
> > from that point on.  IDGI...
> 
> 1.) The VFS won't know to drop of RCU-walk mode, so waiting an RCU grace period
>     before freeing the symlink target becomes mandatory.  (Which I'd like to do
>     for fscrypt anyway, but doing it sanely appears to require implementing
>     .destroy_inode() for ext4, f2fs, and ubifs.  I hoped I could do non-RCU mode
>     as a simpler first step.)
> 
> 2.) The VFS won't know to use a read memory barrier when loading i_link.
>     The VFS could issue one unconditionally, but it would be unnecessary for
>     regular fast symlinks.
> 
> - Eric

Okay, actually all three filesystems have .destroy_inode() anyway.  Not sure how
I missed that.  So it should be possible to free the decrypted symlink target
from {ext4,f2fs,ubifs}_i_callback().

- Eric
