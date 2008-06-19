From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix ext4_bmap to flush the data to the disk with
	delalloc
Date: Thu, 19 Jun 2008 08:59:16 +0530
Message-ID: <20080619032916.GA7250@skywalker>
References: <1213811531-23829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1213827985.27507.98.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:42702 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbYFSD3Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 23:29:25 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5J3TKvV011777
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 08:59:20 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5J3SR38487462
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 08:58:27 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5J3TJlY023911
	for <linux-ext4@vger.kernel.org>; Thu, 19 Jun 2008 08:59:20 +0530
Content-Disposition: inline
In-Reply-To: <1213827985.27507.98.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 18, 2008 at 03:26:25PM -0700, Mingming wrote:
> 
> On Wed, 2008-06-18 at 23:22 +0530, Aneesh Kumar K.V wrote:
> > With delalloc we don't do block allocation in the write_begin/write_end.
> > So when using bmap we first need to flush data to the disk so that blocks
> > get allocated and then call generic_block_bmap.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 7035621..cfeb869 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1833,6 +1833,17 @@ sector_t ext4_bmap(struct address_space *mapping, sector_t block)
> >  	journal_t *journal;
> >  	int err;
> > 
> > +	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
> > +			test_opt(inode->i_sb, DELALLOC)) {
> > +		/*
> > +		 * With delalloc we want to sync the file
> > +		 * so that we can make sure we allocate
> > +		 * blocks for file
> > +		 */
> > +		filemap_fdatawrite(mapping);
> > +		filemap_fdatawait(mapping);
> > +	}
> > +
> 
> I would use filemap_write_and_wait(), it is essentially the same as
> above two functions, but with a little extra checking.
> 

Updated patch below

ext4: Fix ext4_bmap to flush the data to the disk with delalloc

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

With delalloc we don't do block allocation in the write_begin/write_end.
So when using bmap we first need to flush data to the disk so that blocks
get allocated and then call generic_block_bmap.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)


diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7035621..f1bd194 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1833,6 +1833,16 @@ sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	journal_t *journal;
 	int err;
 
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY) &&
+			test_opt(inode->i_sb, DELALLOC)) {
+		/*
+		 * With delalloc we want to sync the file
+		 * so that we can make sure we allocate
+		 * blocks for file
+		 */
+		filemap_write_and_wait(mapping);
+	}
+
 	if (EXT4_I(inode)->i_state & EXT4_STATE_JDATA) {
 		/*
 		 * This is a REALLY heavyweight approach, but the use of
