From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: More ext4 acl/xattr corruption - 4th occurence now
Date: Wed, 13 May 2009 15:56:34 +0930
Message-ID: <20090513062634.GE4972@kulgan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+pHx0qQiF2pBVqBT"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:60456 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbZEMG0g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2009 02:26:36 -0400
Received: from kulgan.wumi.org.au (unknown [192.168.0.62])
	by mail.ucwb.org.au (Postfix) with ESMTP id B2D094BCAC
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2009 15:56:34 +0930 (CST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This fs really doesn't like whatever I am doing with it. Here is
another instance of corruption, again with the first symptom showing
up as corrupted acls and xattrs as the backup script crawls over the
directory structure:

getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.DF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.SMK: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.DF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.IF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.SMK: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.SMK: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLSOUR.DF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.IF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.SMK: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.IF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.DF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.DF: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.SMK: Input/output error
getfacl: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.SMK: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.IF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.IF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.SMK: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.SMK: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLSOUR.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.IF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.SMK: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.IF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.DF: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.SMK: Input/output error
getfattr: apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.DF: Input/output error
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.DF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.SMK" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.DF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.IF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.SMK" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.SMK" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLSOUR.DF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.IF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.SMK" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.IF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLORIG.DF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLOUTC.DF" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.SMK" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROB.DF" failed: Input/output error (5)
skipping non-regular file "apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLNATU.IF"

Again, here is the little breadcrumb left at the end of dmesg:

init_special_inode: bogus i_mode (36545)
attempt to access beyond end of device
dm-0: rw=0, want=256153956122632, limit=2147483648
attempt to access beyond end of device
dm-0: rw=0, want=256153956122632, limit=2147483648

And following the same formula as last time(s):

hermes:~# debugfs /dev/dm-0
debugfs:  stat "local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF"
invalid inode->i_extra_isize (8224)
Inode: 2542   Type: bad type    Mode:  0043   Flags: 0x5849462f
Generation: 538970637    Version: 0x66663030:535f4445
User: 538980401   Group: 538993001   Size: 996566576
File ACL: 538976288    Directory ACL: 0
Links: 8812   Blockcount: 35322822674750
Fragment:  Address: 538976288    Number: 0    Size: 0
 ctime: 0x41462d54:65636166 -- Tue Sep 14 08:59:24 2004
 atime: 0x4e4f4620:63206c61 -- Sat Aug 20 14:59:04 2011
 mtime: 0x594c494d:6972413d -- Fri Jun 23 08:18:45 2017
crtime: 0x726f6c6f:3138233d -- Sun Nov  3 13:24:39 2030
dtime: 0x7241203a -- Sun Sep 29 09:35:14 2030
Size of extra inode fields: 8224
BLOCKS:

debugfs:  imap "local/apps/OLD-APPS/APPS/NWAPPS/OAIII/OATEMP/F_CLPROF.IF"
Inode 2542 is part of block group 0
        located at block 447, offset 0x0d00

hermes:~# dd if=/dev/dm-0 of=block-447.dump bs=4k skip=447 count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.0121164 s, 338 kB/s

Now, this is (possibly) interesting - that block contains a bunch of
file data. Looks like a html email (I can tell it's email because of
the FIXED_ prefix added to the tags by the mail sanitizer).

If I can locate the source of that data, perhaps it will point to
where the corruption is coming from? Any tips on scanning for the
data? I'll start with simple find and grep and see how far I get.

Regards,
Kevin.

--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="block-447.dump"
Content-Transfer-Encoding: quoted-printable

; COLOR: #8100ff; FONT-FAMILY: Arial"><BR>1180. =0D
                              Kamilla Leonczuk, =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:PLACE><FIX=
ED_ST1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE:=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=B2=0F=08=80=08=
=00=00=00=AA=EC=A9=8D=1F=1D=02=00=B3-
=00=00=00=00=00=1E=1D=02=00 =1D=02=00]=00=00=00=16=00=00=00=BA=0F=02=00=82=
=08=00=00=00=00=15=B4=00=06=10J=08=00=00=00 10pt; COLOR: #8100ff; FONT-FAMI=
LY: Arial">Morgan =0D
                              Hill</FIXED_SPAN></FONT></B></FIXED_ST1:CITY>=
<B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"> =0D
                              , =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:STATE><B><=
FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">CA</FIXED_SPAN></FONT></B></FIXED_ST1:S=
TATE></FIXED_ST1:PLACE><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"><BR>1181 =0D
                              &nbsp;Edmund Perry, =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:PLACE><FIX=
ED_ST1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">MountainView</FIXED_SPAN></FONT></B></F=
IXED_ST1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"> =0D
                              , =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:STATE><B><=
FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">CA</FIXED_SPAN></FONT></B></FIXED_ST1:S=
TATE></FIXED_ST1:PLACE><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"><BR>1182 =0D
                              &nbsp;Sheri Simmen, =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:PLACE><FIX=
ED_ST1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">Morton</FIXED_SPAN></FONT></B></FIXED_S=
T1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"> =0D
                              , =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:STATE><B><=
FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">IL</FIXED_SPAN></FONT></B></FIXED_ST1:S=
TATE></FIXED_ST1:PLACE><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial"><BR>1183. =0D
                              Cami Ross - =0D
                              </FIXED_SPAN></FONT></B><FIXED_ST1:PLACE><FIX=
ED_ST1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
                              style=3D"FONT-WEIGHT: bold; FONT-SIZE: 10pt; =
COLOR: #8100ff; FONT-FAMILY: Arial">Peoria</FIXED_SPAN></FONT></B></FIXED_S=
T1:CITY><B><FONT =0D
                              face=3DArial color=3D#8100ff size=3D2><FIXED_=
SPAN =0D
       =20
--+pHx0qQiF2pBVqBT--
