Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E23BC282DA
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 00:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A72720857
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 00:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfDJAdt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 20:33:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56012 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbfDJAds (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 20:33:48 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hE1BS-0002Vi-MH; Wed, 10 Apr 2019 00:33:46 +0000
Date:   Wed, 10 Apr 2019 01:33:46 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410003346.GT2217@ZenIV.linux.org.uk>
References: <20190409233544.156665-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409233544.156665-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 04:35:44PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Path lookups that traverse encrypted symlink(s) are very slow because
> each encrypted symlink needs to be decrypted each time it's followed.
> 
> Make encrypted symlinks faster by caching the decrypted symlink target
> in ->i_link.  The first call to ->get_link() sets it; later calls simply
> return it.  ->symlink() also sets it when the symlink is created.
> 
> When the inode's ->i_crypt_info is freed, ->i_link is freed too.
> 
> Note: RCU-delayed freeing of ->i_link is not yet implemented.
> Therefore, for now even when ->i_link is set, path lookups must continue
> to drop out of RCU-walk mode when following an encrypted symlink.

And how the devil would they continue to do that, if I might ask?
->get_link() is *NOT* called if ->i_link is non-NULL, period.
