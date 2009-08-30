From: Ed Tomlinson <edt@aei.ca>
Subject: Re: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 19:19:55 -0400
Message-ID: <200908301919.56608.edt@aei.ca>
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <200908300025.48034.edt@aei.ca> <28421.1251642296@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: nicholas.dokos@hp.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:36770 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbZH3XT5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 19:19:57 -0400
In-Reply-To: <28421.1251642296@gamaville.dokosmarshall.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday 30 August 2009 10:24:56 Nick Dokos wrote:
> > Hi,
> > 
> > I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.
> > 
> > My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
> > system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
> > gentoo system and attempting to remove the xx directory from lost+found gives:
> > 
> > [  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> > [  172.429410] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> > [  172.449920] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> > 
> > The above is repeatable.
> > 
> > How can I _really_ clean this fs?  What info is needed to help the process?
> > 
> 
> The first two pieces of information needed would be the version of e2fsprogs
> that you are running (e2fsck -V) and the stat of inode 706801:
> 
>   debugfs -R 'stat <706801>' /dev/sdb3
> 

e2fsck 1.41.9 (22-Aug-2009)
        Using EXT2FS Library version 1.41.9, 22-Aug-2009

Inode: 706801   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 28075061    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 1442
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4a8beb6a:a8c2e6e4 -- Wed Aug 19 08:09:14 2009
 atime: 0x4a8beb6a:00000000 -- Wed Aug 19 08:09:14 2009
 mtime: 0x4a8b17d9:00000000 -- Tue Aug 18 17:06:33 2009
crtime: 0x4a8beb6a:9e456724 -- Wed Aug 19 08:09:14 2009
Size of extra inode fields: 28
EXTENTS:

and of 76804 which also has a problem

Inode: 706804   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 4140131203    Version: 0x00000000:00000001
User:  1000   Group:   100   Size: 523
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4a95c957:348db0b8 -- Wed Aug 26 19:46:31 2009
 atime: 0x4a991f2b:cf3a606c -- Sat Aug 29 08:29:31 2009
 mtime: 0x4a95c957:348db0b8 -- Wed Aug 26 19:46:31 2009
crtime: 0x4a95c957:348db0b8 -- Wed Aug 26 19:46:31 2009
Size of extra inode fields: 28
EXTENTS:

Hope this helps
Ed
