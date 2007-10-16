From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 16 Oct 2007 11:06:02 +0530
Message-ID: <47144DC2.9030907@linux.vnet.ibm.com>
References: <E1IheLt-0001TN-65@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:52924 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXJPFgc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2007 01:36:32 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9G5aSDP001918
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 15:36:28 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9G5e3ml285330
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 15:40:03 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9G5aDus018511
	for <linux-ext4@vger.kernel.org>; Tue, 16 Oct 2007 15:36:13 +1000
In-Reply-To: <E1IheLt-0001TN-65@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Ts'o wrote:
> 
> * ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 9 commits
>  - e2fsprogs: Add test case for undoe2fs
>  - e2fsprogs: Fix the resize inode test case
>  - e2fsprogs: Support for large inode migration.
>  - e2fsprogs: Make mke2fs use undo I/O manager.
>  - e2fsprogs: Add undoe2fs
>  - e2fsprogs: Add undo I/O manager
> 
> The undo manager is mostly OK, but the large inode migration is
> extremely unsatisfactory, given that it halves the number of inodes and
> only works if the no more than 50% of the inodes in every single block
> group is used.  As a standalone kludge it may be OK, but the right thing
> to do is to allocate more blocks for the inode table.
> 
> 

We don't do that. 

git show 9ff4bdac259a942b6e1afc49d868075d8b19463a
...

 As a part of increasing the inode size we increase the
    inode table size. We also move the used data blocks around
    and update the respective inodes to point to the new block
....

We are right now increasing the inode table size moving the data blocks around
and fixing the inodes to point to right data blocks.


-aneesh    
