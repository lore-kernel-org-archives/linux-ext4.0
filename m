From: =?ISO-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
Subject: uninit_bg compatibility?
Date: Tue, 21 Sep 2010 15:28:51 +0200 (CEST)
Message-ID: <Pine.A41.4.64.1009211500110.1245260@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.acc.umu.se ([130.239.18.156]:51427 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab0IUNjb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Sep 2010 09:39:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by amavisd-new (Postfix) with ESMTP id A183930E
	for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 15:28:52 +0200 (MEST)
Received: from stalin.acc.umu.se (stalin.acc.umu.se [130.239.18.135])
	by mail.acc.umu.se (Postfix) with ESMTP id 823B730D
	for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 15:28:51 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by stalin.acc.umu.se (Postfix) with ESMTP id 5175C2C
	for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 15:28:51 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hello,

when writing new files to an ext4 file system using the Windows driver 
fsck will later complain "Group descriptor nn checksum is invalid" and I 
think that is because it used an yet unused block group without knowing 
that they can be marked as uninitialized. So I thought a simple patch 
would be to mount the file system read-only if that feature is in use 
untill the driver is updated with full write support but I can't find the 
flag to use, there is no EXT4_FEATURE_RO_COMPAT_UNINIT_BG so I thought I 
ask here if anyone could clear this out.
