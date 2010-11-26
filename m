From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Fri, 26 Nov 2010 14:27:09 GMT
Message-ID: <201011261427.oAQER9fJ011776@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:52007 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0KZO1K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Nov 2010 09:27:10 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAQER9MW011777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 26 Nov 2010 14:27:10 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #5 from Fryderyk Dziarmagowski <fdziarmagowski@gmail.com>  2010-11-26 14:27:08 ---
(In reply to comment #3)
> Hmm.... is this panic repeatable?

yes, it occurs always, just a few seconds after mount.

> And can you send me the first 4k of the filesystem?  i.e., do a "dd
> if=/dev/dsk/by-label/MyBook of=/tmp/sb.img bs=4k count=1" and then attach
> /tmp/sb.img to this bug?

uploaded

> Thanks,
> 
> -- Ted

Thanks,
Freddy

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
