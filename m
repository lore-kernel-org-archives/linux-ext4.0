From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: include sys/time.h for gettimeofday()
Date: Mon, 27 Feb 2012 01:13:27 -0500
Message-ID: <20120227061327.GB14204@thunk.org>
References: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55428 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2B0GNd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 01:13:33 -0500
Content-Disposition: inline
In-Reply-To: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 12:18:07PM -0500, Mike Frysinger wrote:
> Building on my glibc-2.15 system hits a warning:
> 	gen_bitmap64.c: In function 'ext2fs_alloc_generic_bmap':
> 	gen_bitmap64.c:127:2: warning: implicit declaration of function
> 		'gettimeofday' [-Wimplicit-function-declaration]
> 
> Include sys/time.h if it's available for the prototype.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Thanks, applied.

						- Ted
