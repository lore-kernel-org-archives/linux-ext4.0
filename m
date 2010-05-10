From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 14:52:16 GMT
Message-ID: <201005101452.o4AEqGeA001448@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35777 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0EJOxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 10:53:02 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4AEqfcN001576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 May 2010 14:52:43 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D15910





--- Comment #6 from Peng Tao <bergwolf@gmail.com>  2010-05-10 14:24:44 =
---
On Mon, May 10, 2010 at 10:56 AM,  <tytso@mit.edu> wrote:
>> The problem is, dpkg needs to guarantee the system is always usable,
>> and when a crash occurs, say when it's unpacking libc, it's not
>> acceptable for dpkg not to fsync() before rename() as it might end
>> up with an empty libc.so file, even if it might have marked the
>> package as correctly unpacked (wrongly but unknowingly as there's no
>> guarantees), which is not true until the changes have been fully
>> committed to the file system.
>
> Why not unpack all of the files as "foo.XXXXXX" (where XXXXXX is a
> mkstemp filename template) do a sync call (which in Linux is
> synchronous and won't return until all the files have been written),
> and only then, rename the files? =C2=A0That's going to be the most fa=
stest
> and most efficient way to guarantee safety under Linux; the downside
> is that you need to have enough free space to store the old and the
> new files in the package simultaneously. =C2=A0But this also is a win=
,
> because it means you don't actually start overwriting files in a
> package until you know that the package installation is most likely
> going to succeed. =C2=A0(Well, it could fail in the postinstall scrip=
t, but
> at least you don't have to worry about disk full errors.)
What about letting fsync() on dir recursively fsync() all
files/sub-dirs in the dir?
Then apps can unpack package in a temp dir, fsync(), and rename.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Thanks,
-Bergwolf

--- Comment #7 from Theodore Tso <tytso@mit.edu>  2010-05-10 14:42:13 -=
--
On Mon, May 10, 2010 at 10:22:47PM +0800, Peng Tao wrote:
> What about letting fsync() on dir recursively fsync() all
> files/sub-dirs in the dir?
> Then apps can unpack package in a temp dir, fsync(), and rename.

There are programs to do who execute fsync() on a directory, and they
do not expect a recursive fsync() on all files/subdirectories in a
directory.

At least for Linux, sync() is synchronous and will do what you want.
There is unfortunately not a portable way to do what you want short of
fsync'ing all of the files after they are written.  This case is
mostly optimized under ext3/4 (we could do a bit better for ext4, but
the performance shouldn't be disastrous --- certainly much better than
write a file, fsync, rename a file, repeat).

                    - Ted

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
