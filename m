From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Add EXT4_IOC_MIGRATE ioctl
Date: Tue, 12 Jun 2007 15:21:15 +0530
Message-ID: <466E6C93.2070205@linux.vnet.ibm.com>
References: <20070612064757.GA12991@skywalker.home.org> <20070612092429.GK5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Takashi Sato <sho@tnes.nec.co.jp>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:34859 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXFLJwF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 05:52:05 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5CADK8k172092
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 20:13:20 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5C9tQV7038548
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 19:55:27 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5C9pXqt018363
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 19:51:44 +1000
In-Reply-To: <20070612092429.GK5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Jun 12, 2007  12:17 +0530, Aneesh Kumar K.V wrote:
>> The below patch add ioctl for migrating ext3 indirect block mapped inode
>> to ext4 extent mapped inode.
> 
> How does this relate to the migrate ioctl used by Takashi in the current
> ext4 defragmenter patch series?  

You mean EXT4_IOC_DEFRAG ?.  I guess the last version of defragmentation 
patches (ver4) handled only extent mapped inode.


Ideally, the code shouldn't really care
> whether it is migrating from/to a block-mapped or extent-mapped file.
> 
>

As per the last discussion with Takashi the defragmentation is going to 
work on extent mapped file only. The plan right now is to convert a 
block mapped inode to extent mapped inode and then defrag. Later we 
update the user space tool to issue two ioctl if the user wanted to 
defrag a block mapped inode. There will also be a separate command line 
option to just migrate.


-aneesh
