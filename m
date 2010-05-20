From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Thu, 20 May 2010 02:11:55 GMT
Message-ID: <201005200211.o4K2BtG0030354@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39729 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0ETCL5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 May 2010 22:11:57 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4K2BurR030413
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 20 May 2010 02:11:56 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830


Justin Maggard <jmaggard10@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmaggard10@gmail.com




--- Comment #39 from Justin Maggard <jmaggard10@gmail.com>  2010-05-20 02:11:11 ---
(In reply to comment #28)
> Created an attachment (id=25883)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=25883) [details]
> Patch to stop background writeback when other work is queued for the thread
> 
> Oops, attached a wrong patch. This is the right one.

I ran into this issue recently (extra long sync times) and have been trying the
patches attached in this thread.  The above patch specifically causes a pretty
significant performance regression for me doing a simple sequential dd write on
a dual-core Atom system running 2.6.33.4 x86_64.  This command:
dd bs=1M conv=fsync if=/dev/zero of=test_file count=10000
went from 135 MB/sec to all the way down to 92.9 MB/sec.  Is this expected?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
