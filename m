From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15690] system hanged while doing "sync"
Date: Sun, 4 Apr 2010 15:35:27 GMT
Message-ID: <201004041535.o34FZRVC012538@demeter.kernel.org>
References: <bug-15690-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50376 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab0DDPfn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 11:35:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o34FZW9L012564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 4 Apr 2010 15:35:32 GMT
In-Reply-To: <bug-15690-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15690





--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2010-04-04 15:34:51 ---
Oh wait, sorry I was wrong, this is a null pointer deref, not the same thing at
all.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
