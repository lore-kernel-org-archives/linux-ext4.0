From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Documenting the ext3 -> ext4 transition
Date: Thu, 3 Sep 2015 12:16:44 -0700
Message-ID: <20150903191644.GC10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbbICTQr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2015 15:16:47 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t83JGkn1031550
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2015 19:16:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t83JGkvA002424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2015 19:16:46 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t83JGk4V011835
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2015 19:16:46 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Now that ext3.ko is going away, Ted and I talked about having a wiki page to
talk about the transition (to using ext4.ko for ext3 FS) and potential upgrade
paths.  There already was a section in the HOWTO, but I promoted it to its
own page and a link from the front page:

Please take a look and suggest/make changes:

https://ext4.wiki.kernel.org/index.php/UpgradeToExt4

--D
