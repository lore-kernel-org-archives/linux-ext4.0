From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Thu, 03 Sep 2009 09:31:03 +0530
Message-ID: <4A9F3F7F.6030304@in.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu> <20090902210737.GV4197@webber.adilger.int> <20090902223011.GA30497@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:49118 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZICEBG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 00:01:06 -0400
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [202.81.31.246])
	by e23smtp02.au.ibm.com (8.14.3/8.13.1) with ESMTP id n833wt3j015811
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:58:55 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n833xQAx1319038
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 13:59:26 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n834158T012893
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 14:01:05 +1000
In-Reply-To: <20090902223011.GA30497@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Sep 02, 2009 at 03:07:37PM -0600, Andreas Dilger wrote:
>   
>> Given the nature of the test being run (fsstress) it seems entirely
>> possible that there is some transaction which doesn't reserve enough
>> credits for the operation in some rare corner case?
>>     
>
> That's possible, although we're running fsstress in the XFSQA tests.
>
> Sanchin, what are the parameters used when you ran fsstress, and how
> big is the partition in question?  How many CPU's are in the PowerPC
> system in question?
Hi Ted,

So i have not been able to recreate this again in my last attempt.
I will try couple of time to see if i can recreate this.

The box under test is a 4 way POWER6. The disk partition (/dev/sda4)
in question is about 19GB.

fsstress was invoked with -p 50 -n 1000 -c -f dwrite=0

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

