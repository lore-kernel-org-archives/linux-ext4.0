From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: 3.4->(3.5.1 || 3.6-rc1) => can no longer mount 60TB ext4 filesystem
Date: Sat, 11 Aug 2012 13:36:19 -0400
Message-ID: <005501cd77e7$d222d020$76687060$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <ap@solarrain.com>
To: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40677 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2HKRgW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Aug 2012 13:36:22 -0400
Received: by yhmm54 with SMTP id m54so2451665yhm.19
        for <linux-ext4@vger.kernel.org>; Sat, 11 Aug 2012 10:36:21 -0700 (PDT)
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I upgrade to each new kernel release and with 3.5.1 (from 3.4) I can no
longer mount my 60TB ext4 volume.
If I boot back to 3.4, it works fine.

Details here:
https://lkml.org/lkml/2012/8/10/205

Anything I can do besides testing each 3.5-rcX to find where the regression
lies?

Justin.


