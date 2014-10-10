From: Alan Stern <stern@rowland.harvard.edu>
Subject: Does the filesystem alter file permissions?
Date: Fri, 10 Oct 2014 15:41:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1410101535100.1539-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35044 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753332AbaJJTlm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 15:41:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm getting very weird results when creating new files on ext4 
filesystems (this is on a CentOS 7 system).  The permissions are not 
what they should be.

On the / filesystem, as superuser:

[root@server ~]# umask
0000
[root@server ~]# touch a
[root@server ~]# ls -l a
-r--r----- 1 root root 0 Oct 10 11:45 a

As a normal user:

[stern@server ~]$ umask
0000
[stern@server ~]$ touch b
[stern@server ~]$ ls -l b
-rw------- 1 stern stern 0 Oct 10 11:47 b

In /boot (which is a separate ext4 filesystem):

[root@server boot]# umask
0000
[root@server boot]# touch a
[root@server boot]# ls -l a
-r--r--r--. 1 root root 0 Oct 10 15:30 a

On a tmpfs filesystem, the permissions are -rw-rw-rw-, as expected.

What causes this sort of thing, and how can I change it?

Thanks,

Alan Stern

