From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 2 Jan 2010 17:54:55 GMT
Message-ID: <201001021754.o02HstpS022786@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41252 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0ABRyz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2010 12:54:55 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o02HstTY022787
	for <linux-ext4@vger.kernel.org>; Sat, 2 Jan 2010 17:54:55 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #6 from Theodore Tso <tytso@mit.edu>  2010-01-02 17:54:54 ---
You need to compile kernel with CONFIG_BLK_DEV_IO_TRACE and then you need to
make sure that the debugfs file system is mounted in /sys/kernel/debug, i.e.:

    mount -t debugfs none /sys/kernel/debug

The following documentation is from 2007, so there are some newer features (and
the underlying implementation has moved to using ftrace), but the basic user
interface hasn't changed much:

    http://pdfedit.petricek.net/bt/file_download.php?file_id=17&type=bug

More information:

    http://www.gelato.org/pdf/apr2006/gelato_ICE06apr_blktrace_brunelle_hp.pdf

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
