From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 24 Apr 2007 16:51:46 +0200
Message-ID: <462E1982.9020307@bull.net>
References: <462D42CA.50509@linux.vnet.ibm.com> <462D9CE9.1040402@clusterfs.com> <462E0E5A.6030707@bull.net> <462E124C.30706@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45000 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbXDXOwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Apr 2007 10:52:38 -0400
In-Reply-To: <462E124C.30706@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> Valerie Clement wrote:
>> Here are the results I obtain with a 2.6.17-rc7 kernel to delete a=20
>> 100GB file:
>>
>> ext3 : real  2m35.048s    user  0m0.000s     sys  0m6.424s
>> ext4 : real  0m11.160s    user  0m0.000s     sys  0m5.532s
>> xfs :  real  0m0.377s     user  0m0.004s     sys  0m0.004s
>=20
> would be very interesting to know how much IO was done to remove the =
file
> and actual fragmentation in all the cases.
>=20
> thanks, Alex
>=20
Ok, I will do it.

   Val=E9rie
