From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 29 Oct 2009 21:52:38 GMT
Message-ID: <200910292152.n9TLqc6w011962@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57798 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbZJ2Vwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:52:34 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9TLqc1q011963
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 21:52:38 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D14354





--- Comment #147 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org=
>  2009-10-29 21:52:36 ---
Reply-To: parag.lkml@gmail.com

On Thu, Oct 29, 2009 at 5:42 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Oct 29, 2009 at 05:25:17PM -0400, Parag Warudkar wrote:
>> > Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> > Date: =C2=A0 Tue Oct 27 15:36:38 2009 +0530
>> >
>> > =C2=A0 =C2=A0ext4: discard preallocation during truncate
>> >
>> Just wanted to let you know that I have applied this patch and one
>> unclean shutdown later it seems to have not given me any trouble.
>>
>> I will continue testing it - hopefully I won't have to reformat =C2=A0=
this
>> time ( every time I tested previously I ended up having weird issues
>> that I decided to get rid of by reformatting /).
>
> Cool!
>
> It looked like Avery Fisher had reported that had had tried patch
> didn't help him, and so I had put it in the category of "good patch,
> makes sense, but probably not the one that would solve this
> regression". =C2=A0But if it works for you, I'll accelerate getting i=
t to
> Linus. =C2=A0Do let us know if you have any additional problems with =
this
> patch, please!
>

I have gone through 3 unclean shutdowns so far - this time on Ubuntu
Karmic Release, today's -git and this patch.
Nothing odd to report.

[ Goes and crashes it again - comes back clean! ]

Since literally all of my previous attempts always resulted in
problems - something seems to have improved although there is no way
to tell if this is going to last long or that if it was Aneesh's patch
alone that improved things as last time i tried this I ended up
reinstalling and I switched to Karmic from Jaunty and I did not test
mainline for few days.

Any rate, I will let everyone know if I see anything different.

Thanks
Parag

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
