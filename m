From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 02:27:11 GMT
Message-ID: <200910170227.n9H2RBMp015136@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57674 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZJQC1J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Oct 2009 22:27:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H2RBJf015137
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 02:27:11 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #70 from Holger Freyther <zecke@selfish.org>  2009-10-17 02:27:10 ---
 I have no idea if that is useful for anyone. I have done the following.

0.) use dd to create a big file
1.) install a OpenSuSE 11.1 in it using kvm
2.) change the /etc/fstab and /sbin/init
2.1) /sbin/init is doing
      mount /proc
      fsck -f /dev/hda2
      echo "press any key to continue"
      mount -oremount,rw /
      cd /source/linux-2.6
      rm -rf *
      rm -f .git/index.lock
      git checkout .
      make -j 6
      make -j 6 modules_install

3.) Use kvm to start with the disk and an external kernel '-kernel ./bzImage
-append root=/dev/hda2"
4.) During the "make -j 6" I interrupt the kernel compile.

Result every ~10th time the filesystem is left with some errors (where you have
to Y/N for fsck) after the journal recovery. The errors are lost inodes (to be
attached to lost+found), zero length inodes and such.


The benefit of using the above setup:
   - non karmic userspace (kvm still running on karmic though)
   - no dm (disk image still hosted on a dm device)
   - can copy/clone the disk image for each kernel run and use debugfs to look
at it.


I will post the next fsck log with errors and then I can upload it somewhere if
it is of any interest.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
