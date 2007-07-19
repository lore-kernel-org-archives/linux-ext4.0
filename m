From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: Why max_debt isn't used in ext4's find_group_orlov(...) ?
Date: Thu, 19 Jul 2007 20:28:20 +0530
Message-ID: <1184857100.4001.8.camel@garfield.linsyssoft.com>
References: <3d0408630707190600r3c630db8h3dcc6550e93cfb27@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yan Zheng <ukernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:54085 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938879AbXGSO5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2007 10:57:11 -0400
In-Reply-To: <3d0408630707190600r3c630db8h3dcc6550e93cfb27@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-07-19 at 21:00 +0800, Yan Zheng wrote:
> Hi all
> 
> max_debt is used in ext2's find_group_orlov .  In ext4's
> find_group_orlov, max_debt is only computed, but not used.  I wonder
> whether it's a typo,  Can anyone give me a answer? The kernel source I
> read is 2.6.22.

I think you are right, max_debt is currently unused in the current
ext3/4 code. In ext2 max_debt is used along with s_debts (in struct
ext2_sb_info) to decide inode allocations. s_debts is no longer present
in ext3/4. 

You can find the reason for removing s_debts here:
http://osdir.com/ml/file-systems.ext2.devel/2004-09/msg00027.html

Basically use of s_debts was unsafe since it performed unlocked byte
increment/decrement on words which may be being accessed simultaneously
on other CPUs and since it was a dynamic in-memory table, it required
extension during online resize which needed proper locking.

Until s_debts is added again, I think the code relating to max_debts
should be removed?


Thanks,
Kalpak.

> 
> Thanks in advance.
> 
> ----------------
> Best Regards
> 
> YZ
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
