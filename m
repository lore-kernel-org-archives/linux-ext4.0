From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] blkid detection for ZFS
Date: Thu, 14 Feb 2008 18:07:40 -0700
Message-ID: <20080215010740.GZ3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_ugIBqQ0d8bX01sxgq5XDwA)"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52443 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbYBOBHs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 20:07:48 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1F17lrD019723
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 17:07:47 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW900D019RN0C00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 14 Feb 2008 17:07:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_ugIBqQ0d8bX01sxgq5XDwA)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline

Attached is a patch to detect ZFS in libblkid.  It isn't by any means
complete, because it doesn't report the LABEL or UUID of the device,
nor names any of the constituent filesystems.  The latter is quite
complex to implement and may be beyond the scope of libblkid.

Some input is welcome here also...  There is a UUID (GUID) for the whole
"pool" (aggregation of devices that ZFS filesystems might live on), a
UUID for the "virtual device" (vdev) (akin to MD RAID set) that a disk
is part of and also a separate UUID for each device.  There is a LABEL
(pool name) for the whole pool, but not one for an individual filesystem.

I'm thinking of making the blkid UUID be the GUID of the whole pool, as
any device in the pool would be sufficient to locate all of the component
devices.  This means all devices in the same pool will return the same
UUID, but for identification that should be fine I think...  I haven't
checked for pathologies in libblkid regarding that yet.

On a related note - on Solaris the ZFS filesystems always live in a GPT
partition table, and I note that libblkid doesn't identify this.  Is that
something we want to start adding to libblkid (e.g. GPT, DOS, LVM, etc)?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_ugIBqQ0d8bX01sxgq5XDwA)
Content-type: text/plain; NAME=e2fsprogs-blkid-zfs.patch; charset=utf-8
Content-transfer-encoding: QUOTED-PRINTABLE
Content-disposition: attachment; filename=e2fsprogs-blkid-zfs.patch

Index: e2fsprogs-cfs/lib/blkid/probe.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
--- e2fsprogs-cfs.orig/lib/blkid/probe.c
+++ e2fsprogs-cfs/lib/blkid/probe.c
@@ -647,6 +647,21 @@ static int probe_jfs(struct blkid_probe=20
 =09return 0;
 }
=20
+static int probe_zfs(struct blkid_probe *probe, struct blkid_magic *=
id,
+=09=09     unsigned char *buf)
+{
+=09struct zfs_uber_block *zub;
+=09char *vdev_label;
+=09const char *pool_name =3D 0;
+
+=09zub =3D (struct zfs_uber_block *)buf;
+
+=09/* read nvpair data for pool name, pool GUID (complex) */
+=09//blkid_set_tag(probe->dev, "LABEL", pool_name, sizeof(pool_name)=
);
+=09//set_uuid(probe->dev, pool_guid, 0);
+=09return 0;
+}
+
 static int probe_luks(struct blkid_probe *probe,
 =09=09       struct blkid_magic *id __BLKID_ATTR((unused)),
 =09=09       unsigned char *buf)
@@ -896,15 +911,6 @@ static int probe_hfsplus(struct blkid_pr
 }
