From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] fs: always maintain i_dio_count
Date: Mon, 20 Jun 2011 18:23:24 -0400
Message-ID: <20110620222324.GB3473@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.567119520@bombadil.infradead.org>
 <20110620212924.GA26204@noexit.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46595
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934Ab1FTWX1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 18:23:27 -0400
Content-Disposition: inline
In-Reply-To: <20110620212924.GA26204@noexit.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 20, 2011 at 02:29:24PM -0700, Joel Becker wrote:
> 	Oh god you're making the world scary.  Are you guaranteeing that
> all allocation changes are locked out by the time we get into
> file_aio_write() and file_aio_read()?  This is not obvious to me.

I have no idea how ocfs2's internal allocator locking works, but this
patch doesn't change it.  What this patch touches is exclusion between
truncate and pending direct I/O requests, and even there only the
implementation and not the semantics.

The old and new semantics are that you may have either

	1 ongoing truncate

OR

	n (>= 0; <= ATOMIC_T_MAX) ongoing direct I/O reads or writes

before that was enforced using the i_alloc_sem rw_semaphore, including
non-owner releases of it from AIO code, in the new code it's done using
a combination of i_mutex which was already taken in the truncate path,
and when starting new direct I/O requests, and the new i_dio_count
counter.

> 
> Joel
> 
> -- 
> 
> "Glory is fleeting, but obscurity is forever."  
>          - Napoleon Bonaparte
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org
---end quoted text---
