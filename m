From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/12] e2fsprogs mke2fs optimizations and new features
Date: Mon, 20 Jan 2014 11:30:00 -0500
Message-ID: <20140120163000.GA14689@thunk.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50128 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaATQaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 11:30:04 -0500
Content-Disposition: inline
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:54:02AM -0500, Theodore Ts'o wrote:
> Theodore Ts'o (12):
>   libext: optimize find_first_set() for bitarray-based bitmaps
>   libext2: optimize ext2fs_new_block2()

I've fixed up the commit description for these two patches so that
they read "libext2fs".

						- Ted
