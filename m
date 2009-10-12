From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 12 Oct 2009 15:48:27 +0200
Message-ID: <19155.13227.836823.871053@pilspetsen.it.uu.se>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
	<200910092201.n99M1iBY007169@demeter.kernel.org>
	<20091010013131.GC18440@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-ext4@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:39859 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652AbZJLNtO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Oct 2009 09:49:14 -0400
In-Reply-To: <20091010013131.GC18440@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso writes:
 > On Fri, Oct 09, 2009 at 10:01:44PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
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
