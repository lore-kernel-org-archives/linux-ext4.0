From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] Ext4: avoid multiple quota reservation when retry
	block reservation for delalloc
Date: Mon, 21 Sep 2009 16:18:02 -0700
Message-ID: <1253575082.9099.14.camel@mingming-laptop>
References: <1253551950.9099.10.camel@mingming-laptop>
	 <20090921181527.GA27777@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-iWh6UW2FC5RpiWdbggKP"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:44455 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZIUXSB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Sep 2009 19:18:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8LNGAIV006943
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 17:16:10 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8LNI4Lp217384
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 17:18:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8LNI4eg009981
	for <linux-ext4@vger.kernel.org>; Mon, 21 Sep 2009 17:18:04 -0600
In-Reply-To: <20090921181527.GA27777@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-iWh6UW2FC5RpiWdbggKP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2009-09-21 at 20:15 +0200, Jan Kara wrote:
> On Mon 21-09-09 09:52:30, Mingming wrote:
> > Ext4: release reserved quota before block reservation for delalloc retry
> > 
> > ext4_da_reserve_space() can reserve quota blocks multiple times if
> > ext4_claim_free_blocks() fail and we retry the allocation. We should
> > release the quota reservation before restarting.
> > 
> > Bug found be Jan Kara.
>             ^^ by

attached is the updated patch with this typo fixed.

> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > 
> > ---
> >  fs/ext4/inode.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6.31-rc4/fs/ext4/inode.c
> > ===================================================================
> > --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> > +++ linux-2.6.31-rc4/fs/ext4/inode.c
> > @@ -1785,11 +1785,11 @@ repeat:
> >  
> >  	if (ext4_claim_free_blocks(sbi, total)) {
> >  		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> > +		vfs_dq_release_reservation_block(inode, total);
> >  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
> >  			yield();
> >  			goto repeat;
> >  		}
> > -		vfs_dq_release_reservation_block(inode, total);
> >  		return -ENOSPC;
> >  	}
> >  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
> > 
>   The patch is fine. Acked-by: Jan Kara <jack@suse.cz>

Thanks!

> But it's certainly not the issue hit by Pavol but I'm out of ideas where
> could be a problem provided he runs with extents...
> 

I am not sure where is the problem reported by Pavol by looking at the
code either. Perhaps enable some debugging code, but I am under
impression that the system is in-use now...

Mingming

--=-iWh6UW2FC5RpiWdbggKP
Content-Disposition: attachment; filename="quota-dealloc-fix.patch"
Content-Type: text/x-patch; name="quota-dealloc-fix.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Ext4: release reserved quota when block reservation for delalloc retry

ext4_da_reserve_space() can reserve quota blocks multiple times if
ext4_claim_free_blocks() fail and we retry the allocation. We should
release the quota reservation before restarting.

Bug found by Jan Kara.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc4/fs/ext4/inode.c
===================================================================
--- linux-2.6.31-rc4.orig/fs/ext4/inode.c
+++ linux-2.6.31-rc4/fs/ext4/inode.c
@@ -1785,11 +1785,11 @@ repeat:
 
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
 		}
-		vfs_dq_release_reservation_block(inode, total);
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;

--=-iWh6UW2FC5RpiWdbggKP--

