From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17872] ext4 does not honour chattr +s attribute
Date: Mon, 6 Sep 2010 02:55:08 GMT
Message-ID: <201009060255.o862t8rZ004494@demeter1.kernel.org>
References: <bug-17872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56746 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0IFCzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Sep 2010 22:55:10 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o862t8mu004495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Sep 2010 02:55:08 GMT
In-Reply-To: <bug-17872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D17872


Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |adilger.kernelbugzilla=
@dilg
                   |                            |er.ca




--- Comment #1 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca>  =
2010-09-06 02:55:05 ---
Please read the man page carefully:

       When  a  file  with  the  =E2=80=98s=E2=80=99 attribute set is d=
eleted, its blocks are
       zeroed and written back to the disk.  Note: please make sure  to=
  read
       the bugs and limitations section at the end of this document.
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:
:
BUGS AND LIMITATIONS
       The =E2=80=98c=E2=80=99, =E2=80=99s=E2=80=99,  and =E2=80=98u=E2=
=80=99 attributes are not honored by the ext2 and ext3
                                             ^^^
       filesystems  as  implemented  in  the  current mainline Linux ke=
rnels.
       These attributes may be implemented in future versions of the ex=
t2 and
       ext3 filesystems.


I agree it is a bug that the _man_page_ doesn't also mention ext4 as NO=
T
zeroing out blocks when "+s" is used.

It makes me wonder why these "features" are mentioned in the man page a=
t all,
since it never worked and there is no plan to make it work.  Since this
question comes up on a regular basis, it makes me wonder if it would be=
 better
to just remove mention of these options until they are actually impleme=
nted.=20
When they ARE implemented, they should list explicitly which filesystem=
s DO
support those features, rather than redirecting to the end of the docum=
ent.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
