From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13874] kenal panic on addition of xfx nvidia gts250 512mb on
 946giz motherboard
Date: Tue, 4 Aug 2009 20:17:06 GMT
Message-ID: <200908042017.n74KH6B8016355@demeter.kernel.org>
References: <bug-13874-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38381 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZHDURH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 16:17:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n74KH6TU016356
	for <linux-ext4@vger.kernel.org>; Tue, 4 Aug 2009 20:17:06 GMT
In-Reply-To: <bug-13874-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13874





--- Comment #5 from Jan Kara <jack@suse.cz>  2009-08-04 20:17:05 ---
Well, the machine obviously has some serious problem. Just before the oops,
there's a message "bad entry in directory #565751: rec_len is smaller than
minimal" and then dump showing all entries are zero. This is quite early during
boot (udev has just started, we loaded keyboard maps and then oopsed). Given
this is some live DVD I believe some memory corruption is happening. The oops
is probably on dereferencing EXT3_SB(sb)->s_es which again shouldn't pose a
problem.

I've read the details you've posted to the forum referenced above and you write
there about a memory conflict of your Nvidia graphics card and "lots of memory
errors during the boot". So probably that should be resolved first. Sadly I
cannot see the relevant message in the recorded video to judge who should have
a look into this. So first, try booting with nosplash,vga=normal boot options
and record that boot on your camera. Hopefully that will contain all the
relevant error messages and we can then investigate further.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
