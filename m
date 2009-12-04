From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Remove blocks from inode prealloc list on failure
Date: Fri, 4 Dec 2009 15:13:25 +0530
Message-ID: <20091204094325.GA4272@skywalker.linux.vnet.ibm.com>
References: <6601abe90912011017s41b74ed2nab4a45dc3f74825c@mail.gmail.com>
 <20091204011022.GI10985@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55377 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZLDJnk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 04:43:40 -0500
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id nB49hjGk024437
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 15:13:45 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB49hjn82895932
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 15:13:45 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB49hibr015989
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 20:43:45 +1100
Content-Disposition: inline
In-Reply-To: <20091204011022.GI10985@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 03, 2009 at 08:10:22PM -0500, tytso@mit.edu wrote:
> On Tue, Dec 01, 2009 at 10:17:02AM -0800, Curt Wohlgemuth wrote:
> > This fixes a leak of blocks in an inode prealloc list if device failures
> > cause ext4_mb_mark_diskspace_used() to fail.
> 
> I was going to say that it didn't make sense for
> ext4_discard_inode_pa() should be its own function, but maybe we need
> function that returns blocks back to the either inode *or* the group
> preallocation list?  Otherwise right now it looks like we would also
> be potentially leaking blocks from the group preallocation list in
> case of a device failure?

For group preallocation we update the group prealloc values in 
ext4_mb_release_context and we use  ac->ac_b_ex.fe_len  to find
out the count of blocks allocated. So i guess we are not going
to leak blocks from group prealloc space.

-aneesh
