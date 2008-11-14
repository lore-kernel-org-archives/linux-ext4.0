From: Kelly Kane <kelly@hq.newdream.net>
Subject: Re: Call traces on console from a test machine
Date: Thu, 13 Nov 2008 18:16:48 -0800
Message-ID: <491CDF90.8070802@hq.newdream.net>
References: <491CC6E3.7070808@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.hq.newdream.net ([66.33.206.127]:50115 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYKNCR1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 21:17:27 -0500
Received: from ip-10-0-1-185.dreamhost.com (ip-66-33-206-8.dreamhost.com [66.33.206.8])
	by mail.hq.newdream.net (Postfix) with ESMTP id A3F01244A7
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 18:18:24 -0800 (PST)
In-Reply-To: <491CC6E3.7070808@hq.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kelly Kane wrote:
> 
> This is a vanilla 2.6.27 kernel + grsec + "2.6.27-ext4-2" patchset + the 
> following patch per Sandeen:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3c37fc86d20fe35be656f070997d62f75c2e4874;hp=8c9fa93d51123c5540762b1a9e1919d6f9c4af7c 
> 

I applied patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8c3f25d8950c3e9fe6c9849f88679b3f2a071550#patch1

and built a new kernel.

In the mean time, fsck.ext4 is not liking our filesystem.

Group descriptor 353 checksum is invalid.  Fix? yes
Pass 2: CheckingEntry 'spice-and-wolf-si-tendra-segunda-temporada' in
 
/liamsito1234/cibercomics.com/wp-content/cache/supercache/www.cibercomics.com/2008/10/05 
(2152305) references inode
                2901322 in group 354 where _INODE_UNINIT is set.
Entry 'spice-and-wolf-si-tendra-segunda-temporada' in
 
/liamsito1234/cibercomics.com/wp-content/cache/supercache/www.cibercomics.com/2008/10/05 
(2152305) has
                deleted/unused inode 2901322.  Clear? yes
/dev/sdb1: e2fsck canceled.
e2fsck: aborted

Same block group each run through, different inode.

I ran e2image and produced the following file:

http://ext4dev.dreamhosters.com/watanabe-home-2008-11-13-1712.e2image.bz2

Unfortunately I cannot mount the filesystem right now due to:

EXT4-fs: ext4_check_descriptors: Checksum for group 353 failed 
(23397!=52411)
EXT4-fs: group descriptors corrupted!
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
        missing codepage or other error       In some cases useful info 
is found in syslog - try
        dmesg | tail  or so

Is there any hope for recovery of any of this data?


Also, to append my prior email, this is the original error from the machine:

Nov 13 15:58:49 watanabe EXT4-fs error (device sdb1): 
htree_dirblock_to_tree: bad entry in directory #51577: rec_len % 4 != 0 
- offset=0, inode=943022112, rec_len=13614, name_len=52
Nov 13 15:58:49 watanabe Aborting journal on device sdb1:8.
Nov 13 15:58:49 watanabe Remounting filesystem read-only


Kelly

