From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Ext4: Don't ask about supporting ext2/3 in ext4 if ext4
 is not configured
Date: Mon, 14 Dec 2009 10:10:22 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0912141007410.26135@localhost.localdomain>
References: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbZLNSKl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 13:10:41 -0500
In-Reply-To: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 14 Dec 2009, David Howells wrote:
>  config EXT4_USE_FOR_EXT23
>  	bool "Use ext4 for ext2/ext3 file systems"
> -	depends on EXT3_FS=n || EXT2_FS=n
> +	depends on EXT4_FS && (EXT3_FS=n || EXT2_FS=n)

Side note: I think we should actively avoid complex config dependency 
expressions.

The above can be written with simpler expressions by just splitting it in 
two, and I think it makes it more readable:

	depends on EXT4_FS
	depends on EXT3_FS=n || EXT2_FS=n

since the two expressions are logically totally unrelated: one is just the 
obvious "this kconfig doesn't make sense without ext4" thing that was 
missing before, and the other is a totally unrelated "if you already have 
selected ext2 and ext3, then you clearly don't want ext4 to deal with 
them".

			Linus
