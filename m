From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Mon, 16 Aug 2010 13:24:40 GMT
Message-ID: <201008161324.o7GDOeAi006921@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55552 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0HPNYl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Aug 2010 09:24:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7GDOeq7006922
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Aug 2010 13:24:40 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16165


Michael Tokarev <mjt@tls.msk.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mjt@tls.msk.ru




--- Comment #23 from Michael Tokarev <mjt@tls.msk.ru>  2010-08-16 13:24:32 ---
Yesterday I observed another data corruption that looks very close to this one,
but slightly different (and much more serious).

The scenario is this: oracle10 database, creating db and importing data. 
Oracle uses ftruncate() to create file of a desired size, next it fills the
file with block headers, so there's no unwritten data in the file.  So far so
good.  There's also temporary tablespaces, which aren't filled during creation,
but just ftruncate'd.

The problem here happens when I extend a temp file during heavy database
writes.  It were needed a few times because in order to create large indexes,
large temporary space were needed.

And each time I try extend temp file (say, from 10 to 20Gb), oracle performs
the ftruncate on it, and continues writing to it and to other data files (which
were pre-filled after ftruncate, even before system restart).  And during this
time, there's a very likely chance to have _other_ data files to be corrupt
while it is writing to the newly extended temp space.

We observed several chunks of zeros (of size 1Mb each) written over _other_
files during this time.  Re-read of those other files returns the same zeros.

So, this delayed allocation corrupts _other_ data files which are already
allocated and written.

Avoiding gaps eliminates the problem.

Note that oracle uses aio and direct-io and "gapful" files at least for the
temporary ts.

The kernel in question is 2.6.32.15.

This is quite a major issue...

But I repeat: i'm not sure it's related to this bugreport.  At least the roots
are somewhere very close.

BTW, when it started in XFS, anyone know?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
