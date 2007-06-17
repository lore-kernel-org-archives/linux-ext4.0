From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: [Bugme-new] [Bug 8643] New: Bug with negative timestamps on
 64bit machines
Date: Sat, 16 Jun 2007 23:05:27 -0700
Message-ID: <20070616230527.e26f66d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbXFQGFg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jun 2007 02:05:36 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l5H65Wl9026995
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 16 Jun 2007 23:05:34 -0700
Received: from box (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id l5H65RCq029163
	for <linux-ext4@vger.kernel.org>; Sat, 16 Jun 2007 23:05:27 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


someone ort to fix this


Begin forwarded message:

Date: Sat, 16 Jun 2007 17:50:35 -0700 (PDT)
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 8643] New: Bug with negative timestamps on 64bit machines


http://bugzilla.kernel.org/show_bug.cgi?id=8643

           Summary: Bug with negative timestamps on 64bit machines
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.21-1.3228.fc7
          Platform: All
        OS/Version: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: akpm@osdl.org
        ReportedBy: markus.mottl@gmail.com


Most recent kernel where this bug did not occur:
Distribution: Fedora Core 7
Hardware Environment: AMD Athlon 64
Software Environment:
Problem Description:

Negative timestamps (i.e. before 1970) are incorrectly handled due to some
obvious 64bit issues.  They show up normally as long as the cache has not been
purged.

Steps to reproduce:

Touch a file in an ext3-file system with a negative timestamp, e.g.:

  # touch -t 196901010000 /opt/foo

Unless you have been writing a lot of data to this partition after the last
command, the next one should display the following:

  #  ls -l /opt/foo
  -rw-r--r-- 1 root root 0 1969-01-01 00:00 /opt/foo

This is still correct.  But now we purge the file system cache by unmounting
and mounting the partition again:

  # umount /opt/foo
  # mount /opt/foo

Now the timestamp will be corrupted:

  # ls -l /opt/foo 
  -rw-r--r-- 1 root root 0 2105-02-07 06:28 /opt/foo

It seems obvious that the upper 32 bits of the 64 bits representing the time
stamp get lost, which explains the above observation.

On 32bit architectures there is no such problem.  I haven't managed to
reproduce this problem with other file systems (e.g. XFS).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
