From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Large buffer cache in EXT4
Date: Mon, 18 Feb 2013 09:22:57 -0600
Message-ID: <51224751.3020002@redhat.com>
References: <CAEUQcegw=gq9ndo=Zd4xC2gJDZrRzNpS2hAZW9x5Lh=KL_YDHQ@mail.gmail.com> <6F61E227-A6F7-4AD6-9B9C-39E9E9EAABFA@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Subranshu Patel <spatel.ml@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3BRPW7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Feb 2013 10:22:59 -0500
In-Reply-To: <6F61E227-A6F7-4AD6-9B9C-39E9E9EAABFA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/17/13 12:28 AM, Andreas Dilger wrote:
> On 2013-02-16, at 21:04, Subranshu Patel <spatel.ml@gmail.com> wrote:
> 
>> I created 2 filesystem on my system (RHEL 6.3, kernel version 2.6.32)
>> - XFS and EXT4 and mounted them.
>>
>> On both the filesystem I executed the mdtest tool(opensource tool) for
>> 64 concurrent process. Each process performed the following:
>> - Create large number of directories
>> - Remove all the directories
>>
>> During this time I monitored the memory usage of the system using sar
>> command. I checked the 3 components - kbmemused, kbbuffers and
>> kbcached
>>
>> kbmemused - Amount of used memory in kilobytes. This does not take
>> into account memory used by the kernel itself.
>> kbbuffers - buffer cache
>> kbcached - page cache
>>
>> While the kbmemused and kbcached component was almost similar in EXT4
>> and XFS (XFS being a little higher), the kbbuffer showed a totally
>> different trend.
>>
>> For EXT4, kbbuffers was:
>> 390999KB for dir creation
>> 364803KB for dir removal
>> For XFS, kbbuffers was:
>>
>> 1701KB for dir creation
>> 2738KB for dir removal
>>
>> In kernel 2.6, both buffer cache and page cache are merged. The page
>> cache caches pages of files. The buffer cache caches disk blocks which
>> consists of mainly metadata (not file data).
>>
>> Why is the buffer cache large in case of EXT4 and what is stored in
>> the buffer cache?
> 
> XFS does not use buffer cache, while ext[234] does use buffer cache. 
> 
> This is just a different code design. Ext4 uses the buffer cache to track metadata for journaling. 

Use slabtop or similar to see what xfs slab caches grow during the test; look at xfs_buf for example.

-Eric
