From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Fri,  1 Jun 2012 16:26:59 +0000 (UTC)
Message-ID: <20120601162659.F3DB611FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50967 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965413Ab2FAQ1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 12:27:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0294720244
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 16:27:02 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 075C52023A
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jun 2012 16:27:00 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #16 from Jan Kara <jack@suse.cz>  2012-06-01 16:26:59 ---
Grumble, it's the same, just for a different allocation group:
253,2    0     6514    25.375884394   744  Q   R 707526656 + 8 [nfsd]
  9,0    0     5451    25.375887257   744  A   R 749576576 + 8 <- (253,2)
707526
656
  9,0    0     5452    25.375888584   744  Q   R 749576576 + 8 [nfsd]
  8,16   0    17311    25.375891308   744  A   R 749576639 + 8 <- (8,17)
7495765
76
  8,16   0    17312    25.375892077   744  Q   R 749576639 + 8 [nfsd]
  8,16   0    17313    25.375894381   744  G   R 749576639 + 8 [nfsd]
  8,16   0    17314    25.375895918   744  P   N [nfsd]
  8,16   0    17315    25.375898572   744  I   R 749576639 + 8 [nfsd]
  8,16   0    17316    25.375900038   744  U   N [nfsd] 1
  8,16   0    17317    25.375901715   744  D   R 749576639 + 8 [nfsd]

Let's try the following:
for (( i = 0; i < 25293; i++ )); do
  dd if=/dev/dm-2 of=/dev/null bs=4k count=1 skip=$(($i*32768))
done

Again run it before and after the hang. If it finishes even after the hang,
check whether nfsd is still hung.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
