From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36722] TRIM support is broken for Crucial M4 drives
Date: Mon, 6 Jun 2011 17:43:16 GMT
Message-ID: <201106061743.p56HhGs1013089@demeter2.kernel.org>
References: <bug-36722-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:43544 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1FFRnQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 13:43:16 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p56HhGjR013090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:43:16 GMT
In-Reply-To: <bug-36722-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36722


Martin K. Petersen <mkp@mkp.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mkp@mkp.net




--- Comment #3 from Martin K. Petersen <mkp@mkp.net>  2011-06-06 17:43:15 ---
hdparm asks the drive directly whereas the LSI card must be able to translate
from SCSI to ATA commands. None the LSI cards I have support that functionality
yet.

You can try sending us the output of:

# sg_readcap -l /dev/sdk

# sg_vpd -p thpv /dev/sdk

-- 
Martin K. Petersen      Oracle Linux Engineering

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
