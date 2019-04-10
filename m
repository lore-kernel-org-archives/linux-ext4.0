Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DB0C10F0E
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AABD321741
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554859372;
	bh=KgE41UlwEaVvg2EGhTeUB2fNkJ594ankqwTAesjcuEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oNAf0F8jTSWhzOMACsM0lZ+7qM65EXVPRY5IpqTKWzgNS7YruvW73KB3evrht+jHW
	 GNLem6K7T5AZbhB9oQ52tzyo4WsPwsBYztilGXWyc4JIP5AbHdyRn7y/fYhRNOBWaV
	 x/d14j55SuHz8T0SFNE66CLjSxrBhIHz4DQe30io=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDJBWv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 21:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbfDJBWv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Apr 2019 21:22:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E8B2133D;
        Wed, 10 Apr 2019 01:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554859370;
        bh=KgE41UlwEaVvg2EGhTeUB2fNkJ594ankqwTAesjcuEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ccfFIj0bqcWjoqtIxFlW7oBdeixkgPSFHB9myA4W3KdzGrtVGT5mLnlu/Ali8heIE
         GsK5u5C9+SFp3fQ7aDags2mw3iTyUrJsGFO9Y7XBE6Fy/sELafdtZ3VeSp1Mnkyw1W
         J/JSkYmeBeqEBz9VnbVCJhnosffgkiXl9FoJzFUA=
Date:   Tue, 9 Apr 2019 18:22:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410012247.GB2454@sol.localdomain>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410010425.GU2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 02:04:25AM +0100, Al Viro wrote:
> On Tue, Apr 09, 2019 at 05:45:54PM -0700, Eric Biggers wrote:
> > On Wed, Apr 10, 2019 at 01:33:46AM +0100, Al Viro wrote:
> > > On Tue, Apr 09, 2019 at 04:35:44PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Path lookups that traverse encrypted symlink(s) are very slow because
> > > > each encrypted symlink needs to be decrypted each time it's followed.
> > > > 
> > > > Make encrypted symlinks faster by caching the decrypted symlink target
> > > > in ->i_link.  The first call to ->get_link() sets it; later calls simply
> > > > return it.  ->symlink() also sets it when the symlink is created.
> > > > 
> > > > When the inode's ->i_crypt_info is freed, ->i_link is freed too.
> > > > 
> > > > Note: RCU-delayed freeing of ->i_link is not yet implemented.
> > > > Therefore, for now even when ->i_link is set, path lookups must continue
> > > > to drop out of RCU-walk mode when following an encrypted symlink.
> > > 
> > > And how the devil would they continue to do that, if I might ask?
> > > ->get_link() is *NOT* called if ->i_link is non-NULL, period.
> > 
> > You're right, I didn't notice that ->get_link() isn't called when
> > ->i_link is non-NULL.
> > 
> > But that being the case, what's the point of simple_get_link()?
> 
> Non-NULL ->get_link() => DCACHE_SYMLINK_TYPE in ->d_flags =>
> d_is_symlink() true => step_into() progresses to pick_link().
> 
> IOW, non-NULL ->get_link() is what tells you that we have
> a symlink there.

I think that's pretty unintuitive.  The fact that multiple filesystems including
ext4 set ->i_link on fast symlinks, then set ->get_link() to a function that
returns ->i_link, made me assume that's the mechanism by which such symlink
targets are returned to the VFS.  When in fact fs/namei.c just uses ->i_link,
and never calls ->get_link().

Is there any reason why d_flags_for_inode() doesn't check S_ISLNK() instead, and
then fs/namei.c would call ->get_link() if non-NULL, otherwise use ->i_link?

- Eric
