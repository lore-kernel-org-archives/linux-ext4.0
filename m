From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 73051] Hung Tasks related to ext4 IO
Date: Tue, 08 Apr 2014 11:20:36 +0000
Message-ID: <bug-73051-13602-BpSoVMq9i4@https.bugzilla.kernel.org/>
References: <bug-73051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51524 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbaDHLUk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Apr 2014 07:20:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B86720395
	for <linux-ext4@vger.kernel.org>; Tue,  8 Apr 2014 11:20:39 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AE715203AC
	for <linux-ext4@vger.kernel.org>; Tue,  8 Apr 2014 11:20:36 +0000 (UTC)
In-Reply-To: <bug-73051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=73051

--- Comment #3 from Nik Martin <nik.martin@gmail.com> ---
I can try that, and see if I can replicate the issue. I'm not exactly sure
how to disable bcache, it's not the most well documented system.
On Apr 7, 2014 8:25 AM, <bugzilla-daemon@bugzilla.kernel.org> wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=73051
>
> Jan Kara <jack@suse.cz> changed:
>
>            What    |Removed                     |Added
>
> ----------------------------------------------------------------------------
>              Status|NEW                         |NEEDINFO
>                  CC|                            |jack@suse.cz
>
> --- Comment #2 from Jan Kara <jack@suse.cz> ---
> Looking into the traces, this doesn't seem to be ext4 problem at the first
> sight. We are waiting in filemap_fdatawait_range() for IO on the page to
> finish. It seems that never happens which would be a bug somewhere in the
> block
> layer, device mapper, etc. Seeing that you mention bcache, would it be
> possible
> to try whether the hangs happen without it?
>
> --
> You are receiving this mail because:
> You reported the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
