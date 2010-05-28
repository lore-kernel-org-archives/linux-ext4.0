From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 28 May 2010 23:03:34 GMT
Message-ID: <201005282303.o4SN3Yx0008304@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48766 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0E1XDe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 19:03:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4SN3YHW008305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 28 May 2010 23:03:34 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #19 from David Lowe <lowe@brown.edu>  2010-05-28 23:03:31 ---
I switched over to Ubuntu 10.04 and no longer have problems with hibernate or
suspend. I also tested this against the vanilla 2.6.33.4 kernel under ubuntu,
without issue.

The main differences seem to be:
(1) I am no longer using an lvm2 volume with an ext4 partition, just a simple
extended partition with ext4
(2) fedora patches to the kernel
(3) fedora/ubuntu differences in pm-utils, if any

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
