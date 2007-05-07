From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 07 May 2007 19:16:31 +0530
Message-ID: <463F2DB7.6090507@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int> <463E9C53.8000503@linux.vnet.ibm.com> <20070507132001.GB17180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51092 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbXEGNqj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 09:46:39 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l47E6BqK317724
	for <linux-ext4@vger.kernel.org>; Tue, 8 May 2007 00:06:11 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47Do6Jn165876
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 23:50:06 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47DkY5D004471
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 23:46:34 +1000
In-Reply-To: <20070507132001.GB17180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Theodore Tso wrote:
> On Mon, May 07, 2007 at 08:56:11AM +0530, Aneesh Kumar K.V wrote:
>> Andreas Dilger wrote:
>>> If this code could also (or optionally just) increase the size of inodes
>>> it would be very useful.  AFAIK right now it will only change the inodes
>> >from block-mapped to extent-mapped?
> 
> Actually, changing the inode size is actually going to be more useful
> to a larger number of people, since they can use it today to support
> in-inode EA's.  In addition, changing the inode size must be done
> off-line, whereas it's not so clear that off-line conversion to
> extents is the best way to go (more on that below).
> 


One of the option i was thinking was to use this tool to migrate to 
extent map and then towards the end use the online defrag ioctl to 
defrag the resulting ext4 inode.

That way we don't need to add kernel code that convert ext3 inode to 
ext4 inode while defragmentation. Last time i looked at the online 
defrag code, i was not able to figure out a easy way to take indirect 
map inode as input, then defrag the same and write the result in extent 
map.


-aneesh
