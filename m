From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45971] BUG: unable to handle kernel paging request
Date: Fri, 24 Aug 2012 14:55:37 +0000 (UTC)
Message-ID: <20120824145537.EF8BF11FA39@bugzilla.kernel.org>
References: <bug-45971-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60893 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab2HXOzl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Aug 2012 10:55:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 588B420325
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 14:55:40 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F154D20335
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 14:55:37 +0000 (UTC)
In-Reply-To: <bug-45971-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45971


Tomas Racek <tracek@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #2 from Tomas Racek <tracek@redhat.com>  2012-08-24 14:55:37 ---
Fixed in:
cb09cad44f x86/alternatives: Fix p6 nops on non-modular kernels

More info:
https://lkml.org/lkml/2012/8/16/230

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
