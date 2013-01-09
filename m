From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2 v2] debugfs: dump a sparse file as a new sparse file
Date: Wed, 9 Jan 2013 09:58:54 -0500
Message-ID: <20130109145854.GA27630@thunk.org>
References: <1357043415-24668-1-git-send-email-wenqing.lz@taobao.com>
 <1357043415-24668-3-git-send-email-wenqing.lz@taobao.com>
 <20130101203858.GB12554@thunk.org>
 <20130104040505.GA27833@gmail.com>
 <20130104193709.GA6501@thunk.org>
 <20130105044522.GA4203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, George Spelvin <linux@horizon.com>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42503 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339Ab3AIO7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jan 2013 09:59:00 -0500
Content-Disposition: inline
In-Reply-To: <20130105044522.GA4203@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 12:45:22PM +0800, Zheng Liu wrote:
> Yes, some programs call ext2fs_file_read() with a 4k or 16k fixed size
> buffer, and ext2fs_file_read() calls ext2fs_file_read2().  But it won't
> skip the sparse blocks because when ext2fs_file_read2() is called in
> ext2fs_file_read(), the last argument, namely 'seek', is 0.  That means
> that in ext2fs_file_read2() 'flags' is 0.  Thus, in load_buffer()
> 'flags' is not equal to SEEK, and EXT2_FILE_BUF_VALID is marked.  Then
> we return back to ext2fs_file_read2() and all data in file->buf is
> copied.  So I think the behavior of ext2fs_file_read() doesn't be
> changed.

You're right; I had forgotten about that part of the change.

I still am a bit concerned about the interface, because if you specify
a pointer to seek in ext2fs_file_read2(), you have to know what the
file system blocksize is, because if you give a count which is larger
than a single block, the value of the returned seek and the data which
is returned in the buffer is impossible to interpret (consider a file
where every other 1k block is sparse, and you try to read into a 4k
buffer).

So what I would suggest is the following as a better, more efficient
interface.

1) Add a new flag which can be passed into ext2_file_open() which
requests sparse-intelligent handling.

2) If the sparse flag is set, then ext2_file_read() will stop the read
when it runs into the first uninitialized or sparse block.  That is,
consider the example file which has 8k of data, a 4k uninitialized
block, and then 12k of data after that.  If the sparse flag is passed
to ext2_file_open(), then ext2fs_file_read(fd, buf, 16384, &got) will
read 8k of data into buf, and return with got set to 8192.

3) To distinguish between EOF and a sparse block, if the current file
offset is pointed at a sparse/uninitialized block, and the sparse flag
was passed to ext2_file_open(), then in addition to *got getting set
0, ext2_file_read() will also return a new error code,
EXT2_ET_READ_HOLE_FOUND.

4) We also extend ext2_file_llseek() to also support EXT2_SEEK_HOLE
and EXT2_SEEK_DATA, which works like SEEK_HOLE and SEEK_DATA flags to
llseek().  This will allow the caller to efficiently find the next
part of the file with valid data.

What I like about this interface is that we don't need to define a new
ext2_file_read2(), and it is also more efficient for an application
which is interested in reading multiple blocks at a time.

What do you think?

						- Ted


