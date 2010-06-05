From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16081] Data loss after crash during heavy I/O
Date: Sat, 5 Jun 2010 14:32:54 GMT
Message-ID: <201006051432.o55EWsfX028759@demeter.kernel.org>
References: <bug-16081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36378 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab0FEOcz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jun 2010 10:32:55 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o55EWsmB028760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jun 2010 14:32:55 GMT
In-Reply-To: <bug-16081-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16081





--- Comment #18 from lkolbe@techfak.uni-bielefeld.de  2010-06-05 14:32:46 ---
Thanks, though. After working flawlessly for more than 13TiB, we hit another
crash today - a colleague called 'lsscsi', after that all commands quit with
'Bus error' for a while and the machine stuck with no messages on the serial
line. Befor that, cat /proc/interrupts worked and showed massive ERR:

shepherd:/etc# cat /proc/interrupts 
             CPU0       CPU1       CPU2       CPU3       
[...]
 THR:          0          0          0          0   Threshold APIC interrupts
 MCE:          0          0          0          0   Machine check exceptions
 MCP:         28         28         28         28   Machine check polls
 ERR:   37567046
 MIS:          0

I suppose this means it's not Linux fault?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
