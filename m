From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Wed, 14 Oct 2009 02:31:45 GMT
Message-ID: <200910140231.n9E2Vj87025190@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40357 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZJNCcV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 22:32:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9E2VjHA025191
	for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 02:31:45 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #43 from Theodore Tso <tytso@mit.edu>  2009-10-14 02:31:43 ---
Hmm.... what were you doing right before the crash?   It looks like you were
doing a kernel compile in /home/ich/source/linux/linux-2.6, since there were
files with a modtime of  Tue Oct 13 16:25:55 2009.   What's a funny is that
when these files were allocated, they used blocks that were apparently already
in use by other object files in that some source directory with a mod-time of
Sat Oct 10 13:51:14 2009.   Did you do a "make clean" at any time between
Saturday and Tuesday that should have deleted these files?

If so, what I would strongly recommend is to run e2fsck -f on
/dev/mapper/sda5_crypt before you mount it, each time.   What seems to be
happening is that block allocation bitmap is getting corrupted somehow.   This
is what causes the multiply claimed bitmaps.  I'm guessing the file system had
gotten corrupted already, before the this last boot session.   The trick is
catching things *before* the filesystem is badly corrupted that it gets
remounted read-only and fsck has a large amount of multiply-claimed inodes to
cleanup.   This is important for two reasons: (a) it helps us localize when the
initial file system corruption is taking place, which helps us find a
reproduction case, and (b) it reduces the chances that you'll lose data.

So the problem is that /dev/mapper/sda5_crypt is your root filesystem, and it's
using dm-crypt.  *Sigh* this actually makes life difficult, since last I
checked we can't do LVM snapshots of dm-crypt devices.   So that means you
can't use the e2croncheck script, which is what I would recommend.  (What I'm
actually doing right now is after every crash, I'm rebooting, logging in, and
running e2croncheck right after I log in.   This allows me to notice any
potential file system corruptions before it gets nasty --- the problem is I'm
not noticing the problem.)   E2croncheck is much more convenient, since I can
be doing other things while the e2fsck is running in one terminal window.   But
I suspect dm-crypt is going to make this impossible.  One thing you could do is
"tune2fs -c 1 /dev/mapper/sda5_crypt".  This will force a full check after
every single reboot.  This will slow down your reboot (fortunately ext4 is
faster at fsck times, but unfortunately sda5 appears to be a 211 GB filesystem,
and it appears to be converted from an old ext3 filesystem, so you won't see
the full 10x speedup in fsck times that you would if this was a
created-from-scratch ext4 file system), but if you do this while trying to find
the problem, it would be very helpful.

As I said, I'm still trying to reproduce the problem on my end, but it's been
hard for me to find a reproduction case.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
