From: Mark Lord <kernel@teksavvy.com>
Subject: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Date: Sat, 19 Feb 2011 17:37:20 -0500
Message-ID: <4D604620.9060204@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36592 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752780Ab1BSWhW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 17:37:22 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

32-bit x86 system, 2.6.37 SMP kernel, Core2duo, 3.3GB RAM, no swap.

The system just suddenly switched to fbconsole and dumped a traceback.
Here's the screen-shot photo:  http://rtr.ca/ext4_crash.jpg

Is this a known bug that got fixed in 2.6.37.1 ?

Thanks
-ml
