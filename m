From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Tue, 11 Mar 2008 11:15:01 +0530
Message-ID: <20080311054501.GA7360@skywalker>
References: <20080204101228.GA1939@skywalker> <20080204163156.GC3426@duck.suse.cz> <20080305201234.GA8173@skywalker> <20080310142426.GH24873@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52655 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903AbYCKFpE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 01:45:04 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2B5j1px025288
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:15:01 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B5j1sZ1368084
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:15:01 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2B5j0Bh028261
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 05:45:01 GMT
Content-Disposition: inline
In-Reply-To: <20080310142426.GH24873@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2008 at 03:24:26PM +0100, Jan Kara wrote:
> > This one came up again when i was doing the mmap ENOSPC patch. Now the
> > current code with migrate is taking i_mutex to protech against all
> > writes. But it seems a write to a mmap area mapping a hole can still go
> > through fine. And that path cannot take i_mutex.
> > 
> > So i guess the migrate locking need to be fixed. Any suggestion ?
>   Hmm, thinking about it a bit more.  One possibility is that we could just
> use i_mutex to protect against ordinary writes, and before swapping blocks
> for extents we'd check whether some holes were not filled in the mean time.
> If yes, we can retry the migrate, or fail it and retry later.
>   Another possibility would be to make ext4 use page_mkwrite to fill in
> holes. There we could safely acquire i_mutex and be done.
> 

page_mkwrite is called with mmap_sem help and we can't take inode->i_mutex
in page_mkwrite. The DIO write have inode->i_mutex ->  mmap_sem 
locking order.

I "fixed" it by introducing i_migrate_sem

http://article.gmane.org/gmane.comp.file-systems.ext4/5402

-aneesh
