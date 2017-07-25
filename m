From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 25 Jul 2017 08:56:05 +0000
Message-ID: <bug-196405-13602-oUQg4Y8Vvz@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46980 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750769AbdGYI4M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Jul 2017 04:56:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A594C285FE
        for <linux-ext4@vger.kernel.org>; Tue, 25 Jul 2017 08:56:11 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #26 from Paul Eggert (eggert@cs.ucla.edu) ---
(In reply to Theodore Tso from comment #18)
> One of the things which confuses me is why you think there's so much
> code which tries to use the st_nlink hack.  It's ***much*** simpler to
> just rely on d_type if it exists (and it does on most systems).

This is true only for one particular optimization; it is not true for others.
For example, Gnulib takes advantage of the fact a directory with st_nlink==2
has no subdirectories, if the directory is in a file system where this
optimizatino is known to work. One can't easily use d_type for this.

> 1) The assumption that st_nlink always has the property that it is >2
>    and can be used to derive the number of subdirectories was never
>    valid across all file system types

Yes, and Gnulib exploits the st_nlink assumption only on file systems where it
is useful and/or known to work.

> 2) If you did descend into a file system which didn't support d_type,
>    d_type would be DT_UNKNOWN instead of DT_REG or DT_DIR

Yes, and Gnulib doesn't use the optimization if d_type is DT_UNKNOWN.

> 3) Using DT_DIR is means you can skip the stat check for all directory
>    entries.  If you are doing a recursive descent where you care about
>    the name, you need to call readdir() on all of the directory
>    entries anyway, so you will have access to d_type.  If you are
>    doing a recursive descent where you are checking on file ownership,
>    you are doing the stat(2) anyway, so why not check
>    S_ISDIR(st.st_mode) instead of blindly using the st_nlink hack?

No, you can do even better than that in some cases, if st_nlink works. Suppose
we are implementing the equivalent of 'find . -type d'. If we come across a
directory whose st_nlink == 2, then we don't need to readdir from the directory
at all, much less stat its entries.

> 4) ... if your argument is what about legacy Unix code

There is more of that floating around than I'd like, yes. But I'm mostly
worried about GNU code.

> Can you give me a pointer to the original bug report?  I'm curious how
> things were misbehaving.

https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27739

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
