From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Mon, 6 Jun 2011 19:59:06 GMT
Message-ID: <201106061959.p56Jx6Q0012255@demeter2.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:49460 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1FFT7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 15:59:07 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p56Jx6S5012256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 19:59:06 GMT
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D32182


Honore Doktorr <hdfssk@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |hdfssk@gmail.com




--- Comment #7 from Honore Doktorr <hdfssk@gmail.com>  2011-06-06 19:59=
:05 ---
I hit this problem with 2.6.35.13 after a power outage. The affected in=
ode was
empty & had no extents - these commands just returned nothing (was usin=
g
"debugfs 1.41.14 (22-Dec-2010)"):

# debugfs -R 'cat <122877>' /dev/mapper/Fedora-FedoraSystem
debugfs 1.41.14 (22-Dec-2010)
# debugfs -R 'dump_extents <122877>' /dev/mapper/Fedora-FedoraSystem
debugfs 1.41.14 (22-Dec-2010)

The file using this inode wouldn't respond to shell commands:

# find -inum 122877
/usr/libexec/gdm-simple-slave
# stat gdm-simple-slave
stat: cannot stat `gdm-simple-slave': Input/output error
# rm gdm-simple-slave=20
rm: cannot remove `gdm-simple-slave': Input/output error

Multiple fsck.ext4 runs didn't fix things. I eventually made the offend=
ing file
go away - I've no idea if this procedure is safe, or a good idea! - wit=
h these
commands.

# debugfs -R 'testi <122877>' /dev/mapper/Fedora-FedoraSystem debugfs 1=
=2E41.14
(22-Dec-2010)
Inode 122877 is marked in use
# debugfs -w -R 'kill_file <122877>' /dev/mapper/Fedora-FedoraSystem
debugfs 1.41.14 (22-Dec-2010)

# debugfs -R 'testi <122877>' /dev/mapper/Fedora-FedoraSystem=20
debugfs 1.41.14 (22-Dec-2010)
Inode 122877 is not in use
# ls /usr/libexec/gdm-simple-slave
ls: cannot access /usr/libexec/gdm-simple-slave: Input/output error
# debugfs -w -R 'rm /usr/libexec/gdm-simple-slave'
/dev/mapper/Fedora-FedoraSystem=20
debugfs 1.41.14 (22-Dec-2010)

# ls /usr/libexec/gdm-simple-slave
ls: cannot access /usr/libexec/gdm-simple-slave: No such file or direct=
ory
=E2=80=A2 ls gdm*
ls: cannot access gdm*: No such file or directory

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
