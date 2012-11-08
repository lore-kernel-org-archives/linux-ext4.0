From: Mark Casey <markc@unifiedgroup.com>
Subject: Question on resize2fs with "combination of flex_bg and !resize_inode"
Date: Thu, 08 Nov 2012 14:03:38 -0600
Message-ID: <k7h36p$qgp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44724 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769Ab2KHUDv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 15:03:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1TWYKS-0004q4-Kn
	for linux-ext4@vger.kernel.org; Thu, 08 Nov 2012 21:03:56 +0100
Received: from mail.unifiedgroup.com ([66.180.117.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 08 Nov 2012 21:03:56 +0100
Received: from markc by mail.unifiedgroup.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Thu, 08 Nov 2012 21:03:56 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

Regarding this patch to resize2fs: 
http://permalink.gmane.org/gmane.comp.file-systems.ext4/7379

In reading the comment, I was wondering if this problem scenario can 
also happen when shrinking an ext4 filesystem with this combination of 
features, or if it is only likely to be a problem when growing it?

Thank you,
Mark


