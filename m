From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Fri, 02 Mar 2007 09:16:30 -0600
Message-ID: <45E83FCE.4040008@redhat.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <45E7BE4B.5070602@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992532AbXCBPuc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Mar 2007 10:50:32 -0500
In-Reply-To: <45E7BE4B.5070602@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Badari Pulavarty wrote:
> 
> Amit K. Arora wrote:
> 
>> This is to give a heads up on few patches that we will be soon coming up
>> with. These patches implement a new system call sys_fallocate() and a
>> new inode operation "fallocate", for persistent preallocation. The new
>> system call, as Andrew suggested, will look like:
>>
>>  asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
>>
> I am wondering about return values from this syscall ? Is it supposed to 
> return the
> number of bytes allocated ? What about partial allocations ? 

If you don't have enough blocks to cover the request, you should 
probably just return -ENOSPC, not a partial allocation.

> What about 
> if the
> blocks already exists ? What would be return values in those cases ?

0 on success, other normal errors oetherwise..

If asked for a range that includes already-allocated blocks, you just 
allocate any non-allocated blocks in the range, I think.

-Eric
