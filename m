From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 07 May 2007 19:29:04 +0530
Message-ID: <463F30A8.5010601@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int> <463E9C53.8000503@linux.vnet.ibm.com> <20070507132001.GB17180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:53088 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865AbXEGN7N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 09:59:13 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l47EIiY5324904
	for <linux-ext4@vger.kernel.org>; Tue, 8 May 2007 00:18:46 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l47E2djR144984
	for <linux-ext4@vger.kernel.org>; Tue, 8 May 2007 00:02:39 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l47Dx70O014668
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 23:59:08 +1000
In-Reply-To: <20070507132001.GB17180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> 
>> That is correct. My next step is to enhance the tool to support 
>> migration to large inodes.
> 
> I would actually suggest that the place to add that functionality
> would be via "tune2fs -I <inode_size>".  Since mke2fs -I <inode_size>
> is used to set the inode size, it makes sense that tune2fs -I would
> change the inode size.  Obviously this would have to be done when the
> filesystem is not mounted, and tune2fs should abort gracefully if
> determines that the filesystem is mounted.


That is nice !!. I will  add the large inode migration support to tune2fs.

-aneesh
