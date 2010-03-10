From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space calculation
 on ext2 and ext3
Date: Wed, 10 Mar 2010 12:36:18 GMT
Message-ID: <201003101236.o2ACaI4a027540@demeter.kernel.org>
References: <bug-15420-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33839 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0CJMgT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 07:36:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2ACaIxm027542
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Mar 2010 12:36:18 GMT
In-Reply-To: <bug-15420-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=3D15420





--- Comment #7 from Thomas B=C3=A4chler <thomas@archlinux.org>  2010-03=
-10 12:36:12 ---
(In reply to comment #5)
> This sounds like the block reservation code for delayed allocation is
> over-aggressive about estimating how many blocks are need for the ind=
irect
> blocks in the case of indirect-mapped inodes (which would be what you=
 get when
> mounting an ext2 filesystem using the ext4 file system driver).
>=20
> This should be an aesthetic issue only, but it would be nice to have =
this be
> fixed.

It is not purely aesthetic, lots of applications abort their operation =
if space
is supposedly running low.

However, as this doesn't seem to be high priority for anyone here, we s=
hould
probably consider disabling EXT4_USE_FOR_EXT23 in our distribution kern=
el for
the time being.

(In reply to comment #6)
> Won't it make sence to use 'nodelalloc' by default when ext4 driver i=
s used
> for ext2 or ext3 filesystem? Because delayed allocation has some impl=
ications
> people need not expect - like the overestimation of needed blocks, or=
 changed
> semantics of ordered data mode etc...

Don't see a patch here.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
