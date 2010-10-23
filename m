From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20992] Data corruption triggers ext4 oops
Date: Sat, 23 Oct 2010 15:20:45 GMT
Message-ID: <201010231520.o9NFKj9O022399@demeter2.kernel.org>
References: <bug-20992-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:48362 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab0JWPUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Oct 2010 11:20:46 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9NFKjsc022400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 23 Oct 2010 15:20:45 GMT
In-Reply-To: <bug-20992-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20992





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2010-10-23 15:20:43 ---
Yep, looks like a bug alright. 

>From what I can tell, you were in the middle of async I/O, at the time when the
disk was corrupted.  The problem seemed to come after the I/O was completed,
and  ext4_convert_unwritten_extents() was trying to set the initialized bit on
the extent tree.  At that point the extent tree must have gotten corrupted on
disk, and this seriously confused the extent conversion code, which ended up
passing 0 to ext4_ext_put_in_cache() as the length of the extent, and that
tripped the BUG_ON in ext4_ext_put_in_cache().

How did you corrupt the file system while it was mounted?   Was it via some dd
to the disk device directly?

We do have code that checks to make sure the extent tree is sane, but we skip
it if the data was already in the buffer cache, to save CPU costs.  But if you
wrote to the disk device directly, it would have gone through the buffer cache,
since the extent tree was already cached, we would have skipped the validation
step, and that could be the explanation for how the bug got triggered.

If so, I'm loathe to turn on the validation check unconditionally, since that
would kill performance.  I can probably change the BUG_ON in
ext4_put_in_cache() to rather set the cache state to "invalid", which would at
least prevent the BUG_ON.  The filesystem was probably well and truly trashed,
though, so sooner or later the ext4 fs code would have hit something to cause
it to be very unhappy.  Hoepfully it would be an ext4_error() call to mark the
file system as corrupted, as opposed to another BUG_ON.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
