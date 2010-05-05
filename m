From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] New: zero-length files and performance degradation
Date: Wed, 5 May 2010 13:49:16 GMT
Message-ID: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54423 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057Ab0EENtT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 09:49:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o45DnHsk026385
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 May 2010 13:49:17 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910

           Summary: zero-length files and performance degradation
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32-21-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: jeanbaptiste.lallement@gmail.com
        Regression: No


Hi,

I'm raising this topic again due to the large number of users experiencing the
zero-length issue on ext4 filesystem after a system crash or power failure. We
have collected hundreds of reports from users who can no longer update their
system after a crash during or shortly after package operations due to
zero-length control script (see [1] references)

To reproduce it:
* install a fresh Ubuntu Lucid system on an ext4 filesystem, or Debian with
dpkg < 1.15.6 or Ubuntu Karmic
* install a package, wait a few seconds and simulate a crash 
$ sudo apt-get install some-package; sleep 5; sudo echo b > /proc/sysrq-trigger
* reboot
$ ls -l /var/lib/dpkg/info/some-package.* will list empty maintainer's scripts.
$ ls -l /var/cache/apt/archive/some-package.* will show the empty archive
you've just downloaded
At this stage, the package manager is unusable and the common user cannot
update anything anymore.

This behavior is observed with data=ordered and with or without the mount
option auto_da_alloc.
The problem is caused by 
1) rename which should act as a barrier with data=ordered but doesn't.
auto_da_alloc doesn't detect the replace-via-rename (at least in the case of
dpkg.)
2) file creation followed by a crash resulting in an empty file. 

To work around and mitigate this issue, in Debian and Ubuntu, the 'dpkg'
package manager has been patched to fsync extracted files (Debian dpkg 1.15.6
and Ubuntu 1.15.5.6ubuntu2)

We first added a fsync() call for each extracted file. But scattered fsyncs
resulted in a massive performance degradation during package installation
(factor 10 or more, some reported that it took over an hour to unpack a
linux-headers-* package!)
In order to reduce the I/O performance degradation, fsync calls were deferred
to serialize the write + fsync. The performance loss is now a factor 2 to 5
depending on the package.

So, we currently have the choice between filesystem corruption or major
performance loss. None of them is satisfactory. 

What is simply expected is that a file is there or not, but not something
in-between. 

[1] references:
http://bugs.debian.org/430958
http://bugs.debian.org/567089
http://bugs.debian.org/578635
https://bugs.launchpad.net/ubuntu/+bug/512096
https://bugs.launchpad.net/ubuntu/+bug/537241
https://bugs.launchpad.net/ubuntu/+bug/559915
https://bugs.launchpad.net/ubuntu/+bug/570805

-- 
: JB

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
