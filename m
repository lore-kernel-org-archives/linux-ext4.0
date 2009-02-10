From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12676] fs/ext4/extents.c: In function =?UTF-8?Q?_=E2=80=98ext4_ext_search_right=E2=80=99:?= fs/ext4/extents.c:1120: warning: =?UTF-8?Q?_=E2=80=98ix=E2=80=99?= may be used uninitialized in this function
Date: Tue, 10 Feb 2009 10:21:37 -0800 (PST)
Message-ID: <20090210182137.28812108042@picon.linux-foundation.org>
References: <bug-12676-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbZBJSWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Feb 2009 13:22:08 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1AILb53010715
	for <linux-ext4@vger.kernel.org>; Tue, 10 Feb 2009 10:21:38 -0800
In-Reply-To: <bug-12676-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D12676





------- Comment #2 from tytso@mit.edu  2009-02-10 10:21 -------
On Mon, Feb 09, 2009 at 03:15:49AM -0800, bugme-daemon@bugzilla.kernel.=
org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=3D12676
>=20
>            Summary: fs/ext4/extents.c: In function
>                     =E2=80=98ext4_ext_search_right=E2=80=99: fs/ext4/=
extents.c:1120:
>                     warning: =E2=80=98ix=E2=80=99 may be used uniniti=
alized in this
>                     function

> When compiling gets this error on Ext4 FS:
> "fs/ext4/extents.c: In function =E2=80=98ext4_ext_search_right=E2=80=99=
:
> fs/ext4/extents.c:1120: warning: =E2=80=98ix=E2=80=99 may be used uni=
nitialized in this
> function
> "

What version of gcc are you using to compile your kernel?  This looks
like the case of "gcc is stupid not to notice that depth must be
non-zero, so ix is always initialized".  Which doesn't seem to be the
case with gcc 4.3.2, but it might be true with an older version of
gcc.

We can shut up gcc by forcibly initializing ix, but if this is only a
problem with older gcc's, as it seems, it's probably best not to
clutter the source (and the compiled binary) with an unneeded
initialization:

        /* go up and search for index to the right */
        while (--depth >=3D 0) {
                ix =3D path[depth].p_idx;
                if (ix !=3D EXT_LAST_INDEX(path[depth].p_hdr))
                        goto got_index;
        }

        /* we've gone up to the root and found no index to the right */
        return 0;

got_index:
        /* we've found index to the right, let's
         * follow it and find the closest allocated
         * block to the right */
        ix++;
        ^^^^^ Gee, aren't (some verions of) gcc stupid?


                                                - Ted


--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
