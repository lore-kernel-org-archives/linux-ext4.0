From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Thu, 21 Aug 2014 09:21:35 +0000
Message-ID: <bug-42723-13602-uRdTfwxu55@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53043 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaHUJVj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Aug 2014 05:21:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5E3F3201B4
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2014 09:21:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2396F20176
	for <linux-ext4@vger.kernel.org>; Thu, 21 Aug 2014 09:21:36 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

--- Comment #25 from Zhiyong Wu <zwu.kernel@gmail.com> ---
Hi, Ted

I checked debian 7.5/6 kernel src code, it hasn't merged commit 007649375f6af2
,so this issue whih i met seems to be not caused by this commit.

(In reply to Theodore Tso from comment #23)
> Zhiyong,

The ext4_mb_generate_buddy() error message just means that there
> is an inconsistency between the allocation bitmap and the allocation
> statistics in the block group descriptor.   So people who just google for
> "ext4_mb_generate_buddy" can often find old bugs that had similar symptoms.
> The most recent bugfix in this area was caused by a backport of commit:
> 007649375f6af2 ext4: initialize multi-block allocator before checking block
> descriptors

which caused errors after a replay.  It was reverted in
> mainline commit:

f9ae9cf5d72b39 ext4: revert commit which was causing fs
> corruption after journal replays

You might want to check to see if that
> might be applicable for your kernel.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
