Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE399C10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B90E42133D
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 04:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfDJEbh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 00:31:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58598 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfDJEbh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Apr 2019 00:31:37 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hE4tb-0006K4-Fn; Wed, 10 Apr 2019 04:31:35 +0000
Date:   Wed, 10 Apr 2019 05:31:35 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410043135.GX2217@ZenIV.linux.org.uk>
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
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 09:04:15PM -0700, Eric Biggers wrote:

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

You might want to check those filesystems.  All three you've mentioned *have*
->destroy_inode() already.
 
> 2.) The VFS won't know to use a read memory barrier when loading i_link.
>     The VFS could issue one unconditionally, but it would be unnecessary for
>     regular fast symlinks.

Not really.  All we need on the read side is READ_ONCE(); it will supply
smp_read_barrier_depends() (which is a no-op except for alpha).  On the
write side we need smp_store_release() to set ->i_link (in addition to
whatever serialization we want for actual calculation of the value to
be cached, of course).
