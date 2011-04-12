From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32082] ext4: oops when mounting intentionally corrupted
 filesystem
Date: Tue, 12 Apr 2011 09:19:44 GMT
Message-ID: <201104120919.p3C9JiYH023816@demeter1.kernel.org>
References: <bug-32082-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50468 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1DLJTo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 05:19:44 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3C9JiFL023817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 12 Apr 2011 09:19:44 GMT
In-Reply-To: <bug-32082-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32082


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #3 from Florian Mickler <florian@mickler.org>  2011-04-12 09:19:42 ---
A patch referencing this bug report has been merged in v2.6.39-rc3:

commit 0449641130f5652b344ef6fa39fa019d7e94660a
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Tue Apr 5 19:55:28 2011 -0400

    ext4: init timer earlier to avoid a kernel panic in __save_error_info

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
