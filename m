From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Fri, 18 Jun 2010 14:39:19 GMT
Message-ID: <201006181439.o5IEdJBd021105@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44160 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0FROjU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jun 2010 10:39:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o5IEdJnp021106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jun 2010 14:39:19 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019





--- Comment #35 from Rafael J. Wysocki <rjw@sisk.pl>  2010-06-18 14:39:17 ---
Also, I'd like to know if the kernels the issue is reproducible with are
64-bit or 32-bit, and if 32-bit, then what memory .config options are set
(ie. is highmem set and if so, what kind of highmem etc.).

I'm unable to reproduce the issue with my i915 hardware and a 64-bit kernel,
FWIW.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
