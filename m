From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Wed, 6 Apr 2011 23:01:31 GMT
Message-ID: <201104062301.p36N1VCF028899@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36306 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1DFXBm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Apr 2011 19:01:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p36N1cZa028950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Apr 2011 23:01:38 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #58 from rocko <rockorequin@hotmail.com>  2011-04-06 23:00:52 ---
I reproduced the problem removing/inserting an SD card in the SD card reader
(SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev
22), but only if it has an ext4 file system on it. I couldn't make it happen at
all with a vfat file system on it - I tried 30 times or so with the vfat card,
but it happened on just the third removal of the ext4 file system.

So it does seem to be an ext3/4 issue rather than a USB-related issue.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
