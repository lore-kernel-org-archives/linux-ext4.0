Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1F3C282CE
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB8DB2084B
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbfDJBE1 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 21:04:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56330 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfDJBE1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 21:04:27 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hE1f7-0002xn-Qq; Wed, 10 Apr 2019 01:04:25 +0000
Date:   Wed, 10 Apr 2019 02:04:25 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410010425.GU2217@ZenIV.linux.org.uk>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410004553.GA2454@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 05:45:54PM -0700, Eric Biggers wrote:
> On Wed, Apr 10, 2019 at 01:33:46AM +0100, Al Viro wrote:
> > On Tue, Apr 09, 2019 at 04:35:44PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Path lookups that traverse encrypted symlink(s) are very slow because
> > > each encrypted symlink needs to be decrypted each time it's followed.
> > > 
> > > Make encrypted symlinks faster by caching the decrypted symlink target
> > > in ->i_link.  The first call to ->get_link() sets it; later calls simply
> > > return it.  ->symlink() also sets it when the symlink is created.
> > > 
> > > When the inode's ->i_crypt_info is freed, ->i_link is freed too.
> > > 
> > > Note: RCU-delayed freeing of ->i_link is not yet implemented.
> > > Therefore, for now even when ->i_link is set, path lookups must continue
> > > to drop out of RCU-walk mode when following an encrypted symlink.
> > 
> > And how the devil would they continue to do that, if I might ask?
> > ->get_link() is *NOT* called if ->i_link is non-NULL, period.
> 
> You're right, I didn't notice that ->get_link() isn't called when
> ->i_link is non-NULL.
> 
> But that being the case, what's the point of simple_get_link()?

Non-NULL ->get_link() => DCACHE_SYMLINK_TYPE in ->d_flags =>
d_is_symlink() true => step_into() progresses to pick_link().

IOW, non-NULL ->get_link() is what tells you that we have
a symlink there.
