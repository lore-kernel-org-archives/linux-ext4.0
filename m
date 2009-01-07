From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12375] ext4_block_to_path block too big cause cpu to burn
Date: Wed,  7 Jan 2009 02:57:41 -0800 (PST)
Message-ID: <20090107105741.5E1DA108041@picon.linux-foundation.org>
References: <bug-12375-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbZAGK6J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Jan 2009 05:58:09 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n07AvfW9017959
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jan 2009 02:57:42 -0800
In-Reply-To: <bug-12375-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12375





------- Comment #2 from dmaciejak@fortinet.com  2009-01-07 02:57 -------
Created an attachment (id=19686)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19686&action=view)
ext4 image poc


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
