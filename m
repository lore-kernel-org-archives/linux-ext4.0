From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15579] ext4 -o discard produces incorrect blocks of zeroes in
 newly created files under heavy read+truncate+append-new-file load
Date: Mon, 22 Mar 2010 21:41:06 GMT
Message-ID: <201003222141.o2MLf6Xd025669@demeter.kernel.org>
References: <bug-15579-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38100 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab0CVVlI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 17:41:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2MLf6nc025670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 21:41:06 GMT
In-Reply-To: <bug-15579-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15579


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2010-03-22 21:40:52 ---
Just for what it's worth, I've had trouble reproducing this on another brand of
SSD... something like this (don't let the xfs_io throw you; it's just a
convenient way to generate the IO).  I did this on a 512M filesystem.

#!/bin/bash

SCRATCH_MNT=/mnt/scratch

rm -f $SCRATCH_MNT/*
touch $SCRATCH_MNT/outputfile

# Create several large-ish files
for I in `seq 1 240`; do
  xfs_io -F -f -c "pwrite 0 2m" $SCRATCH_MNT/file$I &>/dev/null
done

# reread the last bit of each, just for kicks, and truncate off 1m
for I in `seq 1 240`; do
  xfs_io -F -c "pread 1m 2m" $SCRATCH_MNT/file$I &>/dev/null
  xfs_io -F -c "truncate 1m" $SCRATCH_MNT/file$I
done

# Append the outputfile
xfs_io -F -c "pwrite 0 250m" $SCRATCH_MNT/outputfile &>/dev/null

In the end I don't get any corruption.  I was hoping to write a testcase for
this (one that didn't take 250G) :)

Does the above reflect your use case?  Does the above corrupt the outputfile on
your filesystem?  (note the "rm -rf" above, careful with that).  You could
substitute dd for xfs_io without much trouble if desired.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
