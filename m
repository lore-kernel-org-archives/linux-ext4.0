From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] kernel hang on insert ext4 usb key
Date: Fri, 19 Nov 2010 16:02:56 GMT
Message-ID: <201011191602.oAJG2ucH029949@demeter1.kernel.org>
References: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46469 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0KSQC5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 11:02:57 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAJG2uTY029950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Nov 2010 16:02:56 GMT
In-Reply-To: <bug-23232-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232





--- Comment #9 from Theodore Tso <tytso@mit.edu>  2010-11-19 16:02:53 ---
I'm not convinced we even got into the ext4_fill_super(); if we did there
should have been at least some ext4 printk's.   The OOPS is in
vfs_kern_mount().

I've looked through ext4_fill_super(), and if vfs_kern_mount() had gotten as
far as calling into ext4_fill_super(), I can't find any code path other than
failing the first two memory allocations that wouldn't have resulted in some
kind of kernel printk --- which wasn't in the oops display.

So I strongly suspect the failure was before vfs_kern_mount() calling
ext4_mount(), or in mount_bdev() --- since all ext4_mount() does is call
mount_bdev() passing in ext4_fill_super as a callback function.

Can the oops be replicated at this point?   If so, we can try instrumenting the
kernel, but this strongly smells like a hardware problem and a failure in the
generic code before we drop into the ext4 mount code in ext4_fill_super().

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
