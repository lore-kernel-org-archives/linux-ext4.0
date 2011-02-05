From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 5 Feb 2011 20:53:55 GMT
Message-ID: <201102052053.p15KrtQx024979@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41742 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab1BEUx4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 15:53:56 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p15KrtSC024981
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Feb 2011 20:53:55 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #15 from rocko <rockorequin@hotmail.com>  2011-02-05 20:53:52 ---
Created an attachment (id=46472)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=46472)
kernel paging request bug dump

I reproduced the freezing bug (ie kernel paging request bug) in 2.6.38-rc3 this
time. The bug dump is longer but still looks truncated during the call trace. 

FUSE was not loaded this time (I only had ext3/4 drives).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
