From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: More ext4 corruption
Date: Sat, 4 Apr 2009 08:45:09 +1030
Message-ID: <20090403221508.GA5436@kulgan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:54691 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbZDCWPP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Apr 2009 18:15:15 -0400
Received: from kulgan.wumi.org.au (cubit.disenchant.net [150.101.102.147])
	by mail.ucwb.org.au (Postfix) with ESMTP id CBE014BCB2
	for <linux-ext4@vger.kernel.org>; Sat,  4 Apr 2009 08:45:11 +1030 (CST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm seeing some more corruption on our ext4 filesystems. Last night's
backup job had these errors:

getfacl: apps/CIM8/Release-Notes/rb_200809_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rb_200810_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200503_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rb_200804_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rb_200803_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200505_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rb_200811_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200409_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200509_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200508_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200611_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200608_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200705_01.pdf: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200410_01.htm: Input/output error
getfacl: apps/CIM8/Release-Notes/rc_200709_01.pdf: Input/output error
getfattr: apps/Gestalt.Net/SetupCD/program\040files/Business\040Objects/Common/3.5/bin/RptControllers.dll: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200809_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200810_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200503_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200804_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200803_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200505_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200811_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200409_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200509_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200508_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200611_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200608_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200705_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200410_01.htm: Input/output error
getfattr: apps/CIM8/Release-Notes/rc_200709_01.pdf: Input/output error
getfattr: apps/CIM8/Release-Notes/rb_200803_02.pdf: Input/output error
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rb_200809_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rb_200810_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200503_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rb_200804_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rb_200803_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200505_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rb_200811_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200409_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200509_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200508_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200611_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200608_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200705_01.pdf" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200410_01.htm" failed: Input/output error (5)
rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200709_01.pdf" failed: Input/output error (5)
IO error encountered -- skipping file deletion
skipping non-regular file "apps/CIM8/Release-Notes/rb_200803_02.pdf"
rsync error: some files could not be transferred (code 23) at main.c(1524) [generator=3.0.3]
setfacl: apps/CIM8/Release-Notes/rb_200803_02.pdf: No such file or directory

The "apps/Gestalt.Net/..." error is an old one and I need to chase
that up some more[1]. The corruption in the "Release-Notes" directory
is new last night.

My initial information gathering is below. Let me know what else might
be helpful, but I'll have to fsck before Monday.

 [1] http://marc.info/?l=linux-ext4&m=123695451828101&w=2

Regards,
Kevin.

hermes:~# ls -l /srv/samba/local/apps/CIM8/Release-Notes/
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rb_200809_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rb_200810_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200503_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rb_200804_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rb_200803_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200505_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rb_200811_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200409_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200509_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200508_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200611_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200608_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200705_01.pdf: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200410_01.htm: Input/output error
ls: cannot access /srv/samba/local/apps/CIM8/Release-Notes/rc_200709_01.pdf: Input/output error
total 893470578284388
-rwxrwx---+     1 root          WUM3\it - dataadm      25729 2005-03-14 10:12 as_200503_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2125 2005-06-16 05:39 as_200506_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      16850 2006-04-10 12:07 as_200604_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       8604 2007-06-17 21:35 as_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5711 2007-07-16 10:11 as_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       8638 2008-05-27 13:15 as_200804_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5890 2008-07-31 09:50 as_200807_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5766 2008-12-13 20:30 as_200810_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       5636 2005-03-14 10:24 br_200503_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2349 2006-03-27 12:07 br_200604_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1116 2006-11-07 09:42 br_200608_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1065 2007-01-16 09:09 br_200612_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       8191 2007-05-17 11:20 br_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6518 2008-05-27 13:15 br_200804_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5911 2008-05-27 13:15 br_200805_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5779 2008-12-13 20:30 br_200809_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5844 2008-12-13 20:30 br_200810_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      10537 2005-04-07 16:20 cq_200504_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1033 2006-03-20 09:08 cq_200602_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       5802 2007-05-17 11:21 cq_200705_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       1255 2005-02-10 11:48 cr_200502_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      31876 2005-03-31 14:48 cr_200504_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1098 2005-07-26 14:36 cr_200507_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1028 2006-03-21 15:29 cr_200509_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm       6994 2007-06-17 21:37 cr_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5706 2007-07-16 09:12 cr_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6489 2007-09-03 09:29 cr_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6107 2007-09-17 19:18 cr_200709_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6299 2008-12-13 20:30 cr_200802_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm      14529 2008-12-13 20:30 cr_200806_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5985 2008-12-13 20:30 cr_200810_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm     101693 2004-11-02 13:46 cs_200411_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      16893 2004-12-10 09:57 cs_200412_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1089 2005-01-28 14:49 cs_200501_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       4208 2005-01-28 14:49 cs_200501_03.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      12921 2005-04-08 10:56 cs_200504_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2778 2005-09-05 09:21 cs_200504_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1061 2005-09-05 09:21 cs_200506_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       5501 2005-09-05 09:21 cs_200506_03.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      57601 2005-08-26 13:19 cs_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2156 2005-09-08 22:06 cs_200509_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2150 2005-09-20 06:03 cs_200509_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       5476 2005-09-21 12:48 cs_200509_03.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       4368 2006-01-11 09:15 cs_200601_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       3220 2006-05-23 14:52 cs_200605_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm      25370 2006-08-18 14:39 cs_200608_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm      14517 2006-10-24 10:53 cs_200609_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1110 2006-11-07 09:42 cs_200610_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       5907 2007-01-16 09:09 cs_200612_01.htm
-rw-rw----+     1 WUM3\kmshanah WUM3\it - dataadm      56829 2007-10-31 11:56 cs_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6422 2007-11-13 09:59 cs_200711_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6634 2007-11-23 14:50 cs_200711_03.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       9023 2007-12-12 15:06 cs_200712_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6689 2007-12-18 17:04 cs_200712_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6200 2008-01-04 12:12 cs_200801_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       2978 2006-04-07 17:02 dr_200202_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1155 2006-04-07 17:02 dr_200202_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      15965 2006-04-07 17:02 dr_200301_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       8506 2006-04-07 17:02 dr_200403_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      14571 2006-04-07 17:03 dr_200503_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2094 2006-04-07 17:03 dr_200507_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       5426 2006-04-07 17:03 dr_200512_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       6202 2007-06-17 21:39 dr_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5701 2007-07-16 09:13 dr_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5961 2008-01-23 11:20 dr_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6392 2008-01-23 11:20 dr_200711_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       1085 2005-02-28 14:27 gl_200503_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      34405 2005-03-29 12:22 gl_200503_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2101 2005-07-27 21:52 gl_200507_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      18316 2006-04-10 12:41 gl_200604_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       1469 2006-04-27 11:34 gl_200604_03.htm
-rw-rw----+     1 root          WUM3\it - dataadm      11493 2007-06-17 21:39 gl_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5711 2007-07-16 09:12 gl_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5860 2007-08-16 14:43 gl_200708_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6033 2007-09-04 09:41 gl_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6294 2008-05-27 13:15 gl_200803_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       8623 2008-05-27 13:15 gl_200804_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6055 2008-05-27 13:15 gl_200805_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5793 2008-12-13 20:30 gl_200808_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6060 2008-12-13 20:30 gl_200810_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       1078 2004-10-19 16:05 pd_200407_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       3531 2005-04-08 10:56 pd_200504_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       4701 2005-08-26 13:20 pd_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1089 2006-01-11 09:31 pd_200601_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       7126 2007-09-19 14:05 pd_200709_02.pdf
-rw-rw----+     1 WUM3\kmshanah WUM3\it - dataadm       6632 2007-10-31 11:56 pd_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5902 2007-11-28 09:04 pd_200711_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5979 2008-12-13 20:30 pd_200802_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6076 2008-12-13 20:30 pd_200805_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5847 2008-12-13 20:30 pd_200807_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5727 2008-12-13 20:30 pd_200809_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      65735 2005-05-23 14:19 py_200506_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2165 2005-06-16 05:40 py_200506_02.htm
-rw-rwx---+     1 root          WUM3\it - dataadm      81171 2006-06-26 08:28 py_200605_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       7286 2006-06-26 08:28 py_200606_02.htm
-rw-rwx---+     1 root          WUM3\it - dataadm        999 2006-06-26 08:28 py_200606_03.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       2026 2006-06-26 08:28 py_200606_04.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       1092 2006-06-27 13:11 py_200606_05.htm
-rw-rw----+     1 root          WUM3\it - dataadm       5181 2006-11-07 09:42 py_200611_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1178 2007-01-16 09:09 py_200611_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm      70546 2007-04-16 08:35 py_200704_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1051 2007-05-02 11:56 py_200705_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       5881 2007-05-29 08:41 py_200705_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6039 2008-01-23 11:21 py_200706_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6978 2008-01-23 11:21 py_200708_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6063 2008-01-23 11:22 py_200708_03.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6427 2008-01-23 11:22 py_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6551 2007-09-27 09:39 py_200709_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6068 2007-10-15 11:50 py_200710_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5941 2007-11-05 12:46 py_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6057 2007-11-15 09:41 py_200711_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6268 2007-11-20 14:45 py_200711_03.pdf
-rw-rw----+     1 root          WUM3\it - dataadm      32761 2008-05-27 13:15 py_200805_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm      87901 2008-05-27 13:15 py_eoy_processes.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      37146 2004-10-19 16:05 rb_200409_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1168 2004-11-10 10:19 rb_200411_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       4772 2004-11-24 09:02 rb_200411_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1100 2005-01-10 12:09 rb_200501_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1065 2005-01-17 10:25 rb_200501_02.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1120 2005-02-03 13:19 rb_200502_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1094 2005-05-18 10:44 rb_200505_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      35619 2005-08-29 12:30 rb_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1105 2005-09-05 11:22 rb_200509_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1062 2005-09-08 22:22 rb_200509_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm      19397 2006-10-23 13:06 rb_200608_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       3608 2006-11-07 09:42 rb_200611_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       8955 2007-01-16 09:09 rb_200612_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       9071 2007-06-17 21:52 rb_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5703 2007-07-16 09:12 rb_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6295 2007-08-06 14:09 rb_200708_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6330 2007-08-29 15:07 rb_200708_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       9017 2007-09-27 14:31 rb_200709_01.pdf
-rw-rw----+     1 WUM3\kmshanah WUM3\it - dataadm       5964 2007-10-31 12:07 rb_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6320 2007-11-12 11:35 rb_200711_02.pdf
-??????????     ? ?             ?                          ?                ? rb_200803_01.pdf
?-wsrw--w-  17413         19877        2073063892 2841930001 2017-09-22 03:26 rb_200803_02.pdf
-??????????     ? ?             ?                          ?                ? rb_200804_01.pdf
-??????????     ? ?             ?                          ?                ? rb_200809_01.pdf
-??????????     ? ?             ?                          ?                ? rb_200810_01.pdf
-??????????     ? ?             ?                          ?                ? rb_200811_01.pdf
-??????????     ? ?             ?                          ?                ? rc_200409_01.htm
-??????????     ? ?             ?                          ?                ? rc_200410_01.htm
-??????????     ? ?             ?                          ?                ? rc_200503_01.htm
-??????????     ? ?             ?                          ?                ? rc_200505_01.htm
-??????????     ? ?             ?                          ?                ? rc_200508_01.htm
-??????????     ? ?             ?                          ?                ? rc_200509_01.htm
-??????????     ? ?             ?                          ?                ? rc_200608_01.htm
-??????????     ? ?             ?                          ?                ? rc_200611_01.htm
-??????????     ? ?             ?                          ?                ? rc_200705_01.pdf
-??????????     ? ?             ?                          ?                ? rc_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6564 2008-12-13 20:30 rc_200802_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6701 2008-12-13 20:31 rc_200804_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6010 2008-12-13 20:31 rc_200806_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6534 2008-12-13 20:30 rc_200809_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      18764 2004-10-19 16:05 rd_200409_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      15037 2005-08-29 12:30 rd_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1115 2006-01-11 09:17 rd_200601_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm      24928 2006-10-23 13:06 rd_200608_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1103 2006-11-07 09:42 rd_200611_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       3524 2007-01-16 09:09 rd_200612_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       7937 2007-06-17 21:53 rd_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6290 2007-08-06 14:09 rd_200708_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm      12607 2007-09-13 14:24 rd_200709_01.pdf
-rw-rw----+     1 WUM3\kmshanah WUM3\it - dataadm       7878 2007-10-31 12:07 rd_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6111 2007-11-12 11:36 rd_200711_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6210 2008-12-13 20:31 rd_200805_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm      12087 2008-12-13 20:31 rd_200809_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5863 2008-12-13 20:30 rd_200810_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      56187 2004-10-19 16:05 re_200409_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      10033 2005-08-29 12:30 re_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      11277 2006-01-11 09:15 re_200511_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       2078 2006-03-20 09:10 re_200602_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm      19653 2006-10-23 13:12 re_200608_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       3226 2006-11-07 09:42 re_200611_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm      10610 2007-01-16 09:09 re_200612_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       1144 2007-01-16 09:09 re_200612_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm       6376 2007-06-17 21:46 re_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       7018 2007-09-06 15:38 re_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5962 2007-12-18 18:29 re_200712_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5858 2008-12-13 20:30 re_200807_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6944 2008-12-13 20:30 re_200809_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm      37548 2005-07-26 14:21 ro_200505_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm      18497 2005-09-20 14:30 ro_200508_04.htm
-rw-rw----+     1 root          WUM3\it - dataadm      48225 2007-10-26 12:03 ro_200710_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6054 2007-11-05 12:46 ro_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6180 2007-11-22 08:52 ro_200711_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6647 2007-12-05 09:18 ro_200712_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6550 2008-01-08 14:57 ro_200801_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       2605 2004-03-08 13:40 rt_200402_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       3104 2004-09-30 10:25 rt_200409_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1054 2004-11-04 13:02 rt_200411_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       6816 2005-08-29 12:30 rt_200508_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1090 2005-09-20 06:03 rt_200509_01.htm
-rwxrwx---+     1 root          WUM3\it - dataadm       1045 2005-09-20 06:03 rt_200509_02.htm
-rw-rw----+     1 root          WUM3\it - dataadm       3745 2006-10-23 13:11 rt_200608_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       5943 2007-06-17 21:55 rt_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5708 2007-07-16 09:12 rt_200707_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6475 2007-09-04 16:32 rt_200709_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6746 2008-12-13 20:30 rt_200809_01.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       1074 2004-10-20 08:52 sb_200407_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       2316 2006-04-05 11:59 sb_200601_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       2316 2006-05-30 11:08 sb_200605_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       6773 2007-05-17 11:24 sb_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       7597 2008-12-13 20:30 sb_200809_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5853 2008-12-13 20:30 sb_200810_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6305 2008-12-13 20:30 sb_200810_02.pdf
-rwxrwx---+     1 root          WUM3\it - dataadm       1091 2005-03-21 13:15 ut_200503_01.htm
-rw-rwx---+     1 root          WUM3\it - dataadm       6719 2006-05-30 11:33 ut_200605_01.htm
-rw-rw----+     1 root          WUM3\it - dataadm       8161 2007-06-17 21:56 ut_200705_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6337 2007-09-05 15:39 ut_200709_01.pdf
-rw-rw----+     1 WUM3\kmshanah WUM3\it - dataadm       5990 2007-11-12 10:21 ut_200711_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5758 2008-12-13 20:30 ut_200804_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       7949 2008-12-13 20:30 ut_200809_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5846 2008-12-13 20:30 ut_200810_01.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       5770 2008-12-13 20:30 ut_200810_02.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       8160 2008-12-13 20:30 ut_200810_03.pdf
-rw-rw----+     1 root          WUM3\it - dataadm       6115 2008-10-30 12:14 ut_200811_01.pdf

hermes:~# debugfs /dev/dm-0
debugfs 1.41.3 (12-Oct-2008)
debugfs:  stat local/apps/CIM8/Release-Notes/rb_200809_01.pdf
invalid inode->i_extra_isize (18912)

Inode: 372   Type: bad type    Mode:  0256   Flags: 0xbd47996d
Generation: 3164312278    Version: 0x29572b93:1fe158ca
User: 1935743240   Group: -1018543026   Size: 1749254292
File ACL: 1568876153    Directory ACL: 0
Links: 25068   Blockcount: 77204481787068
Fragment:  Address: -2058966637    Number: 0    Size: 0
 ctime: 0xd0e8c406:4e6402bf -- Fri Jan 24 14:07:42 2081
 atime: 0xfac6d281:441417c1 -- Mon Apr 30 09:23:37 2103
 mtime: 0xddeb3cb7:d93c7906 -- Thu Dec 25 19:30:39 2087
crtime: 0xf93629f2:5b8d2f11 -- Fri Jun 30 11:37:46 2102
dtime: 0x5bdf50e4 -- Mon Nov  5 06:34:52 2018
Size of extra inode fields: 18912
BLOCKS:
(0):1075853705, (1):1084184743, (2):826562568, (3):4211134736, (4):482396871, (5):1630619376, (6):3812152480, (7):2160366375, (8):283227681, (9):2615799508, (10):2222068866, (11):3635491490, (IND):3819526020, (DIND):2847503533, (TIND):3136410785
TOTAL: 15

debugfs:  stat local/apps/CIM8/Release-Notes

Inode: 46   Type: directory    Mode:  0770   Flags: 0x81000
Generation: 279869892    Version: 0x00000000:0000028c
User:     0   Group: 10140   Size: 12288
File ACL: 8523    Directory ACL: 0
Links: 2   Blockcount: 32
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x49a6bb8e:b205108c -- Fri Feb 27 02:25:58 2009
 atime: 0x49a6bb8e:00000000 -- Fri Feb 27 02:25:58 2009
 mtime: 0x494460d2:00000000 -- Sun Dec 14 11:56:42 2008
crtime: 0x49a6bb87:bebdebb8 -- Fri Feb 27 02:25:51 2009
Size of extra inode fields: 28
Extended attributes stored in inode body: 
   = "01 00 00 00 01 00 07 00 02 00 07 00 12 27 00 00 02 00 07 00 14 27 00 00 04 00 05 00 08 00 05 00 1b 27 00 00 08 00 05 00 61 27 00 00 10 00 07 00 20 00 00 00 " (52)
BLOCKS:
(0):8526, (1-2):8627-8628
TOTAL: 3

debugfs:  imap local/apps/CIM8/Release-Notes/rb_200809_01.pdf
Inode 372 is part of block group 0
      located at block 312, offset 0x0300

hermes:~# dd if=/dev/dm-0 of=block-312.dump bs=4k skip=312 count=1
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 0.012112 s, 338 kB/s

--envbJBWh7q8WU6mo
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="block-312.dump"
Content-Transfer-Encoding: base64

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

--envbJBWh7q8WU6mo--
