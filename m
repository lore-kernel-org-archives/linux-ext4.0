From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 21 Feb 2011 04:02:20 GMT
Message-ID: <201102210402.p1L42KHm007429@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50414 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab1BUECV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Feb 2011 23:02:21 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1L42K1m007430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 04:02:20 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #32 from rocko <rockorequin@hotmail.com>  2011-02-21 04:01:54 ---
Created an attachment (id=48502)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48502)
diff between 2.6.37.1 and 2.6.38-rc5 configs

I think this might have had something to do with the config I was building the
kernel with.

I tried the Ubuntu weekly build of 2.6.38-rc5 (which appears to have been
compiled with gcc-4.2) and couldn't repeat the freeze. I then recompiled
2.6.38-rc5 using gcc-4.5.1 but with the Ubuntu config and haven't been able to
reproduce the freeze yet with this combination, so it seems likely a config
issue instead of a compiler issue.

The attached diff should show the 'good' config for 2.6.38-rc5 (ie copied from
the Ubuntu weekly build) against the config for the build I did against
2.6.38-rc4, which is very similar to the config I was using with 2.6.38-rc5
that kept crashing.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
