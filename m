From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60676] Stat system call gives permission denied to root for
 links under a sticky bit
Date: Thu, 01 Aug 2013 15:55:00 +0000
Message-ID: <bug-60676-13602-4tfhYrgx4e@https.bugzilla.kernel.org/>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48951 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab3HAPzJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 11:55:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6AB6720115
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 15:55:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 175D4201EE
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 15:55:01 +0000 (UTC)
In-Reply-To: <bug-60676-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60676

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
On Thu, Aug 01, 2013 at 03:02:36PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> 
> If a directory has a sticky bit set, root cannot use anything that makes the
> stat system call on any of the links there.
> 
> Example:
> > $ ls -ld /tmp/
> > drwxrwxrwt 17 root root 4825088 Aug  1 10:50 /tmp/
> > $ mkdir /tmp/testdir
> > $ touch /tmp/testdir/testfile
> > $ ln -s /tmp/testdir/ /tmp/testlink
> > $ ls /tmp/testlink/
> > testfile
> > $ su
> > # ls /tmp/testlink
> ls: cannot access /tmp/testlink: Permission denied
> > # ls /tmp/testdir
> > testfile

Works for me:

<tytso.root@lambda> {/tmp}, level 2  
509# ls -aldg /tmp
0 drwxrwxrwt 18 root 1840 Aug  1 11:10 /tmp/
<tytso.root@lambda> {/tmp}, level 2  
510# stat /tmp/testdir
  File: tmp/testdir'
  Size: 60              Blocks: 0          IO Block: 4096   directory
Device: 12h/18d Inode: 3290419     Links: 2
Access: (0700/drwx------)  Uid: (15806/   tytso)   Gid: (15806/   tytso)
Access: 2013-08-01 11:10:01.141462969 -0400
Modify: 2013-08-01 11:09:53.301463057 -0400
Change: 2013-08-01 11:10:51.261462406 -0400
 Birth: -
<tytso.root@lambda> {/tmp}, level 2  
511# stat /tmp/testfile
  File: tmp/testfile' -> stdir/testfile'
  Size: 16              Blocks: 0          IO Block: 4096   symbolic link
Device: 12h/18d Inode: 3288475     Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (15806/   tytso)   Gid: (15806/   tytso)
Access: 2013-08-01 11:10:04.701462929 -0400
Modify: 2013-08-01 11:10:03.691462941 -0400
Change: 2013-08-01 11:10:03.691462941 -0400
 Birth: -
<tytso.root@lambda> {/tmp}, level 2  
512# uname -a
Linux lambda 3.11.0-rc2-00261-g316da4e #50 SMP Fri Jul 26 08:41:29 EDT 2013
x86_64 GNU/Linux
<tytso.root@lambda> {/tmp}, level 2  
513# 

I suspect you are using SELinux?  (You have a security problem.  So
you install SELinux; now you have 6+ megabytes worth of problems when
you try to decipher the SELinux policy definitions.  :-)

                                               - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
