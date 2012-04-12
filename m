From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Thu, 12 Apr 2012 11:37:06 GMT
Message-ID: <201204121137.q3CBb6Fp027166@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:40222 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab2DLLhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2012 07:37:07 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3CBb6Wo027167
	for <linux-ext4@vger.kernel.org>; Thu, 12 Apr 2012 11:37:06 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D42986


Denys Vlasenko <vda.linux@googlemail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |vda.linux@googlemail.c=
om




--- Comment #13 from Denys Vlasenko <vda.linux@googlemail.com>  2012-04=
-12 11:37:05 ---
=46or the record: busybox's mkfs_ext2.c uses linux/ext2_fs.h.
If its include is commented out, the following errors pop out:

error: =E2=80=98EXT2_DFL_MAX_MNT_COUNT=E2=80=99 undeclared (first use i=
n this function)
error: =E2=80=98EXT2_DYNAMIC_REV=E2=80=99 undeclared (first use in this=
 function)
error: =E2=80=98EXT2_ERRORS_DEFAULT=E2=80=99 undeclared (first use in t=
his function)
error: =E2=80=98EXT2_FEATURE_COMPAT_DIR_INDEX=E2=80=99 undeclared (firs=
t use in this function)
error: =E2=80=98EXT2_FEATURE_COMPAT_RESIZE_INO=E2=80=99 undeclared (fir=
st use in this function)
error: =E2=80=98EXT2_FEATURE_COMPAT_SUPP=E2=80=99 undeclared (first use=
 in this function)
error: =E2=80=98EXT2_FEATURE_INCOMPAT_FILETYPE=E2=80=99 undeclared (fir=
st use in this function)
error: =E2=80=98EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER=E2=80=99 undeclared=
 (first use in this
function)
error: =E2=80=98EXT2_FT_DIR=E2=80=99 undeclared (first use in this func=
tion)
error: =E2=80=98EXT2_GOOD_OLD_FIRST_INO=E2=80=99 undeclared (first use =
in this function)
error: =E2=80=98EXT2_MAX_BLOCK_SIZE=E2=80=99 undeclared (first use in t=
his function)
error: =E2=80=98EXT2_MIN_BLOCK_LOG_SIZE=E2=80=99 undeclared (first use =
in this function)
error: =E2=80=98EXT2_MIN_BLOCK_SIZE=E2=80=99 undeclared (first use in t=
his function)
error: =E2=80=98EXT2_NDIR_BLOCKS=E2=80=99 undeclared (first use in this=
 function)
error: =E2=80=98EXT2_OS_LINUX=E2=80=99 undeclared (first use in this fu=
nction)
error: =E2=80=98EXT2_ROOT_INO=E2=80=99 undeclared (first use in this fu=
nction)
error: =E2=80=98EXT2_SUPER_MAGIC=E2=80=99 undeclared (first use in this=
 function)
error: invalid application of =E2=80=98sizeof=E2=80=99 to incomplete ty=
pe =E2=80=98struct ext2_inode=E2=80=99
error: invalid use of undefined type =E2=80=98struct ext2_group_desc=E2=
=80=99

struct ext2_inode is complex, I'd prefer to use system header than main=
taining
my own copy....

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
