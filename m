From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 16:39:49 -0600
Message-ID: <45E75635.3070103@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>	 <20070225022326.137b4875.akpm@linux-foundation.org>	 <20070301183445.GA7911@amitarora.in.ibm.com>	 <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: nscott@aconex.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXCAWkl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2007 17:40:41 -0500
In-Reply-To: <1172788855.26078.294.camel@edge>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nathan Scott wrote:
> On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
>> On Fri, 2 Mar 2007 00:04:45 +0530
>> "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
>>
>>> This is to give a heads up on few patches that we will be soon coming up
>>> with. These patches implement a new system call sys_fallocate() and a
>>> new inode operation "fallocate", for persistent preallocation. The new
>>> system call, as Andrew suggested, will look like:
>>>
>>>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>> ...
>>
>> I'd agree with Eric on the "command" flag extension.
> 
> Seems like a separate syscall would be better, "command" sounds
> a bit ioctl like, especially if that command is passed into the
> filesystems..
> 
> cheers.
> 

I'm fine with that too, I'd just like the functionality :)

-Eric
