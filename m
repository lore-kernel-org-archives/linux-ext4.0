From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 24 Apr 2007 18:21:00 +0400
Message-ID: <462E124C.30706@clusterfs.com>
References: <462D42CA.50509@linux.vnet.ibm.com> <462D9CE9.1040402@clusterfs.com> <462E0E5A.6030707@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:56257 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161772AbXDXOVV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2007 10:21:21 -0400
In-Reply-To: <462E0E5A.6030707@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Valerie Clement wrote:
> Here are the results I obtain with a 2.6.17-rc7 kernel to delete a 100GB 
> file:
> 
> ext3 : real  2m35.048s    user  0m0.000s     sys  0m6.424s
> ext4 : real  0m11.160s    user  0m0.000s     sys  0m5.532s
> xfs :  real  0m0.377s     user  0m0.004s     sys  0m0.004s

would be very interesting to know how much IO was done to remove the file
and actual fragmentation in all the cases.

thanks, Alex
