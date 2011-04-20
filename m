From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 2/3] ext4:Add two functions splitting an extent.
Date: Wed, 20 Apr 2011 13:52:38 -0700
Message-ID: <4DAF4796.80707@linux.vnet.ibm.com>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com> <1302759651-21222-3-git-send-email-xiaoqiangnk@gmail.com> <4DAF1635.7070406@linux.vnet.ibm.com> <2C83027B-2CAC-4599-883E-3A683411CB7E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org,
	cmm@us.ibm.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36808 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab1DTUwp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:45 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3KKWWrr003664
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 16:32:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3KKqiRD189892
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 16:52:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3KKqixH026207
	for <linux-ext4@vger.kernel.org>; Wed, 20 Apr 2011 16:52:44 -0400
In-Reply-To: <2C83027B-2CAC-4599-883E-3A683411CB7E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/20/2011 11:13 AM, Andreas Dilger wrote:
> On 2011-04-20, at 11:21 AM, Allison Henderson wrote:
>> I've been working on trying to get the punch hole patch to work with with these new changes, but it looks like some test cases are not passing at the moment, so I'm trying track down where the issues are.  I had to make some adjustments to this patch to fix one of the test cases.  Here is what I did:
>>
>> ---
>> :100644 100644 ee2dda3... c7d763d... M  fs/ext4/extents.c
>> fs/ext4/extents.c |    6 +++---
>> 1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index ee2dda3..c7d763d 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2717,12 +2717,12 @@ static int ext4_split_extent(handle_t *handle,
>>         ee_len = ext4_ext_get_actual_len(ex);
>>         uninitialized = ext4_ext_is_uninitialized(ex);
>>
>> +       flags1 = flags;
>> +       flags1 |= EXT4_GET_BLOCKS_PRE_IO;
> 
> Can you please use normal C style: "flags1 = flags | EXT4_GET_BLOCKS_PRE_IO;"
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
Hi again,

I realize after I sent the note that maybe the caller is still expected to pass EXT4_GET_BLOCKS_PRE_IO in the flags parameter if it is supposed to be used in both ext4_split_extent_at cases.  That also fixes that particular failing test case. So maybe we wont need the extra fix if that is how the code is intended to work.  In any case though, yes "flags1 = flags | EXT4_GET_BLOCKS_PRE_IO;" does seem a bit cleaner. 

Allison Henderson
