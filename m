From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15074] Problem with quota on ext4
Date: Tue, 9 Feb 2010 16:36:06 GMT
Message-ID: <201002091636.o19Ga6TR032462@demeter.kernel.org>
References: <bug-15074-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59804 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab0BIQgH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 11:36:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o19Ga6X4032474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 16:36:06 GMT
In-Reply-To: <bug-15074-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15074





--- Comment #6 from Dmitri Monakhov <dmonakhov@openvz.org>  2010-02-09 16:35:47 ---
Wait a minute, seems that you have write to a file system before quotaon
Is is true ? If so then you at do the wrong things because your quota
will becomes out of sync in this case.

I have a patch which fix this issue,
http://marc.info/?l=linux-ext4&m=126106648829617&w=2).
It was accepted by Jan but seems was dropped somewhere. I'm also complitly   
forgot about it. Cat you try it.
But in fact the patch just makes kernel more patient to users misbehaviour.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