=20
 /*
- * BLKID_BLK_OFFS is at least as large as the highest bim_kboff defi=
ned
- * in the type_array table below + bim_kbalign.
- *
- * When probing for a lot of magics, we handle everything in 1kB buf=
fers so
- * that we don't have to worry about reading each combination of blo=
ck sizes.
- */
-#define BLKID_BLK_OFFS=0964=09/* currently reiserfs */
-
-/*
  * Various filesystem magics that we can check for.  Note that kboff=
 and
  * sboff are in kilobytes and bytes respectively.  All magics are in
  * byte strings so we don't worry about endian issues.
@@ -954,6 +960,8 @@ static struct blkid_magic type_array[] =3D
   { "iso9660",=0932,=09 1,  5, "CD001",=09=09probe_iso9660 },
   { "iso9660",=0932,=09 9,  5, "CDROM",=09=09probe_iso9660 },
   { "jfs",=0932,=09 0,  4, "JFS1",=09=09=09probe_jfs },
+  { "zfs",     128,=09 0,  8, "\0\0\0\0\x00\xba\xb1\x0c", probe_zfs =
},
+  { "zfs",     128,=09 0,  8, "\x0c\xb1\xba\x00\0\0\0\0", probe_zfs =
},
   { "hfsplus",=09 1,=09 0,  2, "BD",=09=09=09probe_hfsplus },
   { "hfsplus",=09 1,=09 0,  2, "H+",=09=09=090 },
   { "hfs",=09 1,=09 0,  2, "BD",=09=09=090 },
@@ -1074,7 +1082,7 @@ try_again:
 =09=09if (!buf)
 =09=09=09continue;
=20
-=09=09if (memcmp(id->bim_magic, buf + (id->bim_sboff&0x3ff),
+=09=09if (memcmp(id->bim_magic, buf + (id->bim_sboff & 0x3ff),
 =09=09=09   id->bim_len))
 =09=09=09continue;
=20
@@ -1104,7 +1112,7 @@ try_again:
 =09=09dev =3D 0;
 =09=09goto found_type;
 =09}
-=09=09
+
 found_type:
 =09if (dev && type) {
 =09=09dev->bid_devno =3D st.st_rdev;
@@ -1113,7 +1121,7 @@ found_type:
 =09=09cache->bic_flags |=3D BLKID_BIC_FL_CHANGED;
=20
 =09=09blkid_set_tag(dev, "TYPE", type, 0);
-=09=09=09=09
+
 =09=09DBG(DEBUG_PROBE, printf("%s: devno 0x%04llx, type %s\n",
 =09=09=09   dev->bid_name, (long long)st.st_rdev, type));
 =09}
Index: e2fsprogs-cfs/lib/blkid/probe.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
--- e2fsprogs-cfs.orig/lib/blkid/probe.h
+++ e2fsprogs-cfs/lib/blkid/probe.h
@@ -190,6 +190,16 @@ struct jfs_super_block {
 =09unsigned char=09js_loguuid[16];
 };
=20
+#define UBERBLOCK_MAGIC         0x00bab10c              /* oo-ba-blo=
c!  */
+struct zfs_uberblock {
+=09__u64=09=09ub_magic;=09/* UBERBLOCK_MAGIC=09=09*/
+=09__u64=09=09ub_version;=09/* ZFS_VERSION=09=09=09*/
+=09__u64=09=09ub_txg;=09=09/* txg of last sync=09=09*/
+=09__u64=09=09ub_guid_sum;=09/* sum of all vdev guids=09*/
+=09__u64=09=09ub_timestamp;=09/* UTC time of last sync=09*/
+=09char=09=09ub_rootbp;=09/* MOS objset_phys_t=09=09*/
+};
+
 struct romfs_super_block {
 =09unsigned char=09ros_magic[8];
 =09__u32=09=09ros_dummy1[2];
Index: e2fsprogs-cfs/lib/blkid/tests/zfs.results
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
--- /dev/null
+++ e2fsprogs-cfs/lib/blkid/tests/zfs.results
@@ -0,0 +1 @@
+TYPE=3D'zfs'
Index: e2fsprogs-cfs/lib/blkid/tests/zfs.img.bz2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
--- /dev/null
+++ e2fsprogs-cfs/lib/blkid/tests/zfs.img.bz2
@@ -0,0 +1,18 @@
+BZh91AY&SYg=8F=EB=9C
+=3D0=8D'=88=D3=13M2z=11=A7=A1=1AbL2i=A4=F6=A3i=A8i=94=F4=CD dz=86=
=8D3=10di=89=82LOL=93=06SL=A7=8DB=15#Rz=0C=A9=E6=89=A7=A3Jy=A4=9E=
=13&=A7=9AM1=11=E14=F4i0
+m=0D2L=9E=99O4=9A=9E=9BSPz=9F=A2=9E=13I=E5<=A7=A6=98=A7=A3=0DCOS=
=D0&=0C&=86=9ALhd=D3T=F6I=A9=93=CD'=A15<=A3=D3M2z=A7=A9=FAj'=A4=C3=
=11=0C=84=09=E2M=8Ah=F4=D2=18=8C=D4=C9=E8M=A4=C4=F4=9E=A3=10=C9=93'=
=A1=1A=18h=87=A6Q=B4=D4=F2M=92cD=C9=8DO)=E8L2=016=9A#M2i=A1=89=93=
=1A=81=E9=3DLL=9A=0D4=C4=1BP=D3OD=18=9A2=3DOP=D3@e=0C=9AS=C6=A7=A6E?H=
=C8=F55=1F=A4Oi=0FI=E4=13=CD&=11=93#Q=94=FD=14=FC=99S=C4=DA=A7=E54=
=8FF=D4=D3
+z=9A6hS=C8fSS=D2~=89=A4=F2O=D2=9E=D5?T=FD=14=1F=8A=1A=9E)=B4=DA=A7=
=9Aj=9E(=F2=8F=D4=F5=3D(=3DOh=D2=9E=9A=8FS4=8D4=FDI=EA?T=D3=C9=A6=
=D5=08=A4M6=91<M=A0=9Ah2OF=9A4Lh=9BD=D3S=D2xSzS=C9<=A7=94f=9AOP=F3I?T=
=DA=9Ei5=1EM'=A6=98=A6y=09=89=3D5=3D=0C=A3=CA4=F4=9E=A7=A9=EAz=9ES=
=C4=C5=3D=A5<=D2a=13=F4)=E9=94=1EQ=E1OS=D4=F2f=94=D8=A7=EA=9EP=CCS=
=F54=D4=09=12=90!=91=01=06F=99=19=A6=90=0D=19=0C 4=C4=0D4d=D1=A6=8D=
=1A22z=86=8FB=1Al=A1=A7=944d`=9Ah=D0h=C9=A04=D1=A0=06F=9A=1A=01=91=
=A7=A9=A6=80=D1=A7=A4=1Ah=1E=A0=C8h=0B=E8(=C5=E2=B1=B2]&=02=80Z@X=
=AC_E=90rQg*rtLm=BC=A2a=D0=13j=9F=F5$=DBf6~GQ=EDW=FCZ=FB"=B7!=B6=CD=
=D4p6=DBw=0Bm=C2=E5q=A8=A7=9DOq=B4TO=A0=A6B!=A0m9=F3fN=9D6t=FA=13=
=E7=D0=A0Ph=18=D0=EB=F7=CC/[=A6=AA=F5~=A9=DA=EC>=BE=CEl7=92=86=93e=
=FC=FC=F81=9D=9C=99=91=AE=F7=FB3'=D4e=8E=A1=07'=DA=AAB=C6=15=A2=BD=
=A8=F0=FFj=E4=A3=E7=D3=F3=C5=EAU=F0"=10<=F0=89/=BF=F1=0C=CF=98Y=09=
=A4?K=15=D2}=ABuC=92=BB=EFW=0E6l=96a>E=9E=BA=D8=E2'=99=D5=F3=08z=85=
=F4;5=E8=CD=05=E9=D8=CC=EB=CE=EF=949=D6=CB=91=E4=82=82=016
+=92=8C]H=B0S0=F3bd=AAlt=AA&=F2T=94l=83=E6=E7=E7=CD=B7N=05??+;Lx=13"=
=F76$=04$=DB=88H=10%=D3=B0@Q=B0=10=95SEK@=82=E8=C1.=15=AD=93=C8I*L=
=8E*M=E6Q)=3D=8D=E6\=A9@=84=9E=C2+=1C=8CxhBI!W=B1$=B4=AD=02=10X4=82=
=A1=880=ED=09=16,=A3g$=C8}=0B[=16=8B=16=90=92=A5f=AD=88
+=A5=C0=B3=CE=81=18|=D68X=962=B0=BE4=CF=C6=8DJ=CA=D4#=D18_=18p<rK=
=D9=A6=8A=F3K=16=C3=1C
+=D2=1Aw!?C?=BB=80=F3a=CF=E0RT8L`m=F6=0F$=0F=E5=ABE)=06ME=C7=3D=D2=
=96=AA1=9B*_&_=8Fb=DBw=88Y=1CQ=FF=B2=8DU@=EB=9F=DD=B6=88=FBU<=92=DD=
=BC=AA<=B5=8F=B7=0C=0C=C6=91A=CF=D7=E1=92t=A9=DCn=C5=BD=D1J8=B6=E6=
=C6#=DCI=B7=D9=DC=B2=E9x=F5=FD3=9BYf=15=07*I=DF=F0=B5h=97=9C$3=A2=
=3D=1Dsh!=FA=A4>i=D4=1A>=D3=85=F5=17=A6=F0=F1=A0=8E!X=83=BC=8F=A3u=
=8F2{=EF=F2A=17=AC=EB=9B=0Ct=E7O=11=82}=F1
+E=19=DB~=D8=D6=9F=84=16=8E=85=87=1A=C8=EBTWj=DE=9B=DB=EE=C6'9u+=9E+=
=E6=F9=E3=BF=86D=85=07,=94=A1=8A=D9=8E=06Ul]=13=E0=A3=BAZ=9A=81*8/=
=BD=D4=E3=D0D0=B3=FD=FA=D6=ABw=98=B4h=14=BA*=18=DE=8AC =03=E5=07=D3=
=97=CD6N[=1En B=F9}=D7=0CIA=A5=95=CE=BAXQ=FC<(=B5=D3=16=EF=FF=E2=12=
=94=13=17=15yZ!e=83=A7(=EB=FA=AC=AD=BC=C3=80=B2k=1A=19=AD=E0\=CCG%Z@=
=B0w=DD=A1=CA=EDI=1D=94=E8#=B0!=C6=8B=E0.n=E5<=BE=D5O=F0=F7=B6=B1=
=9C=8Dz=14@=9C`=C9N=D4=DCD=A7;=FB=14G`=CE+=FB=DA=0D=ED=F0=B8=DDtY=
=ED_?=A3=F1q=CA=E9=DD=03=D1=DEK=F3=01d6Sa=B3L=F2=DB=DD=F1=D9=BDv=CA=
=83=E0FU=8D=EE=C4=D5K=E1=19=1C=AAq=AC=84=13=EB=DD~=09=EC=91
+0(=02=8AF=C7T=F8=80}Ku=A4=9E=96=86x=EE4
+=03=C847=BE=A2=C1=EC=3DL=D5p[=F7=F7=CDZv=D5=DB=EBb=DAkP=F6=F6=1A=
=17=0E=9FH=EC=C4t,=0E=E2d=0B=B4=E8X=89e=B7K=FB=14=A0=E0
+#=E1=1A=AE=EC=E29U=EB=BF=1A=DC=3DWT=10=E7=A3r=BB=9A=F3=19"c=E0=EE=
=CE=CDq=D8=1F=AC=DEY=A2=1D:=7F=1B#=B6f)
+=3D=A4=0F=AC=95=1A=9EM=FD=C3/5]/\A{=E9~Cz|gN:F=A0o=CE=05=FE#=DF[?7@=
=FF=17=DB5=86=A4=CA?=AC`=EFlQ^;=B3x=AC=E4=CDT=A6=85=D2=E8=F8=A5ek=
=DF#u=D9=9A=C7=16C;=FE=A7=12=81=D9=C5=BE.@=8Fj=80=1B=BA=A2=93}sP=C8+'=
=82=03"=1E=1C=BE=D6\=8A[n=BE=B6=C3=A7/=C5=F2=B3=A7=8F=CBh=D3i=16XbS=
=D2T<=F8=B3=9D=08=05=DB=E3n<_=AD=BCN=9C=A5=A4=CC=B1I`=D8=12}=CE=88=
=10=8A=1E=A1=9Cm=A5=AFaj=19=F1Q=DD=1B=12=D9=DBuw=A2=D7=11Z8UadV=1F=
=C9=F0OJ=12=86=0F,d=02*O=FC=1C=CE%=E6|f=B4=F3a=95=B6=3D=B8=9C4=B6=
=FFK=BEi=BBIT=A6=A3
+=B2=B0=83G=A1eb=AE=A3r=F96=0FJ^:=8D>vO=E8=A8i=AA =F8@j=B3=FE=1E=BC=
=0D=C4=B3k=0F=F3=E730Ls=B3=B1=C1=95=08=0C=18
+}=B5=160S=CCI=C7D=95=D6i6I=8F=A0 ,B=8D=1F.r=AA=88=15=D6=DFiR=F5=86=
=95=ABJT=F5=D3z=0C=8A=DA=CDD=D2P=12=86'[=04=91=B4=D2P=B9=D2u=03=88=
=0D=BB=08^=07=A1X:=0D=81
+-=C4=1A=97=16]=A2=F8-=1C=F4G=BC=B4$=8D=ED=E2=CE=B0=8Cc}=9C=89=EC$RI=
=15=A5)E=AD=B4~=90
+=D7=E9=10=E5d0=0F=9E=8B:=A0=E8I=BF#=15=B2<pd!=E2=DC=05=D6=D8=FF59=
=1D8=12=DDm=AC=0F=A9=A6=D6=94=AC=086=0C=C7=0B9^=DB=90=A5i[=0D=BE=A1=
=F1=99?=8AI=F4=E8WU=0EL=B7/>e=15Y=EB=D36T3=F1=94=09=18=FC2=ED=05=E7 *=
=13K=81=F0h=D7=F0=BC=1DK=034=C9=F33=06[=C3=AA=14=F5=D6=05=D8=14=09=
=15^=03%9Q=16V=0C=C8=FEm=9EB=E1mo0=D2q=F4"=AA=A5"=E9=B0Z=1A=1E=E2(=
=C2=BB=FA=C9$
++=86=F2]=E18=A2=99=C6=FC=C9X=F7Pd=C9=C4F=E4=9E=EFXf=B2^Z=F6W=C7w=
=19=86D=8C=AC7=08=DF=E8=14U=152=F5=C95=1A=FE'=BD=1DU=F8Y=D9=AF=AA&!t=
=9D^Q=E3Y=C3=AAA=C1=C4=A3=BEw=DF=A3=9C=D8U2{=04=B8=10=83=E4=A4=F6L=
=08IL(=85=FAm?=EF=ED"=BD3=F8Z[H#=E8=9F=CCVh=C7gb=C1=FBh=C4=11u=B3=
=91=0Bf=F1jZ=02=DC~=8E|Lc+=D3=86U=F3=D9=EA=3D=8C2=E7=AB=DE=CA,C=7F =
=0E=E1=F3=99q=E7=C7O=99SR=9D$=C2=AB=FC=D2!=C4=C0=B6=7Fa=E1=C2=ECn=
=16J9=A8=02=B3=85=C8=1D=C6}V=08=1Ft=DA=9C>G=D6=E2=E6=ED=88J=9B=CC=
=BE=A0=A4=03=B3~=18<=BEM1=DF>7=E5)OY=F2=E8+=B9Tj=DA=16=E8-=95b=1Cc=
=9F=CBi=80s=C1$=FB=E6=A8=C1=AF=B4=DD=7FT)=BD=C2=DB=17Cb=C0K*=DF=B1=
=89=F7=7F=B6=9B6X=12R=AB6_=90=A5"=96=88!oX[=C5=11=A7=D1=1B=17o=8F=
=EA=0B=B5=EA=A0~=9B=D0=9D=C5=BE0[=A1NZ=F6=8EdY=CD`=F5=11"=82n=8C=12I
+=FF=9A=FB'w=B7=CB=FE=16=EB=E2h=B5W=DF=D3gI]=AC=C7r|=15%=A7=B0=E5t=
=95=D64=96=DC=EE=873=F9=FA=93=EF=07\y@B=0C=06=CE=D7?=B0u=E8=BCW|=AAZ=
=FF=C4=FEzm=84h=F8=1Eg=C4E=F1%]=CD=CE=BF=AA=B5=C5=DD=8E~=B9n=0B/=FB=
=CD=B6=A7=FF=C5=DC=91N=14$=19=E3=FA=E7
\ No newline at end of file

--Boundary_(ID_ugIBqQ0d8bX01sxgq5XDwA)--
