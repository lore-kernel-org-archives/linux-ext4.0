From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext2 and ext4 preallocation / mballoc
Date: Sat, 06 Mar 2010 20:15:20 +0530
Message-ID: <87ocj1se4f.fsf@linux.vnet.ibm.com>
References: <dda2e1011002170746x6cad8cekee6dcb7079002e10@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: =?iso-8859-1?q?Ga=EBtan?= Podevijn <gpodevij@gmail.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46755 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab0CFOp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Mar 2010 09:45:27 -0500
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id o26EjPQQ001725
	for <linux-ext4@vger.kernel.org>; Sun, 7 Mar 2010 01:45:25 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o26EdhS41413330
	for <linux-ext4@vger.kernel.org>; Sun, 7 Mar 2010 01:39:43 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o26EjPRt002743
	for <linux-ext4@vger.kernel.org>; Sun, 7 Mar 2010 01:45:25 +1100
In-Reply-To: <dda2e1011002170746x6cad8cekee6dcb7079002e10@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 17 Feb 2010 16:46:19 +0100, Ga=C3=ABtan Podevijn <gpodevij@gmai=
l.com> wrote:
> Hello,
>=20
> Reading this http://web.mit.edu/tytso/www/linux/ext2intro.html I
> understand that ext2 preallocates 8 blocks when a writing data to a
> file. Ext3 uses the windows reservations method, but is that ext3 als=
o
> preallocates 8 blocks when writing data ?
>=20
> Moreover, this page
> http://kernelnewbies.org/Ext4#head-b2148d2a96d22a1bd7e376e6c08e4a38d0=
8fb157
> explains that ext3 allocates one block at a time and ext4 uses
> multiblock allocation that is, allocates many block in a single syste=
m
> call.
>=20
> What is the difference between preallocation on ext2 (and ext3 ?) and=
 mballoc ?
>=20
>=20


You can find mballoc details at=20

http://ols.fedoraproject.org/OLS/Reprints-2008/kumar-reprint.pdf

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
