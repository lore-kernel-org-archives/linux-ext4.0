From: Clemens Gruber <clemens.gruber@pqgruber.com>
Subject: Fast ext4 cleanup to avoid data loss after power failure
Date: Fri, 03 Oct 2014 15:09:31 +0200
Message-ID: <542EA00B.4040401@pqgruber.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.pqgruber.com ([178.189.19.235]:55044 "EHLO
	mail.pqgruber.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaJCNRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2014 09:17:16 -0400
Received: from [10.20.30.14] (chello213047245140.tirol.surfer.at [213.47.245.140])
	by mail.pqgruber.com (Postfix) with ESMTPSA id F31768946E
	for <linux-ext4@vger.kernel.org>; Fri,  3 Oct 2014 15:11:21 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am using ext4 as root filesystem of my TQMa28-based board with 2GB eMMC.
In case of a power failure I have to clean up the filesystem in 1.5 to 2
seconds, that's how long the caps can sustain the power.

I pass the following rootflags on the kernel cmdline: data=journal,commit=1
In my user space application I open important files with O_SYNC.

Is there something else I can or should do to avoid data corruption?

I can detect when the power fails over a GPIO line, so I close open file
descriptors in one important application but doing a "normal"
poweroff/shutdown takes too long.

What would you do if you had 1.5 seconds until the power is gone?

Maybe a read-only rootfs and a separate small data partition?

Thanks for your help.

Best regards,
Clemens
