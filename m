From: Kailas Joshi <kailas.joshi@gmail.com>
Subject: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Thu, 4 Feb 2010 05:45:21 +0000 (UTC)
Message-ID: <loom.20100204T064311-880@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57151 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab0BDFuH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Feb 2010 00:50:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1NcubN-00074l-D7
	for linux-ext4@vger.kernel.org; Thu, 04 Feb 2010 06:50:05 +0100
Received: from 59.162.23.19.static-mumbai.vsnl.net.in ([59.162.23.19.static-mumbai.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Feb 2010 06:50:05 +0100
Received: from kailas.joshi by 59.162.23.19.static-mumbai.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 04 Feb 2010 06:50:05 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I recently found that in EXT4 with delayed block the Ordered mode does not
bahave same as in EXT3.
I found a patch for this at http://lwn.net/Articles/324023/, but it has some
journal block estimation problem resulting into deadlock.

I would like to know if it has been solved.
If not, is it possible to solve it? What are the complexities involved?

Please help.
Thanks in advanced.

Regards,
Kailas

