From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 21 May 2010 10:36:12 GMT
Message-ID: <201005211036.o4LAaC7C025225@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44090 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0EUKgP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 May 2010 06:36:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4LAaClE025226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 21 May 2010 10:36:13 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #5 from David Lowe <lowe@brown.edu>  2010-05-21 10:36:07 ---
(In reply to comment #3)
> Is this reliably reproducible?  It looks like a block allocation is getting
> corrupted when you hibernate.  
> 
> What are you using as your hibernation partition?

The disk is a 
ATA toshiba mk6037gsx (sata harddrive) set up as a 
lvm2 volume (28Gb) partitioned as 24 Gb ext4 plus 4 Gb swap

As far as I know, the swap is the hibernate partition.
Am using pm-hibernate or standard gnome tools to hibernate.

The problem happens every time I hibernate. Let me know what other info would
be useful.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
