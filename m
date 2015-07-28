From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove filemap_fdatawrite() when synchronizing a
 data journaled file
Date: Tue, 28 Jul 2015 08:07:13 -0400
Message-ID: <20150728120712.GH2851@thunk.org>
References: <1046256826.88691438049846580.JavaMail.weblogic@epmlwas02d>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, daehojng@gmail.com
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58414 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbbG1MHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Jul 2015 08:07:15 -0400
Content-Disposition: inline
In-Reply-To: <1046256826.88691438049846580.JavaMail.weblogic@epmlwas02d>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 28, 2015 at 02:17:26AM +0000, Daeho Jeong wrote:
> When fsync() system call is executed, all data of the file should be written on the storage.
> But, in a case of that the file is operated in data journal mode, the data doesn't need to be
> flushed out and waited for its I/O completion. Moreover, by invoking filemap_fdatawrite()
> function on the data journaled file, ext4_sync_file() suffers from an unnecessary delay
> which is caused by flushing out and waiting for the I/O completion of a ton of newly-dirtied
> pages which were dirtied by the previous commit.

No, this patch is incorrect.  Data journalling works by having the
buffers getting dirtied, and that doesn't happen until we call
filemap_fdatawrite_range().  It's true that we don't have to call
filemap_write_and_wait_range(), but simply skipping the writeback
entirely will cause data writes to get lost after an fsync() if we
crash immediately afterwards.

I'm guessing you didn't actually test this patch for correctness?

    	     	 		      	   	 - Ted
