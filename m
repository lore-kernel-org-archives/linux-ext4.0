From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: Fw: [Bugme-new] [Bug 8643] New: Bug with negative timestamps on 64bit machines
Date: Sun, 17 Jun 2007 13:43:31 +0400
Message-ID: <20070617094331.GF14349@localhost.sw.ru>
References: <20070616230527.e26f66d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:2327 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbXFQJnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jun 2007 05:43:21 -0400
Content-Disposition: inline
In-Reply-To: <20070616230527.e26f66d9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 23:05 =D0=A1=D0=B1=D1=82 16 =D0=98=D1=8E=D0=BD     , Andrew Morton w=
rote:
>=20
> someone ort to fix this
duplicate: http://bugzilla.kernel.org/show_bug.cgi?id=3D5079
Already fixed by:
commit 4d7bf11d649c72621ca31b8ea12b9c94af380e63
Author: Markus Rechberger <Markus.Rechberger@amd.com>
Date:   Tue May 8 00:23:39 2007 -0700
I don't have sufficient permission to change bug status, so
let's someone else do it.
>=20
>=20
> Begin forwarded message:
>=20
> Date: Sat, 16 Jun 2007 17:50:35 -0700 (PDT)
> From: bugme-daemon@bugzilla.kernel.org
> To: bugme-new@lists.osdl.org
> Subject: [Bugme-new] [Bug 8643] New: Bug with negative timestamps on =
64bit machines
>=20
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D8643
>=20
>            Summary: Bug with negative timestamps on 64bit machines
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.21-1.3228.fc7
>           Platform: All
>         OS/Version: Linux
>               Tree: Fedora
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: markus.mottl@gmail.com
>=20
>=20
> Most recent kernel where this bug did not occur:
> Distribution: Fedora Core 7
> Hardware Environment: AMD Athlon 64
> Software Environment:
> Problem Description:
>=20
> Negative timestamps (i.e. before 1970) are incorrectly handled due to=
 some
> obvious 64bit issues.  They show up normally as long as the cache has=
 not been
> purged.
>=20
> Steps to reproduce:
>=20
> Touch a file in an ext3-file system with a negative timestamp, e.g.:
>=20
>   # touch -t 196901010000 /opt/foo
>=20
> Unless you have been writing a lot of data to this partition after th=
e last
> command, the next one should display the following:
>=20
>   #  ls -l /opt/foo
>   -rw-r--r-- 1 root root 0 1969-01-01 00:00 /opt/foo
>=20
> This is still correct.  But now we purge the file system cache by unm=
ounting
> and mounting the partition again:
>=20
>   # umount /opt/foo
>   # mount /opt/foo
>=20
> Now the timestamp will be corrupted:
>=20
>   # ls -l /opt/foo=20
>   -rw-r--r-- 1 root root 0 2105-02-07 06:28 /opt/foo
>=20
> It seems obvious that the upper 32 bits of the 64 bits representing t=
he time
> stamp get lost, which explains the above observation.
>=20
> On 32bit architectures there is no such problem.  I haven't managed t=
o
> reproduce this problem with other file systems (e.g. XFS).
>=20
>=20
> --=20
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Dema=
il
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
