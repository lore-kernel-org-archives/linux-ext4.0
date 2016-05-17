From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: ext4: call out CRC and corruption errors with specific error
 codes
Date: Tue, 17 May 2016 16:25:29 +0300
Message-ID: <20160517132529.GF11011@mwanda>
References: <20160517131524.GA14581@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcEQNZu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2016 09:25:50 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4HDPlAX007357
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:25:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u4HDPlHv020537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:25:47 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u4HDPfAV005804
	for <linux-ext4@vger.kernel.org>; Tue, 17 May 2016 13:25:47 GMT
Content-Disposition: inline
In-Reply-To: <20160517131524.GA14581@mwanda>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is another one a few lines later as well.

fs/ext4/xattr.c:894 ext4_xattr_block_set() warn: error is never (-117)

regards,
dan carpenter

