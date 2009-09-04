From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Fri, 04 Sep 2009 13:53:06 +0530
Message-ID: <4AA0CE6A.1020000@in.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int> <20090902223011.GA30497@mit.edu> <4A9F3F7F.6030304@in.ibm.com> <4A9F71EA.4070406@in.ibm.com> <4AA09ED6.3050007@in.ibm.com> <20090904080254.GA19757@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36576 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZIDIXH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 04:23:07 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp04.au.ibm.com (8.14.3/8.13.1) with ESMTP id n848KLkm022446
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:20:21 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n848LNUd888836
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:21:23 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n848N738025939
	for <linux-ext4@vger.kernel.org>; Fri, 4 Sep 2009 18:23:08 +1000
In-Reply-To: <20090904080254.GA19757@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Can you find the below info
>
> a) blocksize with which the file system was created
>   
/usr/local/e2fsprogs/sbin/mkfs.ext4 -b 4096 /dev/sda4

> b) I guess the file system was in data=journal mode (looking at the dmesg output)
>   
Yes.
mount -t ext4 -o errors=panic,data=journal /dev/sda4 /mnt/tmp/

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

