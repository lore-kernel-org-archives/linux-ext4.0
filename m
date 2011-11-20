From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: e2fsprogs: Avoid infinite loop in ext2fs_find_block_device()
Date: Sun, 20 Nov 2011 00:17:07 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1111200011530.8000@trent.utfs.org>
References: <4EB23889.1010807@whamcloud.com> <4EB2A983.6070203@redhat.com> <121461D1-4A28-4B65-960D-7549D2782FFA@mit.edu> <4EB3DF9E.7010601@whamcloud.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@MIT.EDU>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Niu <niu@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:35213 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab1KTIZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Nov 2011 03:25:36 -0500
In-Reply-To: <4EB3DF9E.7010601@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 4 Nov 2011 at 20:50, Niu wrote:
> diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
> index b182d7f..82e1ba0 100644
> --- a/lib/ext2fs/ext2fsP.h
> +++ b/lib/ext2fs/ext2fsP.h
> @@ -11,6 +11,8 @@
>  
>  #include "ext2fs.h"
>  
[...]
> --- a/lib/ext2fs/finddev.c
> +++ b/lib/ext2fs/finddev.c
> @@ -34,6 +34,7 @@
>  
>  #include "ext2_fs.h"
>  #include "ext2fs.h"
> +#include "ext2fsP.h"

On the very real chance of making a fool of myself: if ext2fsP.h includes 
ext2fs.h and now finddev.c will include ext2fsP.h - shouldn't we omit the '#include 
"ext2fs.h"' in finddev.c (and namei.c) now?

I guess the compiler/preprocessor will figure this out, just wondering about
code cleanliness. Then again we have names like 'ext2_fs.h' and 
'ext2fs.h', I guess only an insider will know the difference :-)

Christian.
-- 
BOFH excuse #97:

Small animal kamikaze attack on power supplies
