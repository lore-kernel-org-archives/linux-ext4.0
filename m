From: linux_ext4@proinbox.com
Subject: convert from ext3 versus fresh format
Date: Sun, 28 Nov 2010 16:16:03 -0500
Message-ID: <1290978963.16103.1407558601@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45370 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab0K1VQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Nov 2010 16:16:04 -0500
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 028A0703
	for <linux-ext4@vger.kernel.org>; Sun, 28 Nov 2010 16:16:03 -0500 (EST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi list,

I have a production system installed on an SSD, whose installer formats
the target drive as ext3 automatically. I've since learned that ext4 is
more suited for use on SSDs and am considering an upgrade to ext4.

I see the procedure on how to convert from ext3 to ext4 on the wiki, and
before I proceed would like to know whether there's an advantage to
formatting as ext4 from the start as opposed to converting after an ext3
format.

In the case that there is a difference, what exactly is sacrificed in
choosing one over the other?

Regards,

-C

