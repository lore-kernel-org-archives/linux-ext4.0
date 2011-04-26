From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Tue, 26 Apr 2011 03:29:55 GMT
Message-ID: <201104260329.p3Q3TtsJ003563@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50241 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab1DZD34 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 23:29:56 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3Q3TtWt003564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 26 Apr 2011 03:29:55 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #76 from Theodore Tso <tytso@mit.edu>  2011-04-26 03:28:39 ---
So for this latest result, which file systems have you been using?  ext3? ext4?
ntfs? vfat?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
