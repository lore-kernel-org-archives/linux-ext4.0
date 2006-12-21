From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: EXT3 filesystem corruptions on AoE, RAID and LVM?
Date: Thu, 21 Dec 2006 14:40:34 +0100
Message-ID: <458A8ED2.2080400@tuxes.nl>
References: <45832321.4010305@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp19.wxs.nl ([195.121.247.10]:32949 "EHLO smtp19.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422891AbWLUNkn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Dec 2006 08:40:43 -0500
Received: from shrek.tuxes.nl (ip51cfc103.direct-adsl.nl [81.207.193.3])
 by smtp19.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006)) with ESMTP id
 <0JAM00KC6LZTM7@smtp19.wxs.nl> for linux-ext4@vger.kernel.org; Thu,
 21 Dec 2006 14:40:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])	by shrek.tuxes.nl (Postfix)
 with ESMTP id 1419F63C3F	for <linux-ext4@vger.kernel.org>; Thu,
 21 Dec 2006 14:40:37 +0100 (CET)
Received: from shrek.tuxes.nl ([127.0.0.1])	by localhost (shrek [127.0.0.1])
 (amavisd-new, port 10024) with ESMTP	id 12685-06 for
 <linux-ext4@vger.kernel.org>; Thu, 21 Dec 2006 14:40:27 +0100 (CET)
Received: from [192.168.10.6] (unknown [192.168.10.6])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)	by shrek.tuxes.nl (Postfix)
 with ESMTP id DCC1663C43	for <linux-ext4@vger.kernel.org>; Thu,
 21 Dec 2006 14:40:26 +0100 (CET)
In-reply-to: <45832321.4010305@tuxes.nl>
To: Linux extfs development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

Sorry for being this brutal and replying to my own post, but is there
anyone out here who might be able to help me with this problem? Or at
least help me with debugging it? Today I've discovered one other type of
inconsistency:

> # ls -la mydir
> -r-S--s-wt 1 2245250426 3397732635 32768 1929-11-11 16:54 mydir
Obviously, there are no UID 2245250426 and GID 3397732635 on my
filesystem, and this file certainly isn't created or modified on the
11th of November 1929. I cannot remove the directory, I get a
"permission denied" (being root!). Of course, I assume an fsck will
solve this problem (probably by just removing this entry from the
filesystem and attaching it to lost+found), but I keep checking my
filesystem about every five days now! And that means another 5 hours of
downtime with this special type of "cluster"...
Thanks in advance for all your thoughts!

  -- Bas


Bas van Schaik wrote:
> Hi all,
>
> I'm maintaining two clusters, with machines running a mix between Debian
> Stable with Etch-kernels to have AoE (ATA over Ethernet support).
> Machines in these clusters "export" their harddisks using AoE, and one
> machine in the cluster imports those using the kernel "aoe"-module. On
> top of those imported devices, multiple RAID5-arrays are created, and
> LVM is running on top of RAID, ext3 on the LVM LV.
>
> After a few days, I get EXT3-errors. like this:
>   
>>> EXT3-fs: mounted filesystem with ordered data mode.
>>> EXT3-fs error (device loop0): ext3_free_blocks_sb: bit already
>>>       
> cleared for block 412186
>   
>>> Aborting journal on device loop0.
>>> EXT3-fs error (device loop0) in ext3_free_blocks_sb: Journal has aborted
>>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
>>>       
> aborted
>   
>>> EXT3-fs error (device loop0) in ext3_truncate: Journal has aborted
>>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
>>>       
> aborted
>   
>>> EXT3-fs error (device loop0) in ext3_orphan_del: Journal has aborted
>>> EXT3-fs error (device loop0) in ext3_reserve_inode_write: Journal has
>>>       
> aborted
>   
>>> EXT3-fs error (device loop0) in ext3_delete_inode: Journal has aborted
>>> __journal_remove_journal_head: freeing b_committed_data
>>> __journal_remove_journal_head: freeing b_committed_data
>>>       
>
> (...)
>
>   
>>> __journal_remove_journal_head: freeing b_committed_data
>>> ext3_abort called.
>>> EXT3-fs error (device loop0): ext3_journal_start_sb: Detected aborted
>>>       
> journal
>   
>>> Remounting filesystem read-only
>>> __journal_remove_journal_head: freeing b_committed_data
>>>       
>
>
> FSCK'ing the filesystem fixes those errors, but after a few days (or
> weeks, depending on the fs load) the corruptions appear again. I might
> be worth telling you that there are no other suspicious messages in my logs.
>
> I saw some other discussions on the mailinglist, but I don't think their
> related to my problems. I don't know if I need to file a bug on this,
> neither do I know which details you need to help me solve this problem.
> So for now I just want to here your thoughts. FYI:
>
> Kernel information for cluster 1:
>   
>>> root@infinity:~# uname -a
>>> Linux infinity 2.6.17-2-686 #1 SMP Wed Sep 13 16:34:10 UTC 2006 i686
>>>       
> GNU/Linux
>
>
> And cluster 2:
>   
>>> dust:~# uname -a
>>> Linux dust 2.6.18-3-686 #1 SMP Thu Nov 23 20:49:23 UTC 2006 i686
>>>       
> GNU/Linux
>
> Note that these are not vanilla kernels, but Debian kernels. However,
> AFAIK there are no Debian-specific patches to AoE, ext3, LVM or RAID.
>
> Thanks for your replies!
>
> Best regards,
>
>   -- Bas van Schaik
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
