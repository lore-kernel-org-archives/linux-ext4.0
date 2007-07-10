From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [PATHC] Fix for ext2 reservation (Re: -mm merge plans for 2.6.23)
Date: Tue, 10 Jul 2007 15:15:57 -0700
Message-ID: <1184105757.8390.6.camel@dyn9047017100.beaverton.ibm.com>
References: <20070710113704.8b20f3c3.akpm@linux-foundation.org>
	 <4693E07E.4010300@mbligh.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hugh@veritas.com>,
	Jeremy Orlow <jorlow@google.com>,
	Nick Piggin <piggin@cyberone.com.au>,
	Mingming Cao <cmm@us.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>,
	ltc-kernel <ltc-kernel@linux.ibm.com>, stable@kernel.org
To: Martin Bligh <mbligh@mbligh.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52337 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbXGJWO2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jul 2007 18:14:28 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AMER45017805
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 18:14:27 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AMEIvF209380
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 16:14:20 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AMEFJX019222
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 16:14:18 -0600
In-Reply-To: <4693E07E.4010300@mbligh.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-07-10 at 12:39 -0700, Martin Bligh wrote:
> Andrew Morton wrote:
> > 
> > Begin forwarded message:
> > 
> > Date: Tue, 10 Jul 2007 21:49:23 +0400
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > To: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
> > Subject: ext2 reservations (Re: -mm merge plans for 2.6.23)
> > 
> > 
> >> ext2-reservations.patch
> >>
> >>  Still needs decent testing.
> > 
> > Was this oops silently fixed?
> > http://lkml.org/lkml/2007/3/2/138
> > 2.6.21-rc2-mm1: EIP is at ext2_discard_reservation+0x1c/0x52
> > 
> > I still have that ext2 partition backed up.
> 
> Now I'm confused - I thought there was a latent issue there, and
> then we went back and revisited it, and we decided there wasn't ;-(

Well, I looked at the problem now and here is the fix :)

Greg, Please consider this for stable release also.

Thanks,
Badari

ext2 reservation fix - Alexey Dobriyan reported ext2 discard
reservation panic while ago (http://lkml.org/lkml/2007/3/2/138).
If ext2_new_inode() fails for any reason it would end up calling 
ext2_discard_reservation() (due to last iput). Normally, it does
nothing since we don't have a reservation window structure
allocated. But the NULL pointer check wouldn't work with  slab 
poisioning, and causes oops.

Fix is to initialize i_block_alloc_info to NULL in ext2_alloc_inode()
code instead of assuming that it would be NULL. Same fix already
exists in ext3 and ext4.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

 fs/ext2/super.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/fs/ext2/super.c
===================================================================
--- linux-2.6.22.orig/fs/ext2/super.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/fs/ext2/super.c	2007-07-10 16:36:42.000000000 -0700
@@ -147,6 +147,7 @@ static struct inode *ext2_alloc_inode(st
 	ei->i_acl = EXT2_ACL_NOT_CACHED;
 	ei->i_default_acl = EXT2_ACL_NOT_CACHED;
 #endif
+	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
 	return &ei->vfs_inode;
 }
