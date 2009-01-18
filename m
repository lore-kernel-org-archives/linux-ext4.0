From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Sat, 17 Jan 2009 16:24:08 -0800 (PST)
Message-ID: <20090118002408.13D9F10800F@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934AbZARAYj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 19:24:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0I0O8mM014623
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 16:24:09 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #3 from tytso@mit.edu  2009-01-17 16:24 -------
Hi, any more information about this bug? How much memory do you have?

What ext3 filesystems do you have mounted?  The oops is in ext3 code:


handle_t *journal_start(journal_t *journal, int nblocks)
{
        handle_t *handle = journal_current_handle();
        int err;

        if (!journal)
                return ERR_PTR(-EROFS);

        if (handle) {
                J_ASSERT(handle->h_transaction->t_journal == journal); <----
                handle->h_ref++;
                return handle;
        }

It seems to be related ext3's quota code -- and again it seems to be related to
an attempt to free memory when the system is under memory pressure.  This looks
very much like a quota and/or ext3 bug.




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
