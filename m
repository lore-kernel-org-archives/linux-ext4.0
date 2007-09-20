From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Thu, 20 Sep 2007 16:22:08 -0700
Message-ID: <20070920162208.17f96f78.akpm@linux-foundation.org>
References: <46F06C7B.20308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXITXWh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 19:22:37 -0400
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 18 Sep 2007 17:25:31 -0700
Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:

> In pass1 of e2fsck, every inode table in the fileystem is scanned and checked, 
> regardless of whether it is in use.  This is this the most time consuming part 
> of the filesystem check.  The unintialized block group feature can greatly 
> reduce e2fsck time by eliminating checking of uninitialized inodes.  
> 
> With this feature, there is a a high water mark of used inodes for each block 
> group.  Block and inode bitmaps can be uninitialized on disk via a flag in the
> group descriptor to avoid reading or scanning them at e2fsck time.  A checksum
> of each group descriptor is used to ensure that corruption in the group
> descriptor's bit flags does not cause incorrect operation.

This needed a few fixups due to conflicts with
ext2-ext3-ext4-add-block-bitmap-validation.patch but they were pretty
straightforward.  Please check that the result is OK.
