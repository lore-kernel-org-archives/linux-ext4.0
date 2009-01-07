From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12371] oops in ext4_get_group_desc
Date: Wed,  7 Jan 2009 02:35:10 -0800 (PST)
Message-ID: <20090107103510.603B4108040@picon.linux-foundation.org>
References: <bug-12371-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbZAGKfo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 05:35:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n07AZAXc016836
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 02:35:11 -0800
In-Reply-To: <bug-12371-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12371





------- Comment #4 from dmaciejak@fortinet.com  2009-01-07 02:35 -------
thanks for the info, the patch also works for me


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
