From: LDB <thesource@ldb-jab.org>
Subject: Re: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 09:15:09 -0400
Message-ID: <4A9A7B5D.5000102@master.ldb-jab.org>
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090119113300.GC9482@skywalker> <200908300025.48034.edt@aei.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ed Tomlinson <edt@aei.ca>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ldb-jab.org ([209.135.157.157]:46525 "EHLO
	master.ldb-jab.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZH3Nnx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 09:43:53 -0400
In-Reply-To: <200908300025.48034.edt@aei.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ed Tomlinson wrote:
> Hi,
> 
> I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.
> 
> My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
> system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
> gentoo system and attempting to remove the xx directory from lost+found gives:
> 
> [  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> [  172.429410] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> [  172.449920] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> 
> The above is repeatable.
> 
> How can I _really_ clean this fs?  What info is needed to help the process?
> 
> TIA,
> Ed Tomlinson
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Have you tried "dumpe2fs /dev/sdb3" to determine if you can use a
different superblock number, since the problem is recurring?


LDB
