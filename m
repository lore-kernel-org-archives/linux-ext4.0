From: Werner Fischer <devlists@wefi.net>
Subject: -E stride and stripe-width necessary for best performace of SSDs?
Date: Fri, 01 Jul 2011 11:30:54 +0200
Message-ID: <1309512654.5729.15.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:42324 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab1GAJhQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jul 2011 05:37:16 -0400
Received: from [10.0.0.2] (88-117-100-105.adsl.highway.telekom.at [88.117.100.105])
	by srv.wefi.net (Postfix) with ESMTPSA id DB971495614
	for <linux-ext4@vger.kernel.org>; Fri,  1 Jul 2011 11:30:49 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

* I want to optimize ext4 on my SSD (Intel 320 Series 160 GB).
* There are some sites recommending the use of the -E stride and -E 
  stripe-width paramaters, like
  http://searchenterpriselinux.techtarget.com/tip/Optimizing-Linux-for-SSD-usage
* I know these parameters are useful for RAIDs, but I don't think that 
  they have any advantages for SSDs.

Can anybody with deeper ext4 knowledge confirm if I'm right?

Best regards,
Werner

