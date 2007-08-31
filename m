From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: jbd2_journal_commit_transaction oops
Date: Fri, 31 Aug 2007 14:51:06 +0530
Message-ID: <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
References: <46D7097F.4020501@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:34400 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbXHaJTB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Aug 2007 05:19:01 -0400
In-Reply-To: <46D7097F.4020501@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Avantika,
	From initial code review I think oops in crc32_be is caused as
bh->b_data passed to the function is NULL. Most probably something might
have gone wrong in jbd2_journal_write_metadata_buffer() making bh->data
= 0.
Does the error go away, when run without journal_checksum patch/option ?

Regards,
Girish.

On Thu, 2007-08-30 at 11:16 -0700, Avantika Mathur wrote:
> Hi Girish,
> 
> When running fsstress on an x86 machine, I hit the kernel oops below.  The ext4-patch-queue is being tested including the journal checksum patches
> I have mounted with -o delalloc,mballoc,data=writeback,journal_checksum
> 
> I did not get a chance to look in detail; but it looks like a journal issue.  Do you know what the issue might be?
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> c118ba5d
> *pdpt = 000000002560a001
> *pde = 0000000000000000
> Oops: 0000 [#1]
> SMP 
> Modules linked in:
> CPU:    1
> EIP:    0060:[<c118ba5d>]    Not tainted VLI
> EFLAGS: 00010257   (2.6.23-rc4-autokern1 #1)
> EIP is at crc32_be+0x3d/0x9c
> eax: 7e78a276   ebx: 76a2787e   ecx: 00000400   edx: 00000000
> esi: 00000000   edi: 00000000   ebp: f56e5200   esp: e61f9e90
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process kjournald2 (pid: 5388, ti=e61f8000 task=e3efc000 task.ti=e61f8000)
> Stack: ef5fffc0 00000016 c10c762d 0000055e 00000000 00000000 00001000 00000000 
>        f50e3e80 7e78a276 00000008 00000000 00000544 eb46aab4 eb46aabc 00000155 
>        f585f800 e1e1c968 00000000 eb059428 0000055e 00000000 00000000 e3efc000 
> Call Trace:
>  [<c10c762d>] jbd2_journal_commit_transaction+0x92a/0x128d
>  [<c1029e51>] autoremove_wake_function+0x0/0x33
>  [<c1029e51>] autoremove_wake_function+0x0/0x33
>  [<c10214f4>] try_to_del_timer_sync+0x42/0x48
>  [<c10ca4fd>] kjournald2+0x130/0x307
>  [<c1029e51>] autoremove_wake_function+0x0/0x33
>  [<c129171c>] __sched_text_start+0x364/0x3ff
>  [<c1029e51>] autoremove_wake_function+0x0/0x33
>  [<c10ca3cd>] kjournald2+0x0/0x307
>  [<c1029a27>] kthread+0x34/0x55
>  [<c10299f3>] kthread+0x0/0x55
>  [<c1003173>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: 42 30 d8 0f b6 c0 c1 eb 08 33 1c 85 e0 ae 2a c1 49 74 05 f6 c2 03 75 e5 83 f9 03 76 4c 89 ce 83 ea 04 83 e6 03 c1 e9 02 83 c2 04 <33> 1a 0f b6 c3 c1 eb 08 33 1c 85 e0 ae 2a c1 0f b6 c3 c1 eb 08 
> EIP: [<c118ba5d>] crc32_be+0x3d/0x9c SS:ESP 0068:e61f9e90
> -- 0:conmux-control -- time-stamp -- Aug/30/07  0:36:46 --
> -- 0:conmux-control -- time-stamp -- Aug/30/07  5:56:32 --
> (bot:conmon-payload) disconnected
> 
> 
> thanks,
> Avantika
