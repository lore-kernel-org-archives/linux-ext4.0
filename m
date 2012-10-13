From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] New: ext3: ctime changes with no reason in 30 seconds
 after a file change
Date: Sat, 13 Oct 2012 18:07:33 +0000 (UTC)
Message-ID: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58107 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab2JMSHh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Oct 2012 14:07:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D1D420248
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:07:35 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3968A20225
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:07:34 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751

           Summary: ext3: ctime changes with no reason in 30 seconds after
                    a file change
           Product: File System
           Version: 2.5
    Kernel Version: 3.2+, maybe 3.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: pv4@bk.ru
        Regression: Yes


Created an attachment (id=83411)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=83411)
Details

I've caught an issue slightly similar to the one discussed at
http://git.661346.n2.nabble.com/BUG-Working-tree-getting-out-of-date-quot-spontaneously-quot-td3029928.html
but in my case the issueexists if mounting ext3 partition using
native ext3 module, not ext3 mode of ext4 module.

How to reproduce:
   I'm sorry I haven't found an easier way to reproduce the issue. I
   hope the issue is obvious enough for those who works on ext2/3/4
   modules to understand and fix it using the strace and stat output
   provided.
   Steps 2 and 3 are just preparations, the actual issue appears
   in step 4.
1. Have an ext3 partition mounted using the native ext3 module
   (mounting ext3 partition using ext4 module works fine but it has
   different issues so I cannot use it).
   I tested both slackware-14 (32bit) default kernel and the 3.6.1
   from www.kernel.org.
2. Download and unpack glibc-2.16.0.tar.xz from ftp.gnu.org,
   build it using ./configure --prefix=/usr && make
3. rm -rf /tmp/a && mkdir /tmp/a
4. make install_root=/tmp/a localedata/install-locales
   During this step /tmp/a/usr/lib/locale/locale-archive is created and
   modified which we have the problem with.
5. Wait until 1-2 locale names are printed to the console (it takes
   about 5 seconds) and press Ctrl+C (not pressing Ctrl+C also causes
   the issue to happed but requires much more time to finish).
6. stat /tmp/a/usr/lib/locale/locale-archive to see the current status
7. wait ~30-40 seconds
8. stat /tmp/a/usr/lib/locale/locale-archive to see the changed
   "Change time" and "Blocks"

Sometimes the issue is not reproducable. But 3 runs of steps 3-8 always
reproduce the issue for me at least once.

Affected versions:
3.2 or above (3.6.1 is still as well)
3.0 is not affected
3.1 cannot test 3.1 right now to tell you whether it's affected or not.
    If it really matters, tell me and I'll test it ASAP.

Attachment archive contents:
filesystems  : /proc/filesystems
modules      : /proc/modules
mounts       : /proc/mounts
process-list : ps auxww
stat         : stat results
strace       : strace -fo strace make install_root=/tmp/a
localedata/install-locales
tune2fs-l    : tune2fs -l
version      : /proc/version

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
