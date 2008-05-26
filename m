From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: bh_count undeclared
Date: Mon, 26 May 2008 02:19:10 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0805260216110.4890@sheep.housecafe.de>
References: <alpine.DEB.1.10.0805251727040.4890@sheep.housecafe.de> <20080525233809.GG5970@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:57452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbYEZATO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 May 2008 20:19:14 -0400
In-Reply-To: <20080525233809.GG5970@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 25 May 2008, Theodore Tso wrote:
> Whoops, my bad.  I was compiling with --enable-jfs-debug, and I didn't
> notice the change I made broke things without that configuration
> option.

But even *with* --enable-jfs-debug the error occured.

> The right fix is just to surround the bh_count reference with an
> #ifdef CONFIG_JBD_DEBUG.

Right now the declaration of bh_count is surrounded with an #ifdef:

#ifdef CONFIG_JBD_DEBUG     /* Enabled by configure --enable-jfs-debug */
static int bh_count = 0;
#endif

But you want the refence surrounded by this #ifdef, right?

Thanks,
Christian.
-- 
BOFH excuse #192:

runaway cat on system.
