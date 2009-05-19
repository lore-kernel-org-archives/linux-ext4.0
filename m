From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Tue, 19 May 2009 20:38:35 GMT
Message-ID: <200905192038.n4JKcZ96026431@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42707 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZESUid (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 16:38:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JKcZtx026432
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 20:38:35 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2009-05-19 20:38:32 ---
Created an attachment (id=21436)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=21436)
Proposed patch from Al Viro

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
