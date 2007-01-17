From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Wed, 17 Jan 2007 16:33:52 -0600
Message-ID: <45AEA450.1050100@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <45AEA13B.6070606@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXAQWk0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jan 2007 17:40:26 -0500
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <45AEA13B.6070606@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
> Amit K. Arora wrote:
> 
>> Outstanding Issues:
>> ------------------
>> (1) The final interface is yet to be decided. We have the option of
>> chosing from one of these:
>> 	a> modifying posix_fallocate() in glibc
>> 	b> using fcntl
>> 	c> using ftruncate, or
>> 	d> using the ioctl interface.
>>
>>   If we go with ioctl interface, we need to chose the return
>> value from the ioctl. We should either return "0" for success and
>> errno for failure, or we should be returning number of bytes
>> preallocated.
>>
> 
> Now I am more prefer just return 0 for success. Returning the number of 
> bytes preallocated back to userspace might be helpful in the case when 
> the specified window contains blocks already being allocated, but this 
> should not be a common case.

I tend to agree; I'm not exactly sure what the "bytes/blocks allocated"
return would be useful for?  What would the caller do with this information?

Also, is ftruncate really even an option for this interface?  Wouldn't
that mean the end of sparse files?

Thanks,
-Eric
