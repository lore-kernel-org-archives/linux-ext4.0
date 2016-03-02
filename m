From: Benjamin LaHaise <bcrl@kvack.org>
Subject: ext4 bug: getdents uninterruptible for 117 seconds
Date: Wed, 2 Mar 2016 12:15:11 -0500
Message-ID: <20160302171511.GM12913@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:33320 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbcCBRPM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Mar 2016 12:15:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi folks,

While working on a bug involving write starvation, the test I was running 
managed to trigger some pretty horrific worst case behaviour in ext4.  The 
filesystem I'm working on is about 4TB in size, and is used for storing a 
number of spool files across 100 subdirectories in the filesystem.  One of 
these subdirectories ended up growing to ~497MB in size.  Once all of the 
files were removed from these directories, the filesystem was unmounted.  
On subsequent mounts of the filesystem, it became apparent that whenever 
a specific directory was accessed using ls or find, the kernel would block 
in getdents() for north of 117 seconds.  It is clear that ext4 is slowly 
reading the entire contents of the directory into memory during this time 
at a rate of ~4MB/s.  This filesystem is being stored on an external 8Gbps 
FC SAN comprised of about 8 x 10Krpm spindles.

I've placed a copy of the e2image for the filesystem at 
http://www.kvack.org/~bcrl/ext4/ext4-readdir.img.xz .  The problematic 
directory is broken/1.  The relevant snippet of strace output is below.  
Thoughts?

		-ben

write(1, "/mnt/broken/"..., 34) = 34 <0.000039>
openat(5, "1", O_RDONLY|O_NOCTTY|O_NONBLOCK|O_DIRECTORY|O_NOFOLLOW) = 6 <0.000007>
fcntl(6, F_GETFD)                       = 0 <0.000004>
fcntl(6, F_SETFD, FD_CLOEXEC)           = 0 <0.000004>
fstat(6, {st_mode=S_IFDIR|0755, st_size=520896512, ...}) = 0 <0.000004>
fcntl(6, F_GETFL)                       = 0x38800 (flags O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_NOFOLLOW) <0.000004>
fcntl(6, F_SETFD, FD_CLOEXEC)           = 0 <0.000004>
newfstatat(5, "1", {st_mode=S_IFDIR|0755, st_size=520896512, ...}, AT_SYMLINK_NOFOLLOW) = 0 <0.000006>
fcntl(6, F_DUPFD, 3)                    = 7 <0.000005>
fcntl(7, F_GETFD)                       = 0 <0.000005>
fcntl(7, F_SETFD, FD_CLOEXEC)           = 0 <0.000004>
getdents(6, /* 2 entries */, 32768)     = 48 <117.122463>
getdents(6, /* 0 entries */, 32768)     = 0 <0.000005>
close(6)                                = 0 <0.000004>
-- 
"Thought is the essence of where you are now."
