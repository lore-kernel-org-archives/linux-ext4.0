From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 10:24:56 -0400
Message-ID: <28421.1251642296@gamaville.dokosmarshall.org>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
 <20090119113300.GC9482@skywalker>  <200908300025.48034.edt@aei.ca>
Reply-To: nicholas.dokos@hp.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nicholas.dokos@hp.com
To: Ed Tomlinson <edt@aei.ca>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753724AbZH3OZH@vger.kernel.org>
In-reply-to: Message from Ed Tomlinson <edt@aei.ca> of
 "Sun, 30 Aug 2009 00:25:47 EDT." <200908300025.48034.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

The first two pieces of information needed would be the version of e2fsprogs
that you are running (e2fsck -V) and the stat of inode 706801:

  debugfs -R 'stat <706801>' /dev/sdb3

Thanks,
Nick
