From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3 V4] debugfs.c: do sparse copy when src is a sparse
 file
Date: Sun, 13 Oct 2013 22:49:52 -0400
Message-ID: <20131014024952.GD9609@thunk.org>
References: <1377498124-25842-1-git-send-email-liezhi.yang@windriver.com>
 <1377498124-25842-3-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, dvhart@linux.intel.com,
	darrick.wong@oracle.com
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45670 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab3JNCty (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 22:49:54 -0400
Content-Disposition: inline
In-Reply-To: <1377498124-25842-3-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 26, 2013 at 02:22:03PM +0800, Robert Yang wrote:
> Let debugfs do sparse copy when src is a sparse file, just like
> "cp --sparse=auto"
> 
> * For the:
>   #define IO_BUFSIZE 64*1024
>   this is a suggested value from gnu coreutils:
>   http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=blob;f=src/ioblksize.h;h=1ae93255e7d0ccf0855208c7ae5888209997bf16;hb=HEAD
> 
> * Use malloc() to allocate memory for the buffer since put 64K (or
>   more) on the stack seems not a good idea.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Applied, thanks.

					- Ted
