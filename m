From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29312] Unmounting fails even after the underlying device is
 long gone
Date: Wed, 23 Feb 2011 08:54:09 GMT
Message-ID: <201102230854.p1N8s9RT023948@demeter2.kernel.org>
References: <bug-29312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:58660 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab1BWIyK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 03:54:10 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1N8s9ms023949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 08:54:10 GMT
In-Reply-To: <bug-29312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29312


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
             Blocks|                            |27352




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
