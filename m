From: Allison Henderson <achender@vnet.ibm.com>
Subject: PATCH 0/2 v2] EXT4: Punch Hole Optimizations
Date: Mon, 06 Jun 2011 16:43:37 -0700
Message-ID: <4DED6629.3010403@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36721 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1FFXnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 19:43:41 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p56NW3dW027270
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:32:03 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p56NhcXw206256
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:43:38 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p56NmrVA031024
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:48:53 -0600
Received: from lc4eb0185863151.ibm.com (sig-9-65-175-246.mts.ibm.com [9.65.175.246])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p56NmqLX030994
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:48:52 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,





We realized late that we could optimize the punch hole code by skipping

ext4_ext_remove_space, and directly calling ext4_ext_rm_leaf.  Since

punch hole is done through map blocks, the path to the extent is already

known, so we do not need to look it up again. The extra parameter that

was added in ext4_ext_remove_space is removed since we no longer need it.

Allison Henderson
