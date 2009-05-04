From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Build error with latest e2fsprogs
Date: Mon, 4 May 2009 16:28:17 +0530
Message-ID: <20090504105817.GA21923@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37772 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZEDK62 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 06:58:28 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n44AuJbD011559
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 20:56:19 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n44AwRQ3303524
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 20:58:28 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n44AwRAX031461
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 20:58:27 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

=46inding the below build error with latest e2fsprogs. I guess you miss=
ed
a git add.


filefrag.c:43:27: error: ext2fs/fiemap.h: No such file or directory
filefrag.c:116: warning: =E2=80=98struct fiemap_extent=E2=80=99 declare=
d inside parameter list
filefrag.c:116: warning: its scope is only this definition or declarati=
on, which is probably not what you want
filefrag.c: In function =E2=80=98print_extent_info=E2=80=99:
filefrag.c:124: error: dereferencing pointer to incomplete type
filefrag.c:124: error: =E2=80=98FIEMAP_EXTENT_DATA_INLINE=E2=80=99 unde=
clared (first use in this function)
filefrag.c:124: error: (Each undeclared identifier is reported only onc=
e
filefrag.c:124: error: for each function it appears in.)
filefrag.c:127: error: dereferencing pointer to incomplete type
filefrag.c:128: error: dereferencing pointer to incomplete type
filefrag.c:129: error: dereferencing pointer to incomplete type
filefrag.c:131: error: dereferencing pointer to incomplete type

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
