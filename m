From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] NULL pointer when make_indexed_dir returns -ENOSPC
Date: Sun, 15 May 2011 08:05:05 -0700
Message-ID: <4DCFEBA1.8060506@linux.vnet.ibm.com>
References: <4DCC1FF8.6040103@linux.vnet.ibm.com> <20110515042108.GJ21165@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43596 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab1EOPFQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 May 2011 11:05:16 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4FEgBps027547
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 10:42:11 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4FF5FWb108740
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 11:05:15 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4FF5FUh016949
	for <linux-ext4@vger.kernel.org>; Sun, 15 May 2011 11:05:15 -0400
In-Reply-To: <20110515042108.GJ21165@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/14/2011 9:21 PM, Ted Ts'o wrote:
> On Thu, May 12, 2011 at 10:59:20AM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> I wasnt sure if people were expecting a v2 for this one, but I
>> noticed the modified version of v1 was removed from the tree, so I
>> am assuming we needed v2?  This one handles marking the buffer dirty
>> before calling do split to avoid the null pointer.  It introduces a
>> little overhead, but the only other option would be to introduce a
>> new flag set to do_split.  But if there's any one that would prefer
>> the flags to this solution, please let me know.  Thx! :)
>>
>> Allison Henderson
>>
>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>
> Applied, thanks.  In the future, I'd appreciate it if you resent the
> patch with a formal commit description.  I recreated the commit
> description from the older patch in this case.
>
> 	    	     	   	    	 - Ted

Thanks Ted.  Sorry about the description, I think I have another small 
patch out there like that.  I will send out an update.  Thx!

Allison Henderson

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

