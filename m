From: Celine Bourde <celine.bourde@bull.net>
Subject: Ext4 test results
Date: Mon, 18 Aug 2008 13:57:29 +0200
Message-ID: <48A963A9.107@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	jean-pierre.dion@bull.net, frederic.bohe@bull.net,
	SOLOFO RAMANGALAHY <Solofo.Ramangalahy@bull.net>,
	"Jose R. Santos" <jrs@us.ibm.com>, celine.bourde@bull.net
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54906 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYHRMBY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 08:01:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I have launch valerie's performance test to compare ext4 evolution from
kernel 2.6.26-rc2 to kernel 2.6.27-rc1.

Both results are available here :
http://www.bullopensource.org/ext4/20080530/ffsb-write-2.6.26-rc2.htm <http://www.bullopensource.org/ext4/20080818-ffsb/ffsb-write-2.6.27-rc1.html>
http://www.bullopensource.org/ext4/20080818-ffsb/ffsb-write-2.6.27-rc1.html

barriers were disabled for this tests.
We could notice significant improvement of number of
extents per file with following cases :

mkfs option : -I 256 -O uninit_groups
mount option : data=writeback, nomballoc

and

mkfs option : -I 256 -O uninit_groups,flex_bg -G 64
mount option : data=writeback, nomballoc

fsck time appears now constant (kernel 2.6.27-rc1).

Cel.







