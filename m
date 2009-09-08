From: Sachin Sant <sachinp@in.ibm.com>
Subject: Re: EXT4: kernel BUG at fs/jbd2/commit.c:533!
Date: Tue, 08 Sep 2009 19:51:06 +0530
Message-ID: <4AA66852.8040009@in.ibm.com>
References: <4A9E5496.8050909@in.ibm.com> <20090902120958.GA16415@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51296 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZIHOVH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 10:21:07 -0400
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by e28smtp03.in.ibm.com (8.14.3/8.13.1) with ESMTP id n88EL8WM030584
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 19:51:08 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n88EL7b62318484
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 19:51:07 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n88EL78j004640
	for <linux-ext4@vger.kernel.org>; Tue, 8 Sep 2009 19:51:07 +0530
In-Reply-To: <20090902120958.GA16415@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Sep 02, 2009 at 04:48:46PM +0530, Sachin Sant wrote:
>   
>> While executing fsstress against ext4 with 2.6.31-rc8 on a
>> powerpc box, ran into the following Bug.
>>
>> ------------[ cut here ]------------
>> cpu 0x0: Vector: 700 (Program Check) at [c0000000f3ae3970]
>>    pc: c000000000280f28: .jbd2_journal_commit_transaction+0x8ac/0x1bfc
>>    lr: c000000000280e58: .jbd2_journal_commit_transaction+0x7dc/0x1bfc
>>    sp: c0000000f3ae3bf0
>>   msr: 8000000000029032
>>  current = 0xc0000000f315c7d0
>>  paca    = 0xc000000000b62600
>>    pid   = 23139, comm = kjournald2
>> kernel BUG at fs/jbd2/commit.c:533!
>>     
Let me know if there is any thing i could try to help
find a solution for this problem. After increasing the
nproc value, i am able to consistently recreate this issue.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

