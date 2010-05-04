From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] serious performance regression in "umount" on ext4 over
 LVM
Date: Tue, 4 May 2010 21:48:29 GMT
Message-ID: <201005042148.o44LmTv0026158@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54958 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934098Ab0EDVsb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 17:48:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44LmTsQ026160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 21:48:29 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #8 from Eric Sandeen <sandeen@redhat.com>  2010-05-04 21:48:27 ---
Kees, no, 68db1961bbf4e16c220ccec4a780e966bc1fece3 made the test on loopback
slower, because now a barrier from a filesystem on a loopback device issues an
fsync on the underlying filesystem which issues a cache flush on the underlying
block device .... you get the picture.

Unless we really have gratuitous barrier issues here, there's probably not a
whole lot to be done, though maybe some batching is possible.

As for the business about ext3, there is nothing mysterious or odd there
either, ext3 mounts with barriers off by default, despite my best efforts, and
mounting it with the ext4 driver does turn them on.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
