From: Theodore Tso <tytso@mit.edu>
Subject: Re: +
	ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesys
	tems.patch added to -mm tree
Date: Wed, 11 Feb 2009 10:02:27 -0500
Message-ID: <20090211150227.GI29220@mini-me.lan>
References: <200902102257.n1AMvwKl006860@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: yjwei@cn.fujitsu.com, linux-ext4@vger.kernel.org
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33772 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZBKPQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 10:16:18 -0500
Content-Disposition: inline
In-Reply-To: <200902102257.n1AMvwKl006860@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 10, 2009 at 02:57:58PM -0800, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      ext2: fix support for empty directory blocks in 64k blocksize filesystems
> has been added to the -mm tree.  Its filename is
>      ext2-fix-support-for-empty-directory-blocks-in-64k-blocksize-filesystems.patch

NACK.  The commit description is incomplete, we need to discuss more
what's the best way of handling this.  See the discussion around the
ext4 patch on linux-ext4 for more details.

This patch is entirely moot for ext2 in any case, since
EXT2_MAX_BLOCK_SIZE was never changed from 4096.

								- Ted
