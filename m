From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 6 Feb 2011 09:00:34 GMT
Message-ID: <201102060900.p1690YIt027011@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53618 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1BFJAg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Feb 2011 04:00:36 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1690ZMr027013
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 6 Feb 2011 09:00:35 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #21 from rocko <rockorequin@hotmail.com>  2011-02-06 09:00:29 ---
Could this possibly be a caching/stale pointer problem? 

In comment #10, FUSE was somehow involved in an ext4-fs operation after the
fuse/ntfs partition was unmounted (and presumably its kernel FS memory freed).
Wouldn't a fuse/ext4 combination only happen if the kernel incorrectly tried to
access the freed ntfs/fuse memory data when subsequently trying to read/write
the ext4 file system (or am I incorrect when I assume that FUSE would never be
involved in ext4-fs operations?).

Two of the other crashes happened when firefox and gnome-panel tried to access
the home partition and failed - but the home partition _was_ present and
therefore should have always been accessible. Could the kernel have got
confused and been accessing access freed memory used for an absent external
partition instead of the memory being used to cache data for the home
partition?

This might also explain why the chances of the kernel panic happening are much
higher if there are multiple removed drives involved, ie because there is more
chance of freed memory incorrectly being accessed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
