From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: ext4 bug and/or e2fsck hole
Date: Wed, 8 Apr 2009 06:18:12 +0930
Message-ID: <20090407204811.GA4495@kulgan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:37628 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZDGUsQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 16:48:16 -0400
Received: from kulgan.wumi.org.au (cubit.disenchant.net [150.101.102.147])
	by mail.ucwb.org.au (Postfix) with ESMTP id 066364BF55
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2009 06:18:12 +0930 (CST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a problem where my ext4 filesystem has been corrupted
previously[1], but after being repaired by e2fsck problems still
remain.

Previously, some corruption occured with the directory entries in this
directory which e2fsck "fixed" and was happy that the fs was
consistent, but things didn't quite get back to normal:

hermes:/srv/samba/local/apps/CIM8/Release-Notes# ls -l
total 3120
-rwxrwx---+ 1 root          WUM3\it - dataadm  25729 2005-03-14 10:12 as_200503_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2125 2005-06-16 05:39 as_200506_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  16850 2006-04-10 12:07 as_200604_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   8604 2007-06-17 21:35 as_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5711 2007-07-16 10:11 as_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   8638 2008-05-27 13:15 as_200804_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5890 2008-07-31 09:50 as_200807_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5766 2008-12-13 20:30 as_200810_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   5636 2005-03-14 10:24 br_200503_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2349 2006-03-27 12:07 br_200604_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1116 2006-11-07 09:42 br_200608_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1065 2007-01-16 09:09 br_200612_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   8191 2007-05-17 11:20 br_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6518 2008-05-27 13:15 br_200804_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5911 2008-05-27 13:15 br_200805_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5779 2008-12-13 20:30 br_200809_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5844 2008-12-13 20:30 br_200810_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  10537 2005-04-07 16:20 cq_200504_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1033 2006-03-20 09:08 cq_200602_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   5802 2007-05-17 11:21 cq_200705_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   1255 2005-02-10 11:48 cr_200502_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  31876 2005-03-31 14:48 cr_200504_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1098 2005-07-26 14:36 cr_200507_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1028 2006-03-21 15:29 cr_200509_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   6994 2007-06-17 21:37 cr_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5706 2007-07-16 09:12 cr_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6489 2007-09-03 09:29 cr_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6107 2007-09-17 19:18 cr_200709_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6299 2008-12-13 20:30 cr_200802_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm  14529 2008-12-13 20:30 cr_200806_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5985 2008-12-13 20:30 cr_200810_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm 101693 2004-11-02 13:46 cs_200411_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  16893 2004-12-10 09:57 cs_200412_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1089 2005-01-28 14:49 cs_200501_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   4208 2005-01-28 14:49 cs_200501_03.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  12921 2005-04-08 10:56 cs_200504_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2778 2005-09-05 09:21 cs_200504_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1061 2005-09-05 09:21 cs_200506_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   5501 2005-09-05 09:21 cs_200506_03.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  57601 2005-08-26 13:19 cs_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2156 2005-09-08 22:06 cs_200509_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2150 2005-09-20 06:03 cs_200509_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   5476 2005-09-21 12:48 cs_200509_03.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   4368 2006-01-11 09:15 cs_200601_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   3220 2006-05-23 14:52 cs_200605_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  25370 2006-08-18 14:39 cs_200608_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  14517 2006-10-24 10:53 cs_200609_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1110 2006-11-07 09:42 cs_200610_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   5907 2007-01-16 09:09 cs_200612_01.htm
-rw-rw----+ 1 WUM3\kmshanah WUM3\it - dataadm  56829 2007-10-31 11:56 cs_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6422 2007-11-13 09:59 cs_200711_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6634 2007-11-23 14:50 cs_200711_03.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   9023 2007-12-12 15:06 cs_200712_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6689 2007-12-18 17:04 cs_200712_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6200 2008-01-04 12:12 cs_200801_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   2978 2006-04-07 17:02 dr_200202_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1155 2006-04-07 17:02 dr_200202_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  15965 2006-04-07 17:02 dr_200301_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   8506 2006-04-07 17:02 dr_200403_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  14571 2006-04-07 17:03 dr_200503_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2094 2006-04-07 17:03 dr_200507_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   5426 2006-04-07 17:03 dr_200512_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   6202 2007-06-17 21:39 dr_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5701 2007-07-16 09:13 dr_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5961 2008-01-23 11:20 dr_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6392 2008-01-23 11:20 dr_200711_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   1085 2005-02-28 14:27 gl_200503_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  34405 2005-03-29 12:22 gl_200503_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2101 2005-07-27 21:52 gl_200507_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  18316 2006-04-10 12:41 gl_200604_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   1469 2006-04-27 11:34 gl_200604_03.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  11493 2007-06-17 21:39 gl_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5711 2007-07-16 09:12 gl_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5860 2007-08-16 14:43 gl_200708_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6033 2007-09-04 09:41 gl_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6294 2008-05-27 13:15 gl_200803_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   8623 2008-05-27 13:15 gl_200804_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6055 2008-05-27 13:15 gl_200805_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5793 2008-12-13 20:30 gl_200808_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6060 2008-12-13 20:30 gl_200810_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   1078 2004-10-19 16:05 pd_200407_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   3531 2005-04-08 10:56 pd_200504_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   4701 2005-08-26 13:20 pd_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1089 2006-01-11 09:31 pd_200601_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   7126 2007-09-19 14:05 pd_200709_02.pdf
-rw-rw----+ 1 WUM3\kmshanah WUM3\it - dataadm   6632 2007-10-31 11:56 pd_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5902 2007-11-28 09:04 pd_200711_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5979 2008-12-13 20:30 pd_200802_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6076 2008-12-13 20:30 pd_200805_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5847 2008-12-13 20:30 pd_200807_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5727 2008-12-13 20:30 pd_200809_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  65735 2005-05-23 14:19 py_200506_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2165 2005-06-16 05:40 py_200506_02.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm  81171 2006-06-26 08:28 py_200605_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   7286 2006-06-26 08:28 py_200606_02.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm    999 2006-06-26 08:28 py_200606_03.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   2026 2006-06-26 08:28 py_200606_04.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   1092 2006-06-27 13:11 py_200606_05.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   5181 2006-11-07 09:42 py_200611_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1178 2007-01-16 09:09 py_200611_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  70546 2007-04-16 08:35 py_200704_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1051 2007-05-02 11:56 py_200705_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   5881 2007-05-29 08:41 py_200705_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6039 2008-01-23 11:21 py_200706_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6978 2008-01-23 11:21 py_200708_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6063 2008-01-23 11:22 py_200708_03.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6427 2008-01-23 11:22 py_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6551 2007-09-27 09:39 py_200709_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6068 2007-10-15 11:50 py_200710_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5941 2007-11-05 12:46 py_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6057 2007-11-15 09:41 py_200711_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6268 2007-11-20 14:45 py_200711_03.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm  32761 2008-05-27 13:15 py_200805_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm  87901 2008-05-27 13:15 py_eoy_processes.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  37146 2004-10-19 16:05 rb_200409_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1168 2004-11-10 10:19 rb_200411_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   4772 2004-11-24 09:02 rb_200411_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1100 2005-01-10 12:09 rb_200501_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1065 2005-01-17 10:25 rb_200501_02.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1120 2005-02-03 13:19 rb_200502_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1094 2005-05-18 10:44 rb_200505_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  35619 2005-08-29 12:30 rb_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1105 2005-09-05 11:22 rb_200509_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1062 2005-09-08 22:22 rb_200509_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  19397 2006-10-23 13:06 rb_200608_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   3608 2006-11-07 09:42 rb_200611_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   8955 2007-01-16 09:09 rb_200612_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   9071 2007-06-17 21:52 rb_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5703 2007-07-16 09:12 rb_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6295 2007-08-06 14:09 rb_200708_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6330 2007-08-29 15:07 rb_200708_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   9017 2007-09-27 14:31 rb_200709_01.pdf
-rw-rw----+ 1 WUM3\kmshanah WUM3\it - dataadm   5964 2007-10-31 12:07 rb_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6320 2007-11-12 11:35 rb_200711_02.pdf
sr-S-----x  1     167085146        3064914020      0 1988-03-09 06:02 rc_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6564 2008-12-13 20:30 rc_200802_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6701 2008-12-13 20:31 rc_200804_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6010 2008-12-13 20:31 rc_200806_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6534 2008-12-13 20:30 rc_200809_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  18764 2004-10-19 16:05 rd_200409_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  15037 2005-08-29 12:30 rd_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1115 2006-01-11 09:17 rd_200601_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  24928 2006-10-23 13:06 rd_200608_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1103 2006-11-07 09:42 rd_200611_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   3524 2007-01-16 09:09 rd_200612_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   7937 2007-06-17 21:53 rd_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6290 2007-08-06 14:09 rd_200708_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm  12607 2007-09-13 14:24 rd_200709_01.pdf
-rw-rw----+ 1 WUM3\kmshanah WUM3\it - dataadm   7878 2007-10-31 12:07 rd_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6111 2007-11-12 11:36 rd_200711_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6210 2008-12-13 20:31 rd_200805_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm  12087 2008-12-13 20:31 rd_200809_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5863 2008-12-13 20:30 rd_200810_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  56187 2004-10-19 16:05 re_200409_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  10033 2005-08-29 12:30 re_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  11277 2006-01-11 09:15 re_200511_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   2078 2006-03-20 09:10 re_200602_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  19653 2006-10-23 13:12 re_200608_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   3226 2006-11-07 09:42 re_200611_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  10610 2007-01-16 09:09 re_200612_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   1144 2007-01-16 09:09 re_200612_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   6376 2007-06-17 21:46 re_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   7018 2007-09-06 15:38 re_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5962 2007-12-18 18:29 re_200712_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5858 2008-12-13 20:30 re_200807_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6944 2008-12-13 20:30 re_200809_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm  37548 2005-07-26 14:21 ro_200505_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm  18497 2005-09-20 14:30 ro_200508_04.htm
-rw-rw----+ 1 root          WUM3\it - dataadm  48225 2007-10-26 12:03 ro_200710_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6054 2007-11-05 12:46 ro_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6180 2007-11-22 08:52 ro_200711_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6647 2007-12-05 09:18 ro_200712_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6550 2008-01-08 14:57 ro_200801_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   2605 2004-03-08 13:40 rt_200402_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   3104 2004-09-30 10:25 rt_200409_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1054 2004-11-04 13:02 rt_200411_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   6816 2005-08-29 12:30 rt_200508_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1090 2005-09-20 06:03 rt_200509_01.htm
-rwxrwx---+ 1 root          WUM3\it - dataadm   1045 2005-09-20 06:03 rt_200509_02.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   3745 2006-10-23 13:11 rt_200608_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   5943 2007-06-17 21:55 rt_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5708 2007-07-16 09:12 rt_200707_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6475 2007-09-04 16:32 rt_200709_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6746 2008-12-13 20:30 rt_200809_01.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   1074 2004-10-20 08:52 sb_200407_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   2316 2006-04-05 11:59 sb_200601_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   2316 2006-05-30 11:08 sb_200605_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   6773 2007-05-17 11:24 sb_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   7597 2008-12-13 20:30 sb_200809_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5853 2008-12-13 20:30 sb_200810_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6305 2008-12-13 20:30 sb_200810_02.pdf
-rwxrwx---+ 1 root          WUM3\it - dataadm   1091 2005-03-21 13:15 ut_200503_01.htm
-rw-rwx---+ 1 root          WUM3\it - dataadm   6719 2006-05-30 11:33 ut_200605_01.htm
-rw-rw----+ 1 root          WUM3\it - dataadm   8161 2007-06-17 21:56 ut_200705_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6337 2007-09-05 15:39 ut_200709_01.pdf
-rw-rw----+ 1 WUM3\kmshanah WUM3\it - dataadm   5990 2007-11-12 10:21 ut_200711_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5758 2008-12-13 20:30 ut_200804_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   7949 2008-12-13 20:30 ut_200809_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5846 2008-12-13 20:30 ut_200810_01.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   5770 2008-12-13 20:30 ut_200810_02.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   8160 2008-12-13 20:30 ut_200810_03.pdf
-rw-rw----+ 1 root          WUM3\it - dataadm   6115 2008-10-30 12:14 ut_200811_01.pdf

Everything looks okay there except the one file with weird
permissions, group and owner numbers. Look what happens when I try to
delete the files from this directory:

hermes:/srv/samba/local/apps/CIM8/Release-Notes# rm *
rm: cannot remove `rc_200802_01.pdf': Read-only file system
rm: cannot remove `rc_200804_01.pdf': Read-only file system
rm: cannot remove `rc_200806_01.pdf': Read-only file system
rm: cannot remove `rc_200809_01.pdf': Read-only file system
rm: cannot remove `rd_200409_01.htm': Read-only file system
rm: cannot remove `rd_200508_01.htm': Read-only file system
rm: cannot remove `rd_200601_01.htm': Read-only file system
rm: cannot remove `rd_200608_01.htm': Read-only file system
rm: cannot remove `rd_200611_01.htm': Read-only file system
rm: cannot remove `rd_200612_01.htm': Read-only file system
rm: cannot remove `rd_200705_01.pdf': Read-only file system
rm: cannot remove `rd_200708_01.pdf': Read-only file system
rm: cannot remove `rd_200709_01.pdf': Read-only file system
rm: cannot remove `rd_200711_01.pdf': Read-only file system
rm: cannot remove `rd_200711_02.pdf': Read-only file system
rm: cannot remove `rd_200805_01.pdf': Read-only file system
rm: cannot remove `rd_200809_01.pdf': Read-only file system
rm: cannot remove `rd_200810_01.pdf': Read-only file system
rm: cannot remove `re_200409_01.htm': Read-only file system
rm: cannot remove `re_200508_01.htm': Read-only file system
rm: cannot remove `re_200511_01.htm': Read-only file system
rm: cannot remove `re_200602_01.htm': Read-only file system
rm: cannot remove `re_200608_01.htm': Read-only file system
rm: cannot remove `re_200611_01.htm': Read-only file system
rm: cannot remove `re_200612_01.htm': Read-only file system
rm: cannot remove `re_200612_02.htm': Read-only file system
rm: cannot remove `re_200705_01.pdf': Read-only file system
rm: cannot remove `re_200709_01.pdf': Read-only file system
rm: cannot remove `re_200712_01.pdf': Read-only file system
rm: cannot remove `re_200807_01.pdf': Read-only file system
rm: cannot remove `re_200809_01.pdf': Read-only file system
rm: cannot remove `ro_200505_01.htm': Read-only file system
rm: cannot remove `ro_200508_04.htm': Read-only file system
rm: cannot remove `ro_200710_02.pdf': Read-only file system
rm: cannot remove `ro_200711_01.pdf': Read-only file system
rm: cannot remove `ro_200711_02.pdf': Read-only file system
rm: cannot remove `ro_200712_01.pdf': Read-only file system
rm: cannot remove `ro_200801_01.pdf': Read-only file system
rm: cannot remove `rt_200402_01.htm': Read-only file system
rm: cannot remove `rt_200409_01.htm': Read-only file system
rm: cannot remove `rt_200411_01.htm': Read-only file system
rm: cannot remove `rt_200508_01.htm': Read-only file system
rm: cannot remove `rt_200509_01.htm': Read-only file system
rm: cannot remove `rt_200509_02.htm': Read-only file system
rm: cannot remove `rt_200608_01.htm': Read-only file system
rm: cannot remove `rt_200705_01.pdf': Read-only file system
rm: cannot remove `rt_200707_01.pdf': Read-only file system
rm: cannot remove `rt_200709_01.pdf': Read-only file system
rm: cannot remove `rt_200809_01.pdf': Read-only file system
rm: cannot remove `sb_200407_01.htm': Read-only file system
rm: cannot remove `sb_200601_01.htm': Read-only file system
rm: cannot remove `sb_200605_01.htm': Read-only file system
rm: cannot remove `sb_200705_01.pdf': Read-only file system
rm: cannot remove `sb_200809_01.pdf': Read-only file system
rm: cannot remove `sb_200810_01.pdf': Read-only file system
rm: cannot remove `sb_200810_02.pdf': Read-only file system
rm: cannot remove `ut_200503_01.htm': Read-only file system
rm: cannot remove `ut_200605_01.htm': Read-only file system
rm: cannot remove `ut_200705_01.pdf': Read-only file system
rm: cannot remove `ut_200709_01.pdf': Read-only file system
rm: cannot remove `ut_200711_01.pdf': Read-only file system
rm: cannot remove `ut_200804_01.pdf': Read-only file system
rm: cannot remove `ut_200809_01.pdf': Read-only file system
rm: cannot remove `ut_200810_01.pdf': Read-only file system
rm: cannot remove `ut_200810_02.pdf': Read-only file system
rm: cannot remove `ut_200810_03.pdf': Read-only file system
rm: cannot remove `ut_200811_01.pdf': Read-only file system

The filesystem was read-write beforehand. Here's what showed up in syslog:

Apr  8 05:48:58 hermes kernel: attempt to access beyond end of device
Apr  8 05:48:58 hermes kernel: dm-0: rw=0, want=824255763709960, limit=2147483648
Apr  8 05:48:58 hermes kernel: EXT4-fs error (device dm-0): ext4_xattr_delete_inode: inode 383: block 103031970463744 read error
Apr  8 05:48:58 hermes kernel: Aborting journal on device dm-0:8.
Apr  8 05:48:58 hermes kernel: Remounting filesystem read-only
Apr  8 05:48:58 hermes kernel: EXT4-fs error (device dm-0) in ext4_free_inode: Journal has aborted

So now I unmount and run fsck again:

hermes:~# e2fsck -p -f -v /dev/dm-0
/dev/dm-0: recovering journal

  333016 inodes used (0.50%)
   15412 non-contiguous inodes (4.6%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 332627/321
46626122 blocks used (17.37%)
       0 bad blocks
       2 large files

  306273 regular files
   26672 directories
       0 character device files
       0 block device files
       1 fifo
       0 links
      60 symbolic links (56 fast symbolic links)
       1 socket
--------
  333007 files

Please let me know how I can fix this.

Thanks and Regards,
Kevin.

[1] http://marc.info/?l=linux-ext4&m=123879692007843&w=2
