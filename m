From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Sat, 16 Dec 2006 10:00:07 +0530
Message-ID: <20061216043007.GA10658@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com> <20061215123920.GB24572@amitarora.in.ibm.com> <20061215230225.GT5937@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	suzuki@in.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33507 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbWLPEaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Dec 2006 23:30:13 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBG4UCTN007586
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 23:30:12 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBG4UCrd203942
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 23:30:12 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBG4UCLN010576
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 23:30:12 -0500
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061215230225.GT5937@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 15, 2006 at 04:02:25PM -0700, Andreas Dilger wrote:
> On Dec 15, 2006  18:09 +0530, Amit K. Arora wrote:
> > This patch makes writing to the unitialized extent possible. A write operation on an unitialized extent *may* (depending on the relative block location in the extent and number of blocks being written) result in spliting the extent. There are three possibilities:
> > 1. The extent does not split : This will happen when the entire extent is being written to. In this case the extent will be marked "initialized" and merged (if possible) with the neighbouring extents in the tree.
> 
> This should also be true if the write is at the beginning or the end of the
> uninitialized extent and the disk allocation matches the previous or next
> extent.  The newly-written part is merged with the adjacent extent, and the
> uninitialized extent is shrunk appropriately.

You are right. And the current patch takes care of that. If the write is
at the begining of the uninitialized extent, the first extent (from the
split) will be initialized ("ex2" in this case), and we do call
try_to_merge() to merge this with the previous extent, if possible. This
scenario can be seen as ex1 == NULL && ex2 == ex && ex3 != NULL

(Please note that "ex" is the uninitialized extent, and "ex2" is
_always_ the "initialized" extent being created, whether it is on left,
right or middle of the "parent" uninitialized extent)

If the initialized extent is the second one in the split (i.e. write is
happening on the later part of the uninitialized extent), it will result
in shirinking the existing uninitialized extent and "inserting" the new
initialized extent. insert_extent() will be called in this case, which
also tries to merge the extent with the neighbouring extents (both,
towards left and right side).
The following condition will hold true in this case:
ex1 != NULL && ex2 != ex && ex3 == NULL

> 
> Doing this as a special case of #2 may result in extra tree rebalancing as
> the extra extent is added and removed repeatedly (consider the case of a
> large hole being overwritten in smaller chunks that is just at the limit
> of the number of extents in the parent block).

Yes, as I mentioned, the case #2 already handles this. I guess, I should
have been explicit about it in the description...

> 
> > 2. The extent splits in two portions : This will happen when someone is writing to any one end of the extent (i.e. not in the middle, and not to the entire extent). This will result in breaking the extent in two portions, an initialized extent (the set of blocks being written to) and an uninitialized extent (rest of the blocks in the parent extent).
> > 3. The extent is split in three parts: This occurs when someone writes in the middle of the extent. It will result into three extents, two uninitialized (at the both ends) and one initialized (in middle).
> >
> > Since the extent merge logic was getting redundant, it has been put into a new function ext4_ext_try_to_merge(). This gets called from ext4_ext_insert_extent() and ext4_ext_get_blocks(), when required.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.


Regards,
----
Amit Arora (aarora@in.ibm.com)
Linux Technology Center
IBM India
