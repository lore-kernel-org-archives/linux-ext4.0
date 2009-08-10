From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 13:58:46 GMT
Message-ID: <200908101358.n7ADwklF026243@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49873 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbZHJN6p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 09:58:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7ADwk8I026244
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 13:58:46 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #12 from Michael B. Trausch <mike@trausch.us>  2009-08-10 13:58:44 ---
You said that the md5sum is hanging in the R state, yes?  If so, it's not
hanging at all.  It's still computing the MD5 sum.  What sort of disks are you
using (IDE/SCSI/SATA)?  What sort of CPU (cat /proc/cpuinfo)?  How much RAM
(free)?

mbt@zest:~$ time md5sum sample.3gb 
c698c87fb53058d493492b61f4c74189  sample.3gb

real    0m12.017s
user    0m8.561s
sys    0m3.276s

This is on a system that isn't heavily loaded, with a 3.0Gbps SATA II drive
holding the file.

Try this to see if it really is hanging or not.  Install the "pv" utility.  It
is available from http://www.ivarch.com/programs/pv.shtml -- and in many
distributions (I can say for certain that it is in Ubuntu's repositories at the
very least, and am pretty sure that it's on Debian and RH repositories, too).

Then, run:

cat YOUR_3GB_FILE | pv | md5sum

This will show you how much data is being pushed through the pipe, and at what
rate of speed.  My system is able to push about 200MB/s through pv.  This will
give you a better, visual indication of what is going on.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
