From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: BUG with delayed allocation
Date: Wed, 19 Mar 2008 14:22:35 +0530
Message-ID: <20080319085235.GA6752@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:34833 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYCSTcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2008 15:32:22 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2J8qZS9003625
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 14:22:35 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2J8qYu11237230
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 14:22:35 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2J8qYnc013265
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2008 08:52:34 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


