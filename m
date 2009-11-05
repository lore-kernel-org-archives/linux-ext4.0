From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14452] Syscall to ftruncate hangs on ext4 + mdadm raid0
 filesystem on a file preallocated with fallocate
Date: Thu, 5 Nov 2009 14:35:22 GMT
Message-ID: <200911051435.nA5EZMeu011614@demeter.kernel.org>
References: <bug-14452-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47334 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbZKEOfR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Nov 2009 09:35:17 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA5EZMp1011615
	for <linux-ext4@vger.kernel.org>; Thu, 5 Nov 2009 14:35:22 GMT
In-Reply-To: <bug-14452-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D14452





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org> =
 2009-11-05 14:35:18 ---
Reply-To: nablaman@gmail.com

Thank you for this information.
I will upgrade to .32 as soon as it is available and get back to the
list if it doesn't help the problem.
I may patch the kernel too before this if I get the time.

/Fredrik

On Thu, Nov 5, 2009 at 3:22 PM,  <bugzilla-daemon@bugzilla.kernel.org> =
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D14452
>
>
> Jan Kara <jack@suse.cz> changed:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 What =C2=A0 =C2=A0|Removed =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |Added
> ---------------------------------------------------------------------=
-------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CC| =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|jack@suse.cz
>
>
>
>
> --- Comment #1 from Jan Kara <jack@suse.cz> =C2=A02009-11-05 14:22:32=
 ---
> This looks like a deadlock that was fixed by commit
> 487caeef9fc08c0565e082c40a8aaf58dad92bbb. The fix went into vanilla k=
ernel
> shortly after 2.6.31 was released so you shouldn't see this deadlock =
anymore
> with 2.6.32. I'll attach the patch here for reference if you want to =
test it by
> itself.
>
> --
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Dema=
il
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
