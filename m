From: Avantika Mathur LTC <mathur@us.ibm.com>
Subject: Ext4 devel interlock meeting minutes (Oct. 18, 2006)
Date: Wed, 18 Oct 2006 12:00:33 -0700
Message-ID: <453679D1.8050108@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:15031 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1161046AbWJRTAk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 15:00:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9IJ0dQ9025248
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 15:00:39 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9IJ0bEA251018
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 15:00:37 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9IJ0atd009943
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 15:00:36 -0400
Received: from [127.0.0.1] (Jackalope.beaverton.ibm.com [9.47.16.74] (may be forged))
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k9IJ0Y4h009825
	for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2006 15:00:36 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 Developer Interlock Call: 10/18/06 Minutes

Attendees: Shaggy, Jean-Pierre Dion, Val=E9rie Cl=E9ment, Suparna=20
Bhattacharya, Andreas Dilger, Avantika Mathur

- Testing: Jean-Noel has been testing Ext4 in mainline on an x86_64=20
machine using a 10 TB sparse disk.  So far, the tests have been going=20
well and a detailed report will be posted to the mailing list.  Avantik=
a=20
will also begin more testing of Ext4.

- Val=E9rie has made changes to e2fsprogs for the big block group patch=
,=20
and will begin testing tomorrow.  Once done testing, she will post to=20
the mailing list.

- Need to address question of when we will stop Ext4 development, by=20
defining which features will be added and when.  Plan to go through the=
=20
list of features to consider, and decide target dates for each feature.=
=20
Probably want to complete any on disk changes quickly.  This will all b=
e=20
discussed on the mailing list.
