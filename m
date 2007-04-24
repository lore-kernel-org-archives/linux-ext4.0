From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 24 Apr 2007 16:04:10 +0200
Message-ID: <462E0E5A.6030707@bull.net>
References: <462D42CA.50509@linux.vnet.ibm.com> <462D9CE9.1040402@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:58803 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161771AbXDXOFD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Apr 2007 10:05:03 -0400
In-Reply-To: <462D9CE9.1040402@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:

>> - Large file deletion
>>    - Valerie had recently tested large file deletion on ext3/4, but=20
>> did not see the expected performance gain with ext4 due to compact=20
>> metadata when using extents.
>=20
> any details?
>=20

Ok, I found my mistake. There was a typo in my test script and the=20
pagecache was not flushed between the file creation and the deletion.

Here are the results I obtain with a 2.6.17-rc7 kernel to delete a 100G=
B=20
file:

ext3 : real  2m35.048s    user  0m0.000s     sys  0m6.424s
ext4 : real  0m11.160s    user  0m0.000s     sys  0m5.532s
xfs :  real  0m0.377s     user  0m0.004s     sys  0m0.004s

The performance gain with ext4 is much larger when running a good test.=
=2E.
Sorry the wrong information,

    Val=E9rie
