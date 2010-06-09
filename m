From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Wed, 9 Jun 2010 22:57:40 GMT
Message-ID: <201006092257.o59Mvee6002724@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38129 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0FIW5l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 18:57:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o59MveQE002725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 22:57:40 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165





--- Comment #7 from Alexander Eichner <Alexander.Eichner@sun.com>  2010-06-09 22:57:38 ---
Installed RHEL 6 in a VM now (the image is on ext3) and I can confirm that it
isn't reproducible with the default 2.6.32 kernel. I downloaded and compiled a
vanilla 2.6.34 kernel from http://www.kernel.org The problem is there again but
it doesn't happen on every run of the testcase. 5 failures on 11 runs.
Could be timing sensitive.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
