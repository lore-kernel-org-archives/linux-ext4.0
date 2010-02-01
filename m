From: Andreas Dilger <adilger@sun.com>
Subject: Re: What represent 646345728 bytes
Date: Mon, 01 Feb 2010 16:01:37 -0700
Message-ID: <19B707EB-100E-4B91-9D07-1921A18139BA@sun.com>
References: <20027776.19701265044015458.JavaMail.www@wsfrf1112>
 <4B67347C.3030103@redhat.com> <4B67577F.70207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: paul.chavent@fnac.net, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42920 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0BAXBn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 18:01:43 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o11N1dr2028168
	for <linux-ext4@vger.kernel.org>; Mon, 1 Feb 2010 15:01:41 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KX600B00QIINI00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 01 Feb 2010 15:01:39 -0800 (PST)
In-reply-to: <4B67577F.70207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-01, at 15:36, Eric Sandeen wrote:
> Eric Sandeen wrote:
> So uninit_bg doesn't seem to help.  (this was on 2.6.32-ish)
>>
>> some oprofiling may be in order ...
>
> Or stapping ... thanks to hints from the stap guys, using a modified  
> version of
> http://sourceware.org/systemtap/examples/profiling/fntimes.stp
> I printed out function times higher than avg and correlated to writes
> above average from the testcase (cleaned up manually a bit):
>
> 1265062212927230 function ext4_mb_load_buddy well over average time  
> (42303 vs 2)
> 1265062212927399 function ext4_mb_regular_allocator well over  
> average time (42476 vs 5495)
> 1265062212949252 function ext4_mb_mark_diskspace_used well over  
> average time (21739 vs 196)
> 1265062212949306 function ext4_mb_new_blocks well over average time  
> (64738 vs 2457)
> 1265062212949647 function ext4_ext_get_blocks well over average time  
> (65211 vs 1106)
> 1265062212949678 function ext4_get_blocks well over average time  
> (65357 vs 1844)
> 1265062212949695 function ext4_get_block well over average time  
> (65479 vs 683)
> 1265062212951284 function ext4_ind_direct_IO well over average time  
> (68891 vs 3034)
> 1265062212951299 function ext4_direct_IO well over average time  
> (68908 vs 3046)
> 1265062212951497 function ext4_file_write well over average time  
> (69437 vs 3590)
>
> 1265062212951534 size 134470144 time 69477310 avg 3601820
>
> Unfortunately under ext4_mb_load_buddy is a lot of static/inlined  
> functions
> so no more detailed info yet.
>
> But loading the buddy bitmap for a new group seems to be the big
> hitter here - I'll keep digging, or maybe Aneesh, who groks mballoc
> better than I do (I think) might have an idea.

Since these are on-demand loads, one option is when the current group  
is ~80% full submit an async read for the next group bitmap so that it  
will be in memory by the next time we need it.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

