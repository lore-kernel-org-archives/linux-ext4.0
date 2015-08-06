From: ryding <ryan.ding@oracle.com>
Subject: question about append direct io
Date: Thu, 06 Aug 2015 17:26:44 +0800
Message-ID: <55C32854.1050501@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbbHFJ1r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2015 05:27:47 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t769Rkql009226
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2015 09:27:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t769RkWL030753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2015 09:27:46 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t769Rksh010689
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2015 09:27:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Sorry for bothering.

I see ext4 add inode to orphan when doing append direct io. Is this used 
to roll back the old isize when a crash is happened during the direct 
io? Is there other purpose to do so?

Thanks,
Ryan
