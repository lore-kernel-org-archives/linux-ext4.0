From: "Peter Meier" <meiepeter@gmail.com>
Subject: Trying out 2.6.26-ext4-3
Date: Sun, 27 Jul 2008 10:28:49 +0000
Message-ID: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:2083 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYG0K2t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 06:28:49 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5100809wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2008 03:28:49 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

well, the timely release of 2.6.26-ext4-3 seemed like a good
omen, and so I decided to try and put my new home box in-
stall on ext4 today, using that latest patchset and e2fsprogs
1.41.0. So far I'm not getting very far.

I'm attempting to install Gentoo Linux, which involves copying
an initial tarball to the root file system and unpacking it. Already
while downloading the tarball into the FS my console an dmesg
were getting spammed with messages of the type:

JBD: pdflush wants too many credits (x > y)

And then, while unpacking it:

JBD: tar wants too many credits (x > y)
JBD: pdflush wants too many credits (x > y)

The latter repeatedly and with no end, to the point where I
eventually had to hard reset the box because it seemingly
wasn't going to stop while acchieving no disk activity (LED
not blinking).

I have an inkling that mke2fs -t ext4 dev didn't make a big
enough journal in the 46 GB big partition, but not being an
ext-pert (...) I wouldn't really know how to interpret the error.

So, anyone want to rescue my Sunday and give some pointers?


Greetings,
Peter
