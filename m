From: Brian Rogers <brian@xyzw.org>
Subject: Re: e4defrag and chattr +e warnings
Date: Tue, 25 Aug 2009 23:06:57 -0700
Message-ID: <4A94D101.9050601@xyzw.org>
References: <4A93169C.7070106@xyzw.org> <20090825094832.GA16400@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:43296 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757AbZHZGGx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 02:06:53 -0400
In-Reply-To: <20090825094832.GA16400@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Aug 24, 2009 at 03:39:24PM -0700, Brian Rogers wrote:
>   
>> Hi all.
>>
>> The first time since boot that I run e4defrag on a directory of  
>> significant size, I get this warning in dmesg:
>>
>>
>> This might be happening when it hits files that don't use extents, but I  
>> haven't tried e4defrag on a single non-extents file to verify that  
>> theory. I've just so far only seen this happen when I defrag a directory  
>> where I get the "operation not supported" message.
>>
>> If I use chattr +e to migrate a file to use extents, I get this:
>>
>> [  470.400044] ------------[ cut here ]------------
>> [  470.400065] WARNING: at fs/inode.c:1210 generic_delete_inode+0x65/0x16a()
>>     
>
>
> Can you try this patch
>
> commit 832ecbfe5f3cf16916552759fbeff085992a66c4
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Tue Aug 25 15:14:11 2009 +0530
>
>     ext4: unlock the new inode before iput
>     
>     We need to unlock the new inode before iput. This patch fix the below warning.
>     
>     [  470.400044] ------------[ cut here ]------------
>     [  470.400065] WARNING: at fs/inode.c:1210 generic_delete_inode+0x65/0x16a()
>     [  470.400072] Hardware name: N/A
>     .....
>     ...
>     [  470.400353] Pid: 4451, comm: chattr Not tainted 2.6.31-rc7-red-debug #4
>     [  470.400359] Call Trace:
>     [  470.400372]  [<ffffffff81037771>] warn_slowpath_common+0x77/0x8f
>     [  470.400385]  [<ffffffff81037798>] warn_slowpath_null+0xf/0x11
>     [  470.400395]  [<ffffffff810b7f28>] generic_delete_inode+0x65/0x16a
>     [  470.400405]  [<ffffffff810b8044>] generic_drop_inode+0x17/0x1bd
>     [  470.400413]  [<ffffffff810b7083>] iput+0x61/0x65
>     [  470.400455]  [<ffffffffa003b229>] ext4_ext_migrate+0x5eb/0x66a [ext4]
>     [  470.400492]  [<ffffffffa002b1f8>] ext4_ioctl+0x340/0x756 [ext4]
>     [  470.400507]  [<ffffffff810b1a91>] vfs_ioctl+0x1d/0x82
>     [  470.400517]  [<ffffffff810b1ff0>] do_vfs_ioctl+0x483/0x4c9
>     [  470.400527]  [<ffffffff81059c30>] ? trace_hardirqs_on+0xd/0xf
>     [  470.400537]  [<ffffffff810b2087>] sys_ioctl+0x51/0x74
>     [  470.400549]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
>     [  470.400557] ---[ end trace ab85723542352dac ]---
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 313a50b..05361ad 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -618,7 +618,7 @@ err_out:
>  	tmp_inode->i_nlink = 0;
>  
>  	ext4_journal_stop(handle);
> -
> +	unlock_new_inode(tmp_inode);
>  	iput(tmp_inode);
>  
>  	return retval;
>   
That fixed the chattr-triggered warning. Thanks!

Brian

