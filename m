From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 6/8] fs: always maintain i_dio_count
Date: Mon, 20 Jun 2011 14:29:24 -0700
Message-ID: <20110620212924.GA26204@noexit.corp.google.com>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.567119520@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38121 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1FTV3c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 17:29:32 -0400
Content-Disposition: inline
In-Reply-To: <20110620202031.567119520@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 04:15:39PM -0400, Christoph Hellwig wrote:
> Maintain i_dio_count for all filesystems, not just those using DIO_LOCKING.
> This these filesystems to also protect truncate against direct I/O requests
> by using common code.  Right now the only non-DIO_LOCKING filesystem that
> appears to do so is XFS, which uses an opencoded variant of the i_dio_count
> scheme.
> 
> Behaviour doesn't change for filesystems never calling inode_dio_wait,
> which are all that never use DIO_LOCKING.
> 
> For ext4 behaviour changes with the dioread_nonlock option, which previous
> was missing any protection between truncate and direct I/O reads.
> 
> For ocfs2 that handcrafted i_dio_count manipulations are replaced with
> the common code noew available.

	Oh god you're making the world scary.  Are you guaranteeing that
all allocation changes are locked out by the time we get into
file_aio_write() and file_aio_read()?  This is not obvious to me.

Joel

-- 

"Glory is fleeting, but obscurity is forever."  
         - Napoleon Bonaparte

			http://www.jlbec.org/
			jlbec@evilplan.org
