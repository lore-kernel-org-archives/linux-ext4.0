From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 23:01:35 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
References: <4859EFE2.2090202@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Arjan van de Ven <arjan@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbYFSGCF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Jun 2008 02:02:05 -0400
In-Reply-To: <4859EFE2.2090202@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Wed, 18 Jun 2008, Arjan van de Ven wrote:
>
> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
> The oops is a page fault in the ext3 "do_split" function, and the first
> report of it was with 2.6.26-rc6-git3.

Interesting.

> It happens with various applications; the backtraces are at:
> 
> http://www.kerneloops.org/search.php?search=do_split
> 
> but are generally of this pattern:
> 
> *do_split
> ext3_add_entry
> ext3_rename
> vfs_rename
> ... <various paths into vfs_rename> ...
> 
> or
> 
> *do_split
> ? add_dirent_to_buf
> ext3_add_entry
> ext3_new_inode
> ext3_add_nondir
> ext3_create
> vfs_create
> ....
> 
> did we change anything in ext3 this cycle?

I'm not seeing anything relevant, but I'm adding Al to the cc in, since 
the r/o bind mounts did change fs/namei.c and vfs_create/mkdir in 
particular. Not that I see why that would trigger either, but the changes 
to fs/ext3/namei.c seem to be even _less_ interesting than that.

One thing I note is that all the oopses seem to be i686 - are there that 
few x86-64 fc10 users (I'd have assumed that 64-bit is starting to be the 
norm for people who live on the edge, but perhaps I'm just out of touch)? 

Or could this perhaps be an indication that it is specific to i686 some 
way (eg a compiler issue?)

		Linus
