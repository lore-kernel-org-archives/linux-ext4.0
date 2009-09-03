From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Thu, 03 Sep 2009 13:06:10 +0530
Message-ID: <4A9F71EA.4070406@in.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int> <20090902223011.GA30497@mit.edu> <4A9F3F7F.6030304@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49783 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZICHgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 03:36:12 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id n837aCwV021417
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:06:12 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n837aCO92183320
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:06:12 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n837aBPw008053
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 17:36:12 +1000
In-Reply-To: <4A9F3F7F.6030304@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sachin Sant wrote:
> So i have not been able to recreate this again in my last attempt.
> I will try couple of time to see if i can recreate this.
>
> The box under test is a 4 way POWER6. The disk partition (/dev/sda4)
> in question is about 19GB.
>
> fsstress was invoked with -p 50 -n 1000 -c -f dwrite=0
I have a script (thanks to Aneesh) which executes a series of
test(like fsstress, fsx-linux and resize) with various ext4 mount
options (data=journal, data=ordered, data=ordered,nodelalloc
with 1024/4096 as size). While executing the above script for the
first time i ran into this bug.

After the initial run i have rerun the tests 4 time now, but
have not been able to recreate the same issue. [Although 4th time
i ran into another issue. Will start a separate thread for that.]

As for this issue not sure how to proceed further. I probably will
continue to execute the tests few more times. Maybe will try on
a different box.

thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

