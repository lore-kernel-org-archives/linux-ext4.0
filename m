From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151491] free space lossage on busy system with bigalloc enabled
 and 128KB cluster
Date: Mon, 20 Nov 2017 17:59:39 +0000
Message-ID: <bug-151491-13602-mEzjLuTl2m@https.bugzilla.kernel.org/>
References: <bug-151491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:32816 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751781AbdKTR7k (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 Nov 2017 12:59:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4161C29456
        for <linux-ext4@vger.kernel.org>; Mon, 20 Nov 2017 17:59:40 +0000 (UTC)
In-Reply-To: <bug-151491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151491

--- Comment #13 from Betacentauri (betacentauri@arcor.de) ---
The ARM machine I use has very little free memory. So that fits to your
analysis. 
With your information I could also reproduce it in the xfstests environment
with nodelalloc. But only 2 times. I set memory in the virtual machine to 256MB
(in config.kvm). Then I mounted the filesystem with nodelalloc and executed
this little script several times:

#!/bin/bash

i=0
while [ $i -lt 10 ]; do
 dd if=/dev/zero of=./test$i bs=1M count=200 > /dev/null
 cp test$i testx_$i
 sync
 let i=i+1
 echo $i
done

Result was this:
root@kvm-xfstests:/media/test# ls -las
total 4097028
   256 drwxr-xr-x 3 root root      4096 Nov 20 17:43 .
     4 drwxr-xr-x 3 root root      4096 Nov 20 17:33 ..
   256 -rwxr-xr-x 1 root root       155 Nov 20 17:48 h.sh
   256 drwx------ 2 root root     16384 Nov 20 17:26 lost+found
204800 -rw-r--r-- 1 root root 209715200 Nov 20 17:48 test0
205056 -rw-r--r-- 1 root root 209715200 Nov 20 17:48 test1
204800 -rw-r--r-- 1 root root 209715200 Nov 20 17:48 test2
204800 -rw-r--r-- 1 root root 209715200 Nov 20 17:48 test3
204800 -rw-r--r-- 1 root root 209715200 Nov 20 17:48 test4
...

One file has size 205056. But I cannot really reproduce it.

So better focus on fixing the bug than on trying to reproduce it with
nodelalloc. If I find a way to reproduce, I'll let you know ;-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
