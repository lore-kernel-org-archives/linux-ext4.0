From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 28 Jan 2010 16:22:01 GMT
Message-ID: <201001281622.o0SGM1or014317@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34860 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0A1QWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 11:22:02 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SGM1n3014318
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 16:22:01 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #14 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-01-28 16:21:57 ---
On 01/27/2010 11:53 PM, tytso@mit.edu wrote:
> And in both of your cases, were you using a new file system freshly
> created using mke2fs -t ext4, or was this a ext2/ext3 filesystem that
> was converted for use under ext4?
>
> Thanks,
>
> 					- Ted
>    
In my case it is new ext4.  I will try what tests I can in a day or
two.  The systems are busy right now.

Michael

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.