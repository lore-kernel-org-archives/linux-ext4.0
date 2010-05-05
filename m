From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Wed, 5 May 2010 21:36:53 GMT
Message-ID: <201005052136.o45Lar3H028658@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51687 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0EEVg4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 17:36:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o45LarST028659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 May 2010 21:36:53 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906





--- Comment #16 from Greg.Freemyer@gmail.com  2010-05-05 21:36:46 ---
QAqPqqaAAaQw

On 5/5/10, bugzilla-daemon@bugzilla.kernel.org
<bugzilla-daemon@bugzilla.kernel.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=15906
>
>
> Kees Cook <kees@outflux.net> changed:
>
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>             Summary|serious performance         |performance regression in
>                    |regression in "umount" on   |"umount" of filesystems
>                    |ext4 over LVM               |using boundaries
>             Summary|serious performance         |performance regression in
>                    |regression in "umount" on   |"umount" of filesystems
>                    |ext4 over LVM               |using barriers
>
>
>
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
