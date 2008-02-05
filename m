From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Tue, 5 Feb 2008 21:57:03 +0530
Message-ID: <20080205162703.GD7038@skywalker>
References: <20080204101228.GA1939@skywalker> <20080204163156.GC3426@duck.suse.cz> <20080205122342.GC7038@skywalker> <20080205134228.GA25464@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52841 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754870AbYBEQ1I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 11:27:08 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m15GR5XS002781
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 21:57:05 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m15GR5KY1146946
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 21:57:05 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m15GR8rH015965
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 16:27:09 GMT
Content-Disposition: inline
In-Reply-To: <20080205134228.GA25464@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 05, 2008 at 02:42:28PM +0100, Jan Kara wrote:
> On Tue 05-02-08 17:53:42, Aneesh Kumar K.V wrote:
> > 
> > How about the patch below. I did the below testing
> > a) migrate a file
> > b) run fs_inode fsstres fsx_linux.
> > 
> > The intention was to find out whether the new locking is breaking any of
> > the other expected hierarchy. It seems to fine. I didn't get any lockdep
> > warning.
>   I think there's a problem in the patch. I don't think you can call
> free_ind_block() while readers are accessing the file. That could make them
> think the file contains holes when they aren't there (or even worse read
> freed blocks or so). So you need to lock i_data_sem before this call (that
> means you have to move journal_extend() as well). Actually, I don't quite
> get why ext4_journal_extend() is called in that function. You can just
> count with the 1 credit in ext4_ext_migrate() when you call
> ext4_journal_extend() before calling ext4_ext_swap_inode_data(). Oh,
> probably because free_ind_block() could extend the transaction (which they
> don't do now as far as I can see).

ext4_journal_extend is called to extend the journal by one credit to
take care of writing the block containing inode. I moved the journal
extend before taking i_data_sem lock.

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index f97c993..dc6617a 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -302,10 +302,6 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
 
-	retval = free_ind_block(handle, inode);
-	if (retval)
-		goto err_out;
-
 	/*
 	 * One credit accounted for writing the
 	 * i_data field of the original inode
@@ -318,6 +314,10 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
+	retval = free_ind_block(handle, inode);
+	if (retval)
+		goto err_out;
+
 	/*
 	 * We have the extent map build with the tmp inode.
 	 * Now copy the i_data across

The above change also make sure we don't fail after we free the indirect
blocks.


>   BTW: That freeing code should really take into account that it can modify
> bitmaps in different block groups. It's even not that hard to do. Just
> before each ext4_free_blocks() in free_ind_block() you check whether you
> have still enough credits in the handle (use h_buffer_credits) and if not,
> extend it by some amount.


I have a FIXME at migrate.c:524 documenting exactly that. The
difficult question was by how much we should extent the journal. ? But
in reality we might have accumulated enough journal credits, I never
really ran across a case where we are running out of the journal credit.


>   Maybe you could do some test like writing a big file with some data and then
> while migration is running read it in a loop and compare that MD5SUM is the
> same all the time. Also run some memory-pressure during this test so that
> data blocks aren't cached for the whole time of the test... That should
> reasonably stress the migration code.

I have tested migrate by booting with mem= and doing parallel
read/write and migrate. I didn't do the MDSUM compare. Will do that this
time.


Thanks for all the help with review.
-aneesh
> 
