From: Ed Tomlinson <edt@aei.ca>
Subject: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 00:25:47 -0400
Message-ID: <200908300025.48034.edt@aei.ca>
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090119113300.GC9482@skywalker>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751669AbZH3Ecb@vger.kernel.org>
In-Reply-To: <20090119113300.GC9482@skywalker>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.

My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
gentoo system and attempting to remove the xx directory from lost+found gives:

[  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
[  172.429410] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
[  172.449920] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

The above is repeatable.

How can I _really_ clean this fs?  What info is needed to help the process?

TIA,
Ed Tomlinson
