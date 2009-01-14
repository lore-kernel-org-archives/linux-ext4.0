From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Wed, 14 Jan 2009 12:35:27 -0800 (PST)
Message-ID: <20090114203527.92C94108041@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbZANUf5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 15:35:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0EKZR6c021014
	for <linux-ext4@vger.kernel.org>; Wed, 14 Jan 2009 12:35:28 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #14 from csights@fastmail.fm  2009-01-14 12:35 -------
http://bugzilla.kernel.org/show_bug.cgi?id=12224

>
>
>
> ------- Comment #13 from sandeen@redhat.com  2009-01-13 14:17 -------
> Care to test the patch at http://patchwork.ozlabs.org/patch/14755/ ?

Sure!
        I manually patched 2.6.28.  btrace showed lots of output as above. 
However, 
I didn't wait to see if the observed activity affected the drive spinup/down 
b/c I thought maybe patching 2.6.28 was not proper.
        I don't know how to git the right kernel sources to patch.  Could you
prepare 
a patch against an RC (or in some other way hold my hand)?  Or I could wait 
for some RC which includes the patch already.

Sorry for my gimpiness,
        C.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
