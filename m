From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Fri, 15 Dec 2006 16:02:25 -0700
Message-ID: <20061215230225.GT5937@schatzie.adilger.int>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	suzuki@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:33743 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294AbWLOXC1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Dec 2006 18:02:27 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Content-Disposition: inline
In-Reply-To: <20061215123920.GB24572@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 15, 2006  18:09 +0530, Amit K. Arora wrote:
> This patch makes writing to the unitialized extent possible. A write operation on an unitialized extent *may* (depending on the relative block location in the extent and number of blocks being written) result in spliting the extent. There are three possibilities:
> 1. The extent does not split : This will happen when the entire extent is being written to. In this case the extent will be marked "initialized" and merged (if possible) with the neighbouring extents in the tree.

This should also be true if the write is at the beginning or the end of the
uninitialized extent and the disk allocation matches the previous or next
extent.  The newly-written part is merged with the adjacent extent, and the
uninitialized extent is shrunk appropriately.

Doing this as a special case of #2 may result in extra tree rebalancing as
the extra extent is added and removed repeatedly (consider the case of a
large hole being overwritten in smaller chunks that is just at the limit
of the number of extents in the parent block).

> 2. The extent splits in two portions : This will happen when someone is writing to any one end of the extent (i.e. not in the middle, and not to the entire extent). This will result in breaking the extent in two portions, an initialized extent (the set of blocks being written to) and an uninitialized extent (rest of the blocks in the parent extent).
> 3. The extent is split in three parts: This occurs when someone writes in the middle of the extent. It will result into three extents, two uninitialized (at the both ends) and one initialized (in middle).
> 
> Since the extent merge logic was getting redundant, it has been put into a new function ext4_ext_try_to_merge(). This gets called from ext4_ext_insert_extent() and ext4_ext_get_blocks(), when required.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
