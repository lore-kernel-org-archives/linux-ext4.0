From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc and reservation.
Date: Mon, 29 Oct 2007 19:26:40 +0300
Message-ID: <472609C0.3030606@gmail.com>
References: <4725AF5B.1000300@linux.vnet.ibm.com> <4725F8E6.2050500@gmail.com>
 <4725EF33.7050804@linux.vnet.ibm.com> <4725FFF8.5060501@gmail.com>
 <4725FA1F.1090000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Valerie Clement <valerie.clement@bull.net>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:36977 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbXJ2P10 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 11:27:26 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe1.eu.sun.com [192.18.6.10])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id l9TFRLlb002536
	for <linux-ext4@vger.kernel.org>; Mon, 29 Oct 2007 15:27:21 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQO00I01I9DEB00@fe-emea-09.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Mon,
 29 Oct 2007 15:27:21 +0000 (GMT)
In-reply-to: <4725FA1F.1090000@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ah, got it now. I think the solution would be to discard preallocated blocks
once blocks for all dirty data are allocated and file is closed. In the previous
version of delalloc I did this passing NOPREALLOC hint. something similar should
be done in the newer one, I guess.

thanks, Alex

Aneesh Kumar K.V wrote:
> 
> 
> Alex Tomas wrote:
>> sorry, I don't quite understand how do you observe this with nomballoc
>>
>> thanks, Alex
>>
>> Aneesh Kumar K.V wrote:
>>> mballoc by default doesn't give the particular layout only if i force 
>>> small
>>> size to use inode preallocation i am hitting the problem. ie to 
>>> change the
>>> below line in ext4_mb_group_or_file
>>>
>>> if (ac->ac_o_ex.fe_len >= sbi->s_mb_small_req)
>>>
>>> to
>>> if (ac->ac_o_ex.fe_len <= sbi->s_mb_small_req)
>>>
>>> Do you want to test the patch with this change ?
>>>
>>> We are observing the problem with delalloc and nomballoc.
>>>
> 
> 
> As i explained in the previous mail the problem is with the the current 
> reservation code using ext4_block_alloc_info.
> 
> 
> EXT4_I(inode)->i_block_alloc_info;
> 
> Now what is happening is we are not discarding the reservation
> with respect to particular inode in case of dealloc. Without
> delalloc we discard the reservation during close(). But with
> dealloc the we are getting new reservation in the writeback
> path and we don't discard the reservation. This results
> in the files being spread across and not closely allocated
> on disk.
> BTW with your patch and the change i suggested above the problem still 
> exist.
> 
> The output is while requesting for 2 blocks
> printed by this in ext4_ext_get_blocks
> 
> printk(KERN_CRIT "allocate new block: goal %llu, found %llu/%lu\n",
>                       ar.goal, newblock, ar.len);
> 
> 
> allocate new block: goal 28672, found 12288/1
> allocate new block: goal 8192, found 12292/2
> allocate new block: goal 8192, found 12296/2
> allocate new block: goal 8192, found 12300/2
> allocate new block: goal 8192, found 12304/2
> allocate new block: goal 8192, found 12308/2
> allocate new block: goal 8192, found 12312/2
> allocate new block: goal 8192, found 12316/2
> allocate new block: goal 8192, found 1440/2
> allocate new block: goal 8192, found 1444/2
> allocate new block: goal 8192, found 1448/2
> allocate new block: goal 8192, found 1452/2
> allocate new block: goal 8192, found 1456/2
> allocate new block: goal 8192, found 1460/2
> allocate new block: goal 8192, found 1464/2
> allocate new block: goal 8192, found 1468/2
> allocate new block: goal 8192, found 12320/2
> allocate new block: goal 8192, found 12324/2
> allocate new block: goal 8192, found 12328/2
> allocate new block: goal 8192, found 12332/2
> allocate new block: goal 8192, found 12336/2
> 
> 
> with the change mballoc was not giving the problem
> described because it uses blocks from group
> preallocation.
> 
> -aneesh
> 
