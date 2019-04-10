Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2A4C10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 03:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 716B12075B
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 03:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfDJDoQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 23:44:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58092 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfDJDoQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 23:44:16 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hE49m-0005Nr-Cx; Wed, 10 Apr 2019 03:44:14 +0000
Date:   Wed, 10 Apr 2019 04:44:14 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410034414.GW2217@ZenIV.linux.org.uk>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
 <20190410012247.GB2454@sol.localdomain>
 <20190410013934.GV2217@ZenIV.linux.org.uk>
 <20190410025808.GA7140@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410025808.GA7140@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 07:58:08PM -0700, Eric Biggers wrote:

> It could check a flag IOP_GET_LINK in ->i_opflags instead, so it would be the
> same number of checks.  See patch below.

With that patch ->i_link is completely unused if ->get_link() is non-NULL,
so you get a method call on each traversal...

> Benefits are that we get code that isn't actively misleading (via
> simple_get_link() existing but actually never being called), and filesystems can
> cache a symlink target in ->i_link if it becomes available later, i.e. if it's
> not immediately available at iget() time.  Otherwise a filesystem-private field
> has to be used instead.  (For fscrypt, I'd probably use fscrypt_info::ci_link.)

What's to stop you from doing just that right now?  You'd need to take
care with barriers, but you'd need that anyway... As soon as ->i_link is set
you'll get no more ->get_link() on that sucker, using the cached value
from that point on.  IDGI...
