From: Vasily Averin <vvs@sw.ru>
Subject: Re: How Inactive may be much greather than cached?
Date: Thu, 18 Oct 2007 11:14:05 +0400
Message-ID: <471707BD.4000203@sw.ru>
References: <4716FC04.6070107@sw.ru> <200710181627.27827.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, devel@openvz.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:24271 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbXJRHOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 03:14:12 -0400
In-Reply-To: <200710181627.27827.nickpiggin@yahoo.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Nick Piggin wrote:
> Hi,
> 
> On Thursday 18 October 2007 16:24, Vasily Averin wrote:
>> Hi all,
>>
>> could anybody explain how "inactive" may be much greater than "cached"?
>> stress test (http://weather.ou.edu/~apw/projects/stress/) that writes into
>> removed files in cycle puts the node to the following state:
>>
>> MemTotal: 16401648 kB
>> MemFree: 636644 kB
>> Buffers: 1122556 kB
>> Cached: 362880 kB
>> SwapCached: 700 kB
>> Active: 1604180 kB
>> Inactive: 13609828 kB
>>
>> At the first glance memory should be freed on file closing, nobody refers
>> to file and ext3_delete_inode() truncates inode. We can see that memory is
>> go away from "cached", however could somebody explain why it become
>> "invalid" instead be freed? Who holds the references to these pages?
> 
> Buffers, swap cache, and anonymous.

But buffers and swap cache are low (1.1 Gb and 700kB in this example) and
anonymous should go away when process finished.
