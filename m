From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Thu, 15 Jan 2009 08:12:35 -0800 (PST)
Message-ID: <20090115161235.4371B11D10A@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755691AbZAOQMh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jan 2009 11:12:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0FGCZRt006675
	for <linux-ext4@vger.kernel.org>; Thu, 15 Jan 2009 08:12:36 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224


sandeen@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #19805|0                           |1
        is obsolete|                            |




------- Comment #20 from sandeen@redhat.com  2009-01-15 08:12 -------
Created an attachment (id=19814)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19814&action=view)
Updated patch

sorry, didn't drive quilt right last time!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
