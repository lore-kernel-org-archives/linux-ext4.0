From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: delayed allocatiou result in Oops
Date: Wed, 20 Jun 2007 16:46:10 -0700
Message-ID: <1182383170.22978.11.camel@localhost.localdomain>
References: <20070614072352.GA6517@localhost.sw.ru>
	 <4672202C.4080304@clusterfs.com>
	 <1181949368.3808.7.camel@dyn9047017103.beaverton.ibm.com>
	 <20070616081426.GB14349@localhost.sw.ru>
	 <1182214878.3711.21.camel@dyn9047017103.beaverton.ibm.com>
	 <46778186.9030306@clusterfs.com>
	 <1182270229.4113.8.camel@dyn9047017103.beaverton.ibm.com>
	 <4678E20D.6060108@clusterfs.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>, linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46051 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXFTXqN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 19:46:13 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5KNkCSP028276
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 19:46:12 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5KNkC35551716
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 19:46:12 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5KNkCif004997
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 19:46:12 -0400
In-Reply-To: <4678E20D.6060108@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-06-20 at 12:15 +0400, Alex Tomas wrote:
> Mingming Cao wrote:
> > Hmm, PageMappedToDisk is probably not sufficient enough for pagesize!
> > =blocksize. Is that the reason we need page->private to pass the
> > request?
> 
> PageMappedToDisk isn't enough in that case, definitely. bh is the way
> to track state of each block (this is what i'm implementing now), but
> I think current nobh version (per-page flags are used) is valuable.
> 
> > That's good to know, thanks for the update. So probably above error case
> > handling will be addressed in the new version? 
> 
> well, you actually can move that SetPagePrivate() few lines above
> (Dmitriy already tested this).

Like this?

Index: linux-2.6.22-rc5/fs/ext4/writeback.c
===================================================================
--- linux-2.6.22-rc5.orig/fs/ext4/writeback.c	2007-06-20 16:41:26.000000000 -0700
+++ linux-2.6.22-rc5/fs/ext4/writeback.c	2007-06-20 16:44:10.000000000 -0700
@@ -918,16 +918,16 @@ int ext4_wb_commit_write(struct file *fi
 	wb_debug("commit page %lu (%u-%u) for inode %lu\n",
 			page->index, from, to, inode->i_ino);
 
-	/* mark page private so that we get
-	 * called to invalidate/release page */
-	SetPagePrivate(page);
-
 	if (!PageBooked(page) && !PageMappedToDisk(page)) {
 		/* ->prepare_write() observed that block for this
 		 * page hasn't been allocated yet. there fore it
 		 * asked to reserve block for later allocation */
 		BUG_ON(page->private == 0);
 		page->private = 0;
+		/* mark page private so that we get
+		 * called to invalidate/release page */
+		SetPagePrivate(page);
+
 		err = ext4_wb_reserve_space_page(page, 1);
 		if (err)
 			return err;
