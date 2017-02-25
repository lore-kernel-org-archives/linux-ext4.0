From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: dirty_ratio
Date: Sat, 25 Feb 2017 11:56:58 +0000
Message-ID: <CAAMvbhEbraxyJtST5-ujZvdi5T_nRByU2gXHa0dBtzwb3ovvWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:34314 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdBYM1q (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Feb 2017 07:27:46 -0500
Received: by mail-yb0-f175.google.com with SMTP id i66so10836252yba.1
        for <linux-ext4@vger.kernel.org>; Sat, 25 Feb 2017 04:27:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a server that has basically two tasks.
1) Receiving lots of data from the network and storing it on disk.
2) An App that makes relatively small use of the disk and responds to
requests from the network.

The problem I have is that sometimes (1) is filling up all the "Dirty"
pages, triggering a blocking flushing of the dirty buffer to the disk.
This essentially freezes (1) and (2) until the flushing is complete.
On occasions, this can take more than 60 seconds.
60 seconds is far too long from (2) point of view, because it needs to
respond to user requests quickly, i.e less than 1 second.

Is there any mechanism that could result in (1) being informed about
the problem, (1) could then back off writing data to disk, and then at
the same time, asked the sending system over the network to also back
off.

On TCP/IP networks, this is reported back as "congestion" on the
network, the this results in throttling of the sending application on
a per TCP session basis.

In the above case, we are essentially seeing "congestion" to a
particular storage disk, but the application does not get any feedback
about this.

I guess the perfect solution would be Quality-of-Service for disk
writes, much like we have for network traffic.

So, is there a feature available that can help me here, or will I have
to look at modifying the Linux kernel in order to add support for
"congestion notification from disk writes" ?

In my view that "dirty_ratio" causing the whole system to appear to
freeze due to disk blocking is too blunt an instrument.

Also, even detecting if the 60 second freezes are a result of the
"dirty_ratio" being hit is difficult to do.  It would be useful if
there existed a counter that would count the amount of times the
system resorted to "blocking" writes, as opposed to the
non-problematic background writes.

In my view, whenever the "blocking" writes was initiated, the
application should be informed about it.
Another alternative could be that the dirty pages are associated with
the application process and file descriptor and a dirty_ratio set per
file descriptor. Then, when a dirty_ratio is hit on the file
descriptor, only the application that holds that fd is frozen.
Maybe have multi-level limits. I.e. Warn App at limit A, freeze app at limit B.

Kind Regards

James
