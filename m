From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Which newer kernel is OK with ext4?
Date: Wed, 3 Jun 2015 21:50:39 +0200
Message-ID: <mknlqf$m5d$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60803 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbbFCTuu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jun 2015 15:50:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1Z0EgX-0006jV-9z
	for linux-ext4@vger.kernel.org; Wed, 03 Jun 2015 21:50:45 +0200
Received: from ip4d178d5f.dynamic.kabel-deutschland.de ([77.23.141.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 03 Jun 2015 21:50:45 +0200
Received: from for-gmane by ip4d178d5f.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 03 Jun 2015 21:50:45 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
I need to switch to a newer kernel than 3.16.0-4.
But since the new ext4 is not finished yet, I'm concerned
about the safety of the data on my ext4-hd.
I don't know how the ext4-inclusion-policy-into-the-kernel is,
maybe one of you can enlighten me. I mean, the old (ie. the current)
ext4 seems to be ok, and I would not want to risk the data to a new,
but unfinished, ext4-module in a newer kernel.
Is there maybe a kernel-switch to use the old ext4 module?
Can I safely install the "stable 4.0.4" kernel from www.kernel.org?

-- 
Thx
Uenal

