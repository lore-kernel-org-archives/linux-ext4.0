From: Sandon Van Ness <sandon@van-ness.com>
Subject: Re: Is >16TB support considered stable?
Date: Fri, 28 May 2010 19:47:41 -0700
Message-ID: <4C00804D.7010000@van-ness.com>
References: <4BFFF4D2.6020908@van-ness.com> <4C001BEC.9080906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from box.houkouonchi.jp ([208.97.140.21]:57369 "EHLO
	box.houkouonchi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0E2Cro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 22:47:44 -0400
Received: from [127.0.0.1] (houkouonchi.dreamhost.com [127.0.0.1])
	by box.houkouonchi.net (Postfix) with ESMTPA id 14F9A1211BA
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 19:47:44 -0700 (PDT)
In-Reply-To: <4C001BEC.9080906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 12:39 PM, Ric Wheeler wrote:
> On 05/28/2010 12:52 PM, Sandon Van Ness wrote:
>> I have a 36 TB (33.5276 TiB) device. I was originally planning to run
>> JFS like I am doing on my 18 TB (16.6697 TiB) partition but the
>> userspace tools for file-system creation (mkfs) on JFS do not correctly
>> create file-systems over 32 TiB. XFS is not an option for me (I have had
>> bad experiences and its too corruptible) and btrfs is too beta for me.
>> My only options thus are ext4 or JFS (limited to 32 TiB).
>>
>> I would rather not waste ~ 1TiB of space which will likely go to other
>> partitions that would normally only be 500 GiB but will now be 1.5 TiB
>> if I can and with some of my testing of ext4 I think it could be a
>> viable solution. I heard that with the pu branch 64-bit addressing
>> exists so you can successfully create/fsck>16 TiB file-systems. I did
>> read on the mailing lists that there were some problems on 32-bit
>> machine but i will only use this file-sytem on x86_64.
>>
>> So here is my question to you guys:
>>
>> Is the pu branch pretty stable? Is it stable enough to have a 33 TiB
>> file-system in the real-world and be as stable and work as well as a<16
>> TiB file-system or am I better off losing out some of my space and
>> making a 32 TiB (minus a little) JFS partition and just stick to what I
>> know works and works well?
>>    
>
> Not sure which version of XFS you had trouble with, but it is
> certainly the most stable file system for anything over 16TB....
>
> Regards,
>
> Ric
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Doing an fsck on XFS takes foerever and a ton of ram. An FSCK on my 18TB
file-system with about 7 million inodes and 15TB of data) on JFS takes
about 12 minutes on my system. Another reason is I have seen bad things
happen with XFS. A couple years ago I was using it and when the
file-system got badly fragmented i got kernel panics due to not being
able to allocate blocks or memory (it was a while back so I forget). I
spent 24 hours defraging it getting the fragmentation down from like
99.9995% to 99.2% and the problem went away. XFS seems to excessively
fragment (that horribly fragmented system was running mythtv and after
switching to JFS I see way less fragmented files).

Posts like this scare me where corruption takes out the *entire*
file-system:
http://oss.sgi.com/archives/xfs/2010-01/msg00238.html

We had 'coraid' file-servers at work that used XFS and they suffered a
problem where there was a kernel panic everytime a specific file was
accessed.

I have pretty much seen some corruption and lost files *every* single
time that I have had a loss of power or crash on an XFS and I have
pretty much never seen this on JFS.

Basically I have had and heard of *a lot* of bad experiences with XFS
and I will not use XFS under any circumstances. My choices at this point
are JFS (and have 1TiB less of data os part of the file-system that I
otherwise would have had) or ext4 if people think its stable enough.

So back to my original question. What do people think about the
stability of the pu branch right now and file-systems over 16 TiB? The
optimum solution to me would be for mkfs.jfs to get fixed to correctly
create >32 TiB file-systems but I have extreme doubts of that ever
happening soon if ever.

I would run ZFS if the linux implementation didn't suck. I have a need
for speed of DAS so the system has to run ilnux. I am actually using my
old 20x1 TB drives in an 18 TB raidz2 zfs volume as that will be NAS and
be running opensolaris.
