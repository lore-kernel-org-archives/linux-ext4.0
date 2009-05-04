From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 2/2] ext4: Use -1 as the fake block number for
	delayed new buffer_head
Date: Mon, 4 May 2009 14:24:23 +0530
Message-ID: <20090504085423.GA12391@skywalker>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090429153521.GC14264@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:53868 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZEDIy1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 04:54:27 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id n448sPfX007202
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 14:24:25 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n448sP5N614536
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 14:24:25 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n448sOp0029738
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 18:54:25 +1000
Content-Disposition: inline
In-Reply-To: <20090429153521.GC14264@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 29, 2009 at 11:35:21AM -0400, Theodore Tso wrote:
> On Wed, Apr 29, 2009 at 10:17:21AM +0530, Aneesh Kumar K.V wrote:
> > Block number '0' should not be used as the fake block number for
> > the delayed new buffer. This will result in vfs calling umap_underlying_metadata for
> > block number '0'. So  use -1 instead.
> 
> sector_t is an unsigned type, so we probably want to use ~0 instead of
> -1.  I can fix this up before we apply into the patch queue.
> 
> Are we agreed both of these should probably be pushed to Linus for
> 2.6.30?
> 

With ABAT I am seeing the below error during fsstress run.

EXT4-fs: mounted filesystem sdb1 with ordered data mode
attempt to access beyond end of device
sdb1: rw=1, want=0, limit=136713087
Buffer I/O error on device sdb1, logical block 18446744073709551615
lost page write due to I/O error on sdb1
attempt to access beyond end of device
sdb1: rw=1, want=0, limit=136713087
Buffer I/O error on device sdb1, logical block 18446744073709551615
lost page write due to I/O error on sdb1
attempt to access beyond end of device
sdb1: rw=1, want=0, limit=136713087
Buffer I/O error on device sdb1, logical block 18446744073709551615
lost page write due to I/O error on sdb1
attempt to access beyond end of device
sdb1: rw=1, want=0, limit=136713087


That is the logical block number ~0. Well that would imply we are trying
to write the buffer_head which is marked delay.


-aneesh
