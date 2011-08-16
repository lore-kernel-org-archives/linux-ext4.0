From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Resolve the hang of direct i/o read in handling
 EXT4_IO_END_UNWRITTEN.
Date: Tue, 16 Aug 2011 14:29:22 -0400
Message-ID: <20110816182922.GA12374@thunk.org>
References: <1313476673-4866-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com, mjt@tls.msk.ru
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44351 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1HPUxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Aug 2011 16:53:16 -0400
Content-Disposition: inline
In-Reply-To: <1313476673-4866-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 02:37:53PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> EXT4_IO_END_UNWRITTEN flag set and the increase of i_aiodio_unwritten should
> be done simultaneously since ext4_end_io_nolock always clear the flag and
> decrease the counter in the same time.
> 
> We don't increase i_aiodio_unwritten when setting EXT4_IO_END_UNWRITTEN so
> it will go nagative and causes some process to wait forever.
> 
> Part of the patch came from Eric in his e-mail, but it doesn't fix the problem
> met by Michael actually.
> http://marc.info/?l=linux-ext4&m=131316851417460&w=2
> 
> Reported-and-Tested-by: Michael Tokarev<mjt@tls.msk.ru>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks I've taken this into the ext4 tree.  I am a bit worried this
will trigger a GCC warning:

+	/*
+	 * It may be over-defensive here to check EXT4_IO_END_UNWRITTEN now,
+	 * but being more careful is always safe for the future change.
+	 */
 	inode = io_end->inode;
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
+		io_end->flag |= EXT4_IO_END_UNWRITTEN;
+		atomic_inc(&EXT4_I(inode)->i_aiodio_unwritten);
+	}
 
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);

... since in Google we've been compiling with -Werror, but it's not
causing an error on gcc 4.4, which is what I still have on my laptop.
It may be that newer versions of GCC are smart enough to notice tha
the above is dead code, and then complain with a warning.

        	     	  	    	 - Ted
