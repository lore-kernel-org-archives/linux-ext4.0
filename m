From: "George Spelvin" <linux@horizon.com>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: 9 Jan 2013 19:42:32 -0500
Message-ID: <20130110004232.9651.qmail@science.horizon.com>
References: <20130109145854.GA27630@thunk.org>
To: linux-ext4@vger.kernel.org, linux@horizon.com, tytso@mit.edu,
	wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:42187 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932242Ab3AJAmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2013 19:42:33 -0500
In-Reply-To: <20130109145854.GA27630@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 2) If the sparse flag is set, then ext2_file_read() will stop the read
> when it runs into the first uninitialized or sparse block.  That is,
> consider the example file which has 8k of data, a 4k uninitialized
> block, and then 12k of data after that.  If the sparse flag is passed
> to ext2_file_open(), then ext2fs_file_read(fd, buf, 16384, &got) will
> read 8k of data into buf, and return with got set to 8192.
> 
> 3) To distinguish between EOF and a sparse block, if the current file
> offset is pointed at a sparse/uninitialized block, and the sparse flag
> was passed to ext2_file_open(), then in addition to *got getting set
> 0, ext2_file_read() will also return a new error code,
> EXT2_ET_READ_HOLE_FOUND.

Given that the current model of ext2fs_file_read is that it returns
some valid data in *got, AND the reason it stopped short as the retval,
wouldn't it make more sense to return EXT2_ET_READ_HOLE_FOUND from the
*first* read call?

It's a minor thing, as you just end up falling back to the Unix syscall
model of deferring the error until the next read call, but wouldn't
it be more consistent?
