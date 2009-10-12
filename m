From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 12 Oct 2009 13:48:40 GMT
Message-ID: <200910121348.n9CDmeqE032607@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34243 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbZJLNtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2009 09:49:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9CDmejr032611
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 13:48:40 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #4 from Mikael Pettersson <mikpe@it.uu.se>  2009-10-12 13:48:39 ---
Theodore Tso writes:
 > On Fri, Oct 09, 2009 at 10:01:44PM +0000,
bugzilla-daemon@bugzilla.kernel.org wrote:
 > > > Not fixed in 2.6.32-rc3. A glibc rebuild + install triggered the
 > > > exact same bug on the third machine.
 > 
 > Can you isolate this down to something simpler?  Will "make install"
 > followed by a reboot be sufficient to replicate the assertion failure?

I've done repeated glibc downgrades and upgrades, using pre-built binary
packages, followed by reboots, but they have so far not triggered the bug.

My guess is that something in the build process or the test suite run
triggers the bug.

FWIW, the systems are rpm-based derived from Fedora, so the rebuilds
are just "rpmbuild --rebuild glibc-<version>.src.rpm", and the installs
are "rpm -Uvh" on the binary rpms, with --force if I'm doing a downgrade.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
