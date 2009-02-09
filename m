From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12676] fs/ext4/extents.c: In function =?UTF-8?Q?_=E2=80=98ext4_ext_search_right=E2=80=99:?= fs/ext4/extents.c:1120: warning: =?UTF-8?Q?_=E2=80=98ix=E2=80=99?= may be used uninitialized in this function
Date: Mon,  9 Feb 2009 08:10:18 -0800 (PST)
Message-ID: <20090209161018.4241110800D@picon.linux-foundation.org>
References: <bug-12676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZBIQKr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 11:10:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n19GAIkx025953
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 08:10:19 -0800
In-Reply-To: <bug-12676-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12676





------- Comment #1 from sandeen@redhat.com  2009-02-09 08:10 -------
I think this is fixed upstream; you say in the bug metadata that this is
version 2.6.28.4 but the first comment says 2.6.29-rc* - which is it?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
