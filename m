From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix racy use-after-free in ext4_end_io_dio()
Date: Thu, 24 Nov 2011 18:18:49 -0500
Message-ID: <20111124231848.GC5167@thunk.org>
References: <20111124194626.GA5260@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kent Overstreet <koverstreet@google.com>, rickyb@google.com,
	aberkan@google.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37362 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab1KXXSx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Nov 2011 18:18:53 -0500
Content-Disposition: inline
In-Reply-To: <20111124194626.GA5260@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 24, 2011 at 11:46:26AM -0800, Tejun Heo wrote:
> ext4_end_io_dio() queues io_end->work and then clears iocb->private;
> however, io_end->work completes the iocb by calling aio_complete(),
> which may happen before io_end->work clearing thus leading to
> use-after-free.
> 
> Detected and tested with slab poisoning.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Kent Overstreet <koverstreet@google.com>
> Tested-by: Kent Overstreet <koverstreet@google.com>
> Cc: stable@kernel.org

Thanks!!  I've been trying to track down this bug for a while.  The
repro case I had ran the 12 fio's against 12 different file systems
with the following configuration:

[global]
direct=1
ioengine=libaio
iodepth=1
bs=4k
ba=4k
size=128m

[create]
filename=${TESTDIR}
rw=write

... and would leave a few inodes with elevated i_ioend_counts, which
means any attempt to delete those inodes or to unmount the file system
owning those inodes would hang forever.

With your patch this problem goes away.

>I *think* this is the correct fix but am not too familiar with code
>path, so please proceed with caution.

Looks good to me.  Thanks, applied.

>Thank you.

No, thank *you*!  :-)

					- Ted

P.S.  It would be nice to get this into xfstests, but it requires at
least 10-12 (12 to repro it reliably) HDD's, and a fairly high core
count machine in order to reproduce it.  I played around with trying
to create a reproducer that worked on a smaller number of disks and/or
fio's/CPU's, but I was never able to manage it.
