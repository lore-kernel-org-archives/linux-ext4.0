From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 28 Jan 2010 11:23:51 GMT
Message-ID: <201001281123.o0SBNpkv005722@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48633 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0A1LXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 06:23:52 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SBNp7b005723
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 11:23:51 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #13 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-01-28 11:23:48 ---
Reply-To: maan@systemlinux.org

On 02:53, tytso@mit.edu wrote:
> On Wed, Jan 27, 2010 at 02:06:25PM +0100, Andre Noll wrote:
> > On 11:19, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > After kill -9 of the sync run it took about 20 minutes before 
> > > it died.
> > 
> > I was seeing similar behaviour on one of our servers, and changing
> > the io scheduler to noop fixed things for me. So it seems to be an
> > issue with cfq which is somehow triggered by ext4 but not by ext3.
> > 
> > To change the IO scheduler, just execute
> > 
> > 	echo noop > /sys/block/sda/queue/scheduler
> > 
> > (replace sda if necessary).
> 
> Andre or Michael.  If switching away from cfq helps, that's
> definitely... interesting.  Given that cfq is the default scheduler, I
> definitely want to understand what might be going on here.  Are either
> if you able to run blktrace so we can get a sense of what is going on
> under the cfq and deadline/noop I/O schedulers?

Yes, I can use that machine freely for testing purposes, including
reboots. It is just our fallback server which creates hardlink-based
snapshots using rsync.

However, I have to recompile the kernel to include debugfs which is
needed by blktrace and I'd like to wait until the currently running
rsync completes before rebooting. Would you like to see the output of

    btrace /dev/mapper/...

or should I use more sophisticated command line options?

> And in both of your cases, were you using a new file system freshly
> created using mke2fs -t ext4, or was this a ext2/ext3 filesystem that
> was converted for use under ext4?

The ext4 file system was created from scratch using -O
dir_index,uninit_bg,extent, a block size of 4096 and 32768 bytes
per inode.

Thanks
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.