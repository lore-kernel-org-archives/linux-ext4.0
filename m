From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Wed, 11 Nov 2009 15:29:18 GMT
Message-ID: <200911111529.nABFTIsr004456@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42621 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbZKKP3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Nov 2009 10:29:13 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nABFTIqZ004457
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2009 15:29:18 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #9 from Jan Kara <jack@suse.cz>  2009-11-11 15:29:18 ---
Mikael, could you please run a kernel with the above patch and post here
resulting messages during umount and also attach here your System.map file from
the tested kernel? Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
