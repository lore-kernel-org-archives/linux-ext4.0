From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: v3.10: unmount won't work
Date: Tue, 14 May 2013 16:12:46 -0500
Message-ID: <5192A8CE.30809@redhat.com>
References: <51928CB5.2050406@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51928CB5.2050406@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/14/13 2:12 PM, Toralf F=C3=B6rster wrote:
> At a stable 32 bit stable Gentoo with kernel v3.10-rc1-113-ga2c7a54 I=
 cannot umount an (EXT4) fs
> which was created in a file located in a tmpfs partition and loop mou=
nted  :
>=20
> That file system was used to hold victims files shared via NFSv4 to a=
n user mode linux=20
> on which trinity was used to fuzz testing a patched UML guest kernel.
>=20
> n22 ~ # mount
> ...
> nfsd on /proc/fs/nfsd type nfsd (rw,nodev,noexec,nosuid)
> /mnt/ramdisk/disk0 on /mnt/trinity type ext4 (rw)

Is your "mount" looking at /etc/mtab ot at /proc/mounts?

What does /proc/mounts say, does it contain this device or mountpoint?

> n22 ~ # umount /mnt/trinity
> umount: /mnt/trinity: not mounted

-Eric
