From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Thu, 17 Jun 2010 15:49:11 GMT
Message-ID: <201006171549.o5HFnBn8030275@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47265 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0FQPtN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jun 2010 11:49:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5HFnBRO030276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jun 2010 15:49:11 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019


Klaus Lichtenwalder <lichtenwalder@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lichtenwalder@acm.org




--- Comment #22 from Klaus Lichtenwalder <lichtenwalder@acm.org>  2010-06-17 15:49:04 ---
Hi,

came here from "my" fedora bugzilla
(https://bugzilla.redhat.com/show_bug.cgi?id=603897) I found this bug. I'm
having it on an Aspire One with SSD. Guess the lvm theory is very reasonable.
If I can spare the time I'll try the alternate install this weekend.
Btw, I also got the following messages:
ERROR: sil: invalid metadata checksum in area 3 on /dev/dm-1
ERROR: sil: invalid metadata checksum in area 4 on /dev/dm-1

with /dev/dm-1 being the swap partition.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
