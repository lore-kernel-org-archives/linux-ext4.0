From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Sun, 01 Feb 2015 01:51:46 +0000
Message-ID: <bug-92271-13602-HA2vvcLnJ7@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41811 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbbBABvt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Jan 2015 20:51:49 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 867C02025B
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 01:51:48 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5595D2021B
	for <linux-ext4@vger.kernel.org>; Sun,  1 Feb 2015 01:51:47 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92271

--- Comment #13 from Theodore Tso <tytso@mit.edu> ---
I don't like making promises that I can't be 100% sure I can keep.   For
example, it's possible to create storage devices that simulate a read/write
disk but which is backed on top of a write-only drive, where the copy-on-write
is done at the storage device level.   You can set up such a beast using ceph,
for example.

The only real solution if you want to be able to give away a phone and make
sure that the next owner can't recover anything at all is to use encryption.  
So for example, if you buy a Nexus 6, it comes with encryption enabled by
default, and if you do a factory reset, one of the things that happens is that
the key which can be derived from your pin/password (the downside is you have
to type in your pin after every single reboot/power cycle), and that will
guarantee that your data is secure.  In fact, all of GCE's VM storage options
provide encryption as a non-optional feature.  See
https://cloud.google.com/compute/docs/disks

This is how Google Compute Engine guarantees security for its local SSD product
offering --- each SSD attached to each VM gets its own encryption key, and when
the VM is destroyed, the encryption key is flushed, and that way you don't have
to feed the SSD to a shredder (which is the *only* other way to 100% guarantee
that all of the data is deleted).  In the commercial world (never mind the
military world), you really care about your reputation, which means that you
must make sure that data can never leak, which is why you don't trust the FTL,
and you don't trust vendors claims around "trim" or "secure trim".   You use
crypto.

So if you want to use crypto, what to do?   You can either use dm-crypt or
ecryptfs, which is what Android and Chrome are currently using, or we're
currently working on an ext4 encryption feature which will give you per-file
control over which keys get used for which files.   This feature is still very
much in development, so if it breaks, you can keep both pieces, but this is why
I'm not terribly interested in wasting time trying to wire up secure discard.  
If someone else wants to send me patches, I'll look at them, but personally I
don't think it's a good use of my time.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
