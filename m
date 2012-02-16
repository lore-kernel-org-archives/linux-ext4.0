From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Thu, 16 Feb 2012 17:58:10 -0500
Message-ID: <20120216225810.GB26473@thunk.org>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53910 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2BPW6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 17:58:15 -0500
Content-Disposition: inline
In-Reply-To: <1329428112-8911-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 16, 2012 at 04:35:11PM -0500, Phillip Susi wrote:
> At the end of writing the raw image file, output_meta_data_blocks()
> wrote a single zero byte.  Not only does this cause the last block
> of the image file to be non sparse, but this was being skipped if
> there were no leftover sparse bytes from the main loop.  This would
> happen if the source fs happened to have an even multiple of 1MiB
> of free blocks at the end, leaving the sparse image file shorter
> than it should be.

I don't see the bug here.  If there are no leftover sparse bytes,
there's no need to write the last zero byte.  The whole point was to
make sure i_size was set correctly, and if sparse==0, then i_size is
correct.

> Instead of writing a null byte, just truncate() the file instead,
> whether or not there are any leftover sparse bytes.

ftruncate() happens to work today for Linux, but it's not guaranteed
to do anything on all operating systems or even all file systems.  Per
the standards spec:

	If the file previously was smaller than this size, ftruncate()
	shall either increase the size of the file or fail.

Speaking of which, you're not checking the return value from ftruncate
in your patch.  So I'd be happy if you checked ftruncate, and if it
failed, falling back to the

	if (sparse)
		write_block(fd, zero_buf, sparse-1, 1, -1);

code path.  That way, if ftruncate() happens to fail on NFS, or ceph,
or some random file system that chose to meet the standards spec, but
by failing if someone tries to increase the size of the file using
ftruncate.  (Or some other OS; there are other operating systems,
including GNU Hurd and BSD, and I don't know for sure how ftruncate
behaves on all of those other OS's and file systems.)

						- Ted
