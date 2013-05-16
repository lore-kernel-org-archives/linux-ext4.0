From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 22:50:10 +0200
Message-ID: <51954682.8040408@gmx.de>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55094 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3EPUuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:50:13 -0400
Received: from mailout-de.gmx.net ([10.1.76.32]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MCNrj-1Uldqf1fdJ-009Cad for
 <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 22:50:12 +0200
In-Reply-To: <51954330.1080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/16/2013 10:36 PM, Eric Sandeen wrote:
> so what does your /proc/mounts contain?

n22 / # cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / ext4 rw,noatime,data=3Dordered 0 0
devtmpfs /dev devtmpfs rw,relatime,size=3D4086480k,nr_inodes=3D203718,m=
ode=3D755 0 0
proc /proc proc rw,relatime 0 0
tmpfs /run tmpfs rw,nosuid,nodev,relatime,mode=3D755 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptm=
xmode=3D000 0 0
shm /dev/shm tmpfs rw,nodev,relatime 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relat=
ime 0 0
debugfs /sys/kernel/debug debugfs rw,nosuid,nodev,noexec,relatime 0 0
cgroup_root /sys/fs/cgroup tmpfs rw,nosuid,nodev,noexec,relatime,size=3D=
10240k,mode=3D755 0 0
openrc /sys/fs/cgroup/openrc cgroup rw,nosuid,nodev,noexec,relatime,rel=
ease_agent=3D/lib/rc/sh/cgroup-release-agent.sh,name=3Dopenrc 0 0
cpuset /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpu=
set 0 0
cpu /sys/fs/cgroup/cpu cgroup rw,nosuid,nodev,noexec,relatime,cpu 0 0
cpuacct /sys/fs/cgroup/cpuacct cgroup rw,nosuid,nodev,noexec,relatime,c=
puacct 0 0
memory /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,mem=
ory 0 0
devices /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,d=
evices 0 0
freezer /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,f=
reezer 0 0
blkio /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio=
 0 0
/dev/sdb4 /mnt/E fuseblk rw,nosuid,nodev,noexec,relatime,user_id=3D0,gr=
oup_id=3D0,default_permissions,allow_other,blksize=3D4096 0 0
tmpfs /mnt/ramdisk tmpfs rw,relatime,size=3D3145728k 0 0
rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,nosuid,nodev,noexec,relatime 0 0

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
