From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 30872] Calling kfree() for uninitialized pointer in
 ext4_mb_init_backend()
Date: Mon, 14 Mar 2011 20:08:28 GMT
Message-ID: <201103142008.p2EK8S6h023103@demeter2.kernel.org>
References: <bug-30872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:53448 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1CNUI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 16:08:29 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p2EK8SxI023104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 20:08:29 GMT
In-Reply-To: <bug-30872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=30872





--- Comment #3 from Eugene A. Shatokhin <dame_eugene@mail.ru>  2011-03-14 20:08:27 ---
(In reply to comment #2)
> I sent a patch here:
> http://marc.info/?l=linux-ext4&m=129979820301087&w=2
> which initializes all the pointers to NULL and only frees if they are non-NULL, 
> which may be more foolproof, but might also be overkill.

As far as I can see, it is not overkill. 

On the system where I observed the problem, 'i' began from 12
('num_meta_group_infos' was 12, the total number of groups to be initialized).
But only the first two elements of the sbi->s_group_info array were actually
initialized. So without setting the remaining pointers to NULL, 
    while (--i >= 0)
        kfree(sbi->s_group_info[i]);
would still result in an oops when it attempted to kfree()
sbi->s_group_info[11].

Apart from that, checking if the pointer is not NULL before kfree() could
probably be omitted in the patch as kfree(NULL) is a no-op anyway. But still,
it is a matter of coding style and personal preference.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
