From: Josef Bacik <jbacik@redhat.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Mon, 4 Feb 2008 10:23:16 -0500
Message-ID: <200802041023.16998.jbacik@redhat.com>
References: <20080204101228.GA1939@skywalker>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYBDPfz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2008 10:35:55 -0500
In-Reply-To: <20080204101228.GA1939@skywalker>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday 04 February 2008 5:12:28 am Aneesh Kumar K.V wrote:
> Hi,
>
> This is with the new ext3 -> ext4 migrate code added. The recently added
> lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
> on the ext3 inode during migration to prevent walking the ext3 inode
> when it is being converted to ext4 format. Also we want to avoid
> file truncation and new blocks being added while converting to ext4.
> Also we dont want to reserve large number of credits for journal.
> Any idea how to fix this ?
>

Hello,

Seems you should be taking the i_data_sem after starting the journal in 
ext4_ext_migrate.  I haven't looked at this stuff too much, but everywhere I 
see i_data_sem taken its within a journal_start/journal_stop.  Here's the 
patch.  Let me know if I'm way off btw, like I said I'm new to this :).  Thank 
you,

Josef

Index: linux-2.6/fs/ext4/migrate.c
===================================================================
--- linux-2.6.orig/fs/ext4/migrate.c
+++ linux-2.6/fs/ext4/migrate.c
@@ -414,7 +414,6 @@ int ext4_ext_migrate(struct inode *inode
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
 		return -EINVAL;
 
-	down_write(&EXT4_I(inode)->i_data_sem);
 	handle = ext4_journal_start(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
@@ -424,6 +423,9 @@ int ext4_ext_migrate(struct inode *inode
 		retval = PTR_ERR(handle);
 		goto err_out;
 	}
+
+	down_write(&EXT4_I(inode)->i_data_sem);
+
 	tmp_inode = ext4_new_inode(handle,
 				inode->i_sb->s_root->d_inode,
 				S_IFREG);
@@ -549,10 +551,10 @@ err_out:
 	 */
 	tmp_inode->i_nlink = 0;
 
-	ext4_journal_stop(handle);
-
 	up_write(&EXT4_I(inode)->i_data_sem);
 
+	ext4_journal_stop(handle);
+
 	if (tmp_inode)
 		iput(tmp_inode);
 
