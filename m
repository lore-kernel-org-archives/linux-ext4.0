From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Mon, 28 Jun 2010 17:48:00 GMT
Message-ID: <201006281748.o5SHm0jg011587@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56406 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0F1RsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 13:48:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o5SHm0Rs011588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 28 Jun 2010 17:48:00 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Maciej Rutecki <maciej.rutecki@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Blocks|                            |16055




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
