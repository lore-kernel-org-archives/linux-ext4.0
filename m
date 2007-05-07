From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 07 May 2007 08:56:11 +0530
Message-ID: <463E9C53.8000503@linux.vnet.ibm.com>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:64324 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXEGD0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 May 2007 23:26:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l473jnMA297356
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:45:51 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l473TjGe171636
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:29:45 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l473QE9e026721
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 13:26:14 +1000
In-Reply-To: <20070506051759.GP6220@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On May 04, 2007  14:43 +0530, Aneesh Kumar K.V wrote:
>> Changes from from my previous patches are as follows:
>> a) support for files with holes
>> b) use the block iterator present in libext2fs
>> c) don't mark  the indirect blocks as unused early. If we mark the
>>    the blocks unused, they can be resued for extent index. If we later
>>    fail to migrate, the indirect blocks content would be overwritten.
> 
> If this code could also (or optionally just) increase the size of inodes
> it would be very useful.  AFAIK right now it will only change the inodes
> from block-mapped to extent-mapped?
> 
> 

That is correct. My next step is to enhance the tool to support 
migration to large inodes.

-aneesh
