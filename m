From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Fix bug in ext2fs_unlink
Date: Sat, 1 Dec 2007 07:08:57 -0500
Message-ID: <20071201120857.GC28558@thunk.org>
References: <20071127170306.GB4617@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48419 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXLARgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Dec 2007 12:36:03 -0500
Content-Disposition: inline
In-Reply-To: <20071127170306.GB4617@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2007 at 06:03:06PM +0100, Jan Kara wrote:
>   Hi,
> 
>   the patch below fixes a bug in ext2fs_unlink() I came across when testing
> my changes to e2fsprogs for 64KB blocksize support... Please apply.

Thanks, applied.

						- Ted
