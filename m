From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Doc fix: ext2 can only have 32,000 subdirs, not
 32,768.
Date: Wed, 27 May 2009 17:27:53 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0905271726510.13917@wotan.suse.de>
References: <63a2e74f0905181210i17640dd9ld2d5219f6bdd79b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-943703750-1243438074=:13917"
Cc: rdunlap@xenotime.net, linux-ext4@vger.kernel.org,
	linux-kernel@kernel.org, trivial@kernel.org
To: Michael Shields <mshields@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZE0P1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 11:27:53 -0400
In-Reply-To: <63a2e74f0905181210i17640dd9ld2d5219f6bdd79b9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-943703750-1243438074=:13917
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 18 May 2009, Michael Shields wrote:

> ext2.txt says that dirs can have 32,768 subdirs, but the actual value of 
> EXT2_LINK_MAX is 32000.
> 
> ext3 is the same, but the doc does not mention it.  One of ext4's 
> features is to "fix 32000 subdirectory limit".
> 
> 
> --- linux-2.6.29.3/Documentation/filesystems/ext2.txt.orig 2009-05-08 15:47:21.000000000 -0700
> +++ linux-2.6.29.3/Documentation/filesystems/ext2.txt 2009-05-18 12:03:58.000000000 -0700
> @@ -322,7 +322,7 @@ an upper limit on the block size imposed
>  so 8kB blocks are only allowed on Alpha systems (and other architectures
>  which support larger pages).
>  
> -There is an upper limit of 32768 subdirectories in a single directory.
> +There is an upper limit of 32000 subdirectories in a single directory.
>  
>  There is a "soft" upper limit of about 10-15k files in a single directory
>  with the current linear linked-list directory implementation.  This limit

I don't see this in linux-next. Could please either someone from ext[234] 
folks either merge it, or send me an Acked-by: and I will take it through 
trivial tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--168427776-943703750-1243438074=:13917--
