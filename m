From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Thu, 22 Sep 2016 09:30:31 -0400
Message-ID: <20160922133031.zjiyudqwthqp742g@thunk.org>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
 <20160921143748.xswkovbjrtcgs3bq@thunk.org>
 <20160922123143.GO2834@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50062 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932876AbcIVNdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Sep 2016 09:33:11 -0400
Content-Disposition: inline
In-Reply-To: <20160922123143.GO2834@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2016 at 02:31:43PM +0200, Jan Kara wrote:
> 
> So I think what Christoph meant in this case is something like attached
> patch. That achieves more than your dirty hack in a much cleaner way.
> Beware, the patch is only compile-tested.

Your patch also disables dioread_nolock (which is what I think
Christoph was asking about because it's the rest of the dioread nolock
support code which causes the eye-bleeding complexity on the write
path).

> Then there is the case of unlocked direct IO overwrites which we allow to
> run without inode_lock in dioread_nolock mode as well and that is more
> difficult to resolve (there lay the problems with blocksize < pagesize you
> speak about).

Right, by disabling dioread_nolock, it means we lose the feature that
dioread_nolock doesn't require blocking versus _any_ direct I/O writes
(because of the post-write uninit->init conversion) --- not just DIO
overwrites.

But we should be able to support dioread_nolock as well as by only
taking inode_lock_shared() in the non-dioread_nolock case, I think.

Thanks for the prototype patch; I agree it's a cleaner way to go.

	       	      	    		      - Ted
