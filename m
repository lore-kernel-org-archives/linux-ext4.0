Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE9AC10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 05:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C404217D6
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 05:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554872690;
	bh=7C5EkI6QcgUdOcfhNlLnkQP6w5KekGPVI5d0/1MYD0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=maOsv7yTKiz1yhsjyk+mxk7ZH/9lRhcSDw/UAyzY5w40VZ3YnhLePfiqaRJXuN5qB
	 4a0jMw8AFz/q17t6Y18NGj0xRks2gjhz4YhnO9yrEeNaNfhau9efgHKU24uRCozKqR
	 ST8Rl+7jEzZIyiaWSx3pOJ4Hv7IpYULu3GxeksQA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfDJFEs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 01:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfDJFEs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 01:04:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31682064B;
        Wed, 10 Apr 2019 05:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554872688;
        bh=7C5EkI6QcgUdOcfhNlLnkQP6w5KekGPVI5d0/1MYD0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OzoOgq5U3eekqjiR4C85EbGknOw9ShC1eifpQgg/fuXnrJKJrcUtfvjYl2d/ubiWk
         HvLmZSDlNrcoVMGoaGTaNIzaj3RAXWccUeeIodJMb3decCCwFy2ve4eXVIqp67rgel
         YNfq7NClPEv/LDulwdD/boElFRTU1ELs1t633xBQ=
Date:   Tue, 9 Apr 2019 22:04:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410050445.GE7140@sol.localdomain>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
 <20190410012247.GB2454@sol.localdomain>
 <20190410013934.GV2217@ZenIV.linux.org.uk>
 <20190410025808.GA7140@sol.localdomain>
 <20190410034414.GW2217@ZenIV.linux.org.uk>
 <20190410040413.GC7140@sol.localdomain>
 <20190410043135.GX2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410043135.GX2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 05:31:35AM +0100, Al Viro wrote:
> On Tue, Apr 09, 2019 at 09:04:15PM -0700, Eric Biggers wrote:
> 
> > > What's to stop you from doing just that right now?  You'd need to take
> > > care with barriers, but you'd need that anyway... As soon as ->i_link is set
> > > you'll get no more ->get_link() on that sucker, using the cached value
> > > from that point on.  IDGI...
> > 
> > 1.) The VFS won't know to drop of RCU-walk mode, so waiting an RCU grace period
> >     before freeing the symlink target becomes mandatory.  (Which I'd like to do
> >     for fscrypt anyway, but doing it sanely appears to require implementing
> >     .destroy_inode() for ext4, f2fs, and ubifs.  I hoped I could do non-RCU mode
> >     as a simpler first step.)
> 
> You might want to check those filesystems.  All three you've mentioned *have*
> ->destroy_inode() already.
>  

Yep, I just noticed that.

> > 2.) The VFS won't know to use a read memory barrier when loading i_link.
> >     The VFS could issue one unconditionally, but it would be unnecessary for
> >     regular fast symlinks.
> 
> Not really.  All we need on the read side is READ_ONCE(); it will supply
> smp_read_barrier_depends() (which is a no-op except for alpha).  On the
> write side we need smp_store_release() to set ->i_link (in addition to
> whatever serialization we want for actual calculation of the value to
> be cached, of course).

Okay, I didn't realize that READ_ONCE() would be sufficient.  I thought
smp_load_acquire() was needed.  I guess you're right; we'd only read what the
pointer points to, so it's a data dependency.

Do you see any problem with using cmpxchg_release() on the write side, so no
additional lock is needed?  (Like what we do for ->i_crypt_info, except
currently it's actually cmpxchg() there, with a direct access on the read side.
IIUC now, that should be changed to cmpxchg_release() and READ_ONCE().)

- Eric
