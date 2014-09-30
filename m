From: Zlatko Calusic <zcalusic@bitsync.net>
Subject: Re: e2fsck not fixing deleted inode referenced errors?
Date: Tue, 30 Sep 2014 22:10:04 +0200
Message-ID: <542B0E1C.30800@bitsync.net>
References: <542AEED4.5050303@bitsync.net> <20140930183012.GA9942@birch.djwong.org> <542AF9B8.2090800@bitsync.net> <20140930192955.GB9942@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bitsync.net ([80.83.126.10]:43426 "EHLO bitsync.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbaI3UKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Sep 2014 16:10:13 -0400
In-Reply-To: <20140930192955.GB9942@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 30.09.2014 21:29, Darrick J. Wong wrote:

> Huh.  This looks like a normal deleted file... just to ensure we're sane,
> what's the output of:
>
> debugfs -R 'ls <7913865>' /dev/md2

  7913865  (12) .    7913864  (12) ..    7912053  (20) bumpmap.la
  7912054  (20) bumpmap.so    7912055  (20) colormod.la
  7912056  (20) colormod.so    7912057  (24) testfilter.la
  7912058  (3968) testfilter.so

> debugfs -R 'ncheck 7913865' /dev/md2

Inode	Pathname
7913865	/backup/atlas/usr/lib/x86_64-linux-gnu/imlib2/filters

>
> Hoping 7913865 -> /ext/backup/atlas/usr/lib/x86_64-linux-gnu/imlib2/filters

It is.

>
> By any chance did you save the e2fsck logs?

I'm afraid not. I was in single-user mode, it scrolled much. And later 
the log in /var/log/fsck was overwritten with clean fsck run. :(

Always thought that history of fsck logs should be kept... something 
like /var/log/syslog.

>
> Digging through the e2fsck source code, the only way an inode gets marked used
> is if i_link_count > 0 or ... badblocks thinks the inode table block is bad.
> What does this say?
>
> debugfs -R 'stat <1>' /dev/md2

Inode: 1   Type: bad type    Mode:  0000   Flags: 0x0
Generation: 0    Version: 0x00000000
User:     0   Group:     0   Size: 0
File ACL: 0    Directory ACL: 0
Links: 0   Blockcount: 0
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x4ddb7efa -- Tue May 24 11:48:42 2011
atime: 0x4ddb7efa -- Tue May 24 11:48:42 2011
mtime: 0x4ddb7efa -- Tue May 24 11:48:42 2011
Size of extra inode fields: 0
BLOCKS:

>
>> Tried to delete that directory - impossible, i/o errors. I'll try to
>> reboot now to see if anything changes...
>
> In theory we can use debugfs to clear the directory and then run e2fsck to
> clean up, but let's sanity-check the world before we resort to that. :)
>

My thought exactly. Now that you reminded me that debugfs exists, I'm 
pretty convinced I could just unlink one directory and one file with it, 
run e2fsck and maybe be done. But, if you have any other ideas in the 
meantime, let's test them first.

-- 
Zlatko

