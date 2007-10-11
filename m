From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Support large files
Date: Thu, 11 Oct 2007 11:50:10 +0530
Message-ID: <470DC09A.8060006@linux.vnet.ibm.com>
References: <1192079462-7830-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20071011060735.GH8122@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Takashi Sato <sho@tnes.nec.co.jp>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48518 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbXJKGVC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 02:21:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9B6KjSb004441
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:20:45 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9B6OKSR262524
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:24:20 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9B6HqLR029807
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 16:17:53 +1000
In-Reply-To: <20071011060735.GH8122@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 11, 2007  10:41 +0530, Aneesh Kumar K.V wrote:
>> This patch converts ext4_inode i_blocks to represent total
>> blocks occupied by the inode in file system block size.
>> Earlier the variable used to represent this in 512 byte
>> block size. This actually limited the total size of the file.
>>
>> This is enabled only if the incompat feature flag
>> EXT4_FEATURE_INCOMPAT_LARGE_BLOCK is set in super block
>> and the kernel is built with CONFIG_LSF.
> 
> NACK.  This must be an old version of the patch.  The major problem is
> that there is no way to incrementally enable this feature, so as soon
> as some file needs to be larger than 2TB, it means that the i_blocks
> count on EVERY file needs to be updated, or it will be incorrect.
> 
> The updated proposal was to set EXT4_HUGE_FILE_FL on the inodes that
> are using fs-blocksize for i_blocks, and if this flag is not set then
> use 512-byte i_blocks.  This allows the filesystem to be compatible
> unless there really are gigantic files.
> 

So how do we calculate ext4_max_size ? Can we do 

if CONFIG_LSF is set then consider that that i_blocks can be represented 
using file system block size ?

-aneesh
