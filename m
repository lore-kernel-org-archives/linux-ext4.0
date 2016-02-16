From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: revert i_data_sum locking cleanups for
 dioread_nolock
Date: Tue, 16 Feb 2016 00:08:40 -0500
Message-ID: <20160216050840.GA3426@thunk.org>
References: <20160212182506.GB1592@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39504 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbcBPFIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2016 00:08:44 -0500
Content-Disposition: inline
In-Reply-To: <20160212182506.GB1592@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 12, 2016 at 01:25:06PM -0500, Eric Whitney wrote:
> Commit 2bcba4781fa3 ("ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag")
> can cause a kernel panic when xfstest generic/300 is run on a file
> system mounted with dioread_nolock.  The panic is typically triggered
> from check_irqs_on() (fs/buffer.c: 1272), and happens because
> ext4_end_io_dio() is being called in an interrupt context rather than
> from a workqueue for AIO.  This suggests that buffer_defer_completion
> may not be set properly when creating an unwritten extent for async
> direct I/O.
> 
> Revert the locking changes until this problem can be resolved.  Patch
> applied to 4.5-rc3 and tested with a full xfstest-bld auto group run.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

I was able to reliably reproduce the problem without this revert patch
using a 32-bit x86 kvm-xfstests test appliance:

   ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/testing/root_fs.img.i386

Using the command: "kvm-xfstests -c dioread_nolock generic/300"

With this patch, the problem goes away, so reverting the patch is
clearly the right thing for now.  There is something screwy going on,
since the original commit shouldn't have made a difference, but let's
revert it first, and figure it out when we have time to investigate
more deeply.

						- Ted
