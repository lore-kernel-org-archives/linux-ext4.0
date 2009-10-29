From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 21:25:22 GMT
Message-ID: <200910292125.n9TLPMlg004469@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39753 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZJ2VZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:25:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLPMk2004470
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:25:22 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D14354





--- Comment #144 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org=
>  2009-10-29 21:25:20 ---
Reply-To: parag.lkml@gmail.com

On Tue, Oct 27, 2009 at 6:15 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> Can you try this patch ?
>
> commit a8836b1d6f92273e001012c7705ae8f4c3d5fb65
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date: =C2=A0 Tue Oct 27 15:36:38 2009 +0530
>
> =C2=A0 =C2=A0ext4: discard preallocation during truncate
>
> =C2=A0 =C2=A0We need to make sure when we drop and reacquire the inod=
e's
> =C2=A0 =C2=A0i_data_sem we discard the inode preallocation. Otherwise=
 we
> =C2=A0 =C2=A0could have blocks marked as free in bitmap but still bel=
onging
> =C2=A0 =C2=A0to prealloc space.

Just wanted to let you know that I have applied this patch and one
unclean shutdown later it seems to have not given me any trouble.

I will continue testing it - hopefully I won't have to reformat  this
time ( every time I tested previously I ended up having weird issues
that I decided to get rid of by reformatting /).

Parag

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
