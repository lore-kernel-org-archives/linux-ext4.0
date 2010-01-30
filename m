From: Andreas Dilger <adilger@sun.com>
Subject: Re: need help with getting into a corrupted sub directory
Date: Sat, 30 Jan 2010 00:24:09 -0700
Message-ID: <27FC5E2E-2F85-478A-95F2-1B9ED9D07690@sun.com>
References: <004d01caa172$8d846c10$6401a8c0@kyle>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: kyle <kylewong@southa.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36231 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0A3HYN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jan 2010 02:24:13 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0U7OAwC021588
	for <linux-ext4@vger.kernel.org>; Fri, 29 Jan 2010 23:24:10 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KX100H00TKQGM00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 29 Jan 2010 23:24:10 -0800 (PST)
In-reply-to: <004d01caa172$8d846c10$6401a8c0@kyle>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-29, at 23:07, kyle wrote:
> I have a ext3 filesystem created inside a problematic seagate  
> ST3500320AS
> drive. The drive will just shut itself down automatically whenever  
> it hits
> any read error. Only way to wake it up it to cold power off / on the
> computer.

Strange, I had to do the same for a friend, and I think it was the  
same drive.
You should put it into a USB enclosure - it speeds things up a lot.

> 'sde' will disappeared from the system, need power off / on can get  
> it back.

To get most of the data off the dying drive, use rsync -v, and create  
a list
of files to exclude, when you detect they cause the drive to die.

> After cold boot, I know there's a subdirectory called "EL" inside  
> "public",
> if I do a 'ls public/EL',
> I get:
> EXT3-fs error (device sde2): ext3_get_inode_loc: unable to read inode
> block - inode: 26181633, block=26181634
> ls: cannot access /tmp/public/EL: Input/output error
>
> Is there any way I can get into subdirectory of "public" without the  
> need of
> read inode block 26181633/26181634 ?
> Is it still possible to get a full subdirectory listing of "public" ?


debugfs is your friend.  It can open and list a directory by inode  
number, and dump the files to another filesystem.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

