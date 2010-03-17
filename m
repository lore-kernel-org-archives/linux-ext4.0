From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15543] Oops in dentry_iput during ext3 remount readonly
Date: Wed, 17 Mar 2010 12:15:25 GMT
Message-ID: <201003171215.o2HCFP7q010964@demeter.kernel.org>
References: <bug-15543-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54087 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab0CQMP0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Mar 2010 08:15:26 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HCFPEo010965
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Mar 2010 12:15:25 GMT
In-Reply-To: <bug-15543-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15543


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #3 from Jan Kara <jack@suse.cz>  2010-03-17 12:15:19 ---
Thanks for the report. I'm sorry but this looks like a single-bit error. From
the oops, it looks like the kernel tried to dereference address 0xb05cad1c
while the correct address would be f05cad1c (as you can see, lots of addresses
in this range are in registers so that's probably where kernel has it's data on
your machine). So I'd blame either cosmic rays or faulty HW. Maybe try running
memtest, or try replacing memory if it repeats. I'll close the bug as
invalid...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
