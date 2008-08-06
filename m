From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Wed, 6 Aug 2008 15:35:53 +0530
Message-ID: <20080806100553.GB31907@skywalker>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu> <20080805065217.GF9397@skywalker> <20080805132133.GA15568@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58217 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYHFKGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Aug 2008 06:06:12 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m76A5SGt030389
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:05:28 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m76A69L6249734
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:06:09 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m76A68uv009246
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:06:09 +1000
Content-Disposition: inline
In-Reply-To: <20080805132133.GA15568@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2008 at 06:51:33PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Aug 05, 2008 at 12:22:17PM +0530, Aneesh Kumar K.V wrote:
> > On Tue, Aug 05, 2008 at 02:44:28AM -0400, Theodore Tso wrote:
> > > On Mon, Aug 04, 2008 at 10:05:05PM +0530, Aneesh Kumar K.V wrote:
> > > > 
> > > > This is the complete patch that  I have. I haven't fully tested it
> > > > (right now waiting for the machine to be free). This should apply 
> > > > after stable-boundary-undo.patch
> > > 
> > > Umm... the patch doesn't apply right after the stable boundary udo
> > > patch.
> > > 
> > > 						- Ted
> > 
> > I did a fresh git pull and updated the patch. I also accumulated few
> > changes after words while testing on ABAT. Attaching both the patches
> > below. The patches apply after ext4_journal_credits_fix_for_writepages.patch
> > in the patch queue.
> 
> I still see the problem with the below changes. Now that i have read
> the writeback path more closely I am not sure how it will guarantee
> that all dirty pages of the inode are written back to disk before
> generic_sync_sb_inodes return.
> 

Below changes fixed it for me. range_start was used in the loop in
generic_sync_sb_inodes and since we were checking for !range_start
we missed restoring wbc->range_start for range_start == 0.

    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 472a6a7..ea1a8db 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2241,14 +2241,14 @@ static int ext4_da_writepages(struct address_space *mapping,
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (!wbc->range_cyclic) {
+	if (!wbc->range_cyclic)
 		/*
 		 * If range_cyclic is not set force range_cont
 		 * and save the old writeback_index
 		 */
 		wbc->range_cont = 1;
-		range_start =  wbc->range_start;
-	}
+
+	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
 restart_loop:
@@ -2322,8 +2322,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 
 out_writepages:
 	wbc->nr_to_write = to_write;
-	if (range_start)
-		wbc->range_start = range_start;
+	wbc->range_start = range_start;
 	return ret;
 }
 
