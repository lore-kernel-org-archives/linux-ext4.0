From: Nick R <reddyn.lists@gmail.com>
Subject: how does one figure out I/O bottlenecks between 2 version of the kernel?
Date: Sun, 12 Oct 2014 04:30:20 -0700
Message-ID: <CA+nQAmakcohVNJJ6fFhRG835WYq76_hDr5eTX+_ui2b+LNHf6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:47895 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLLaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2014 07:30:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I am new new at this....Sorry if I missed something obvious..

I have been asked a few times to figure out bottlenecks in I/O that
cause benchmark scores to degrade between two builds of the kernel...
(new build which has a few thousand commits seems to have a worse I/O
performance number than the old build).

Often times I end up spending time trying a bisect or reverting
commits to check if they were the cause ..and after is usually found
to be some commit in the storage driver or some other module ...and
not the filesystem.


What would be the best way to profile where the bottleneck is in I/O?
Are there built in profiling options?

I tried turning on ext4 events but that itself seems to add to the
performance overhead...Also couldnt figure out how to use the data..


Or is there a nice way to prove that the filesystem is not the cause?

I am fairly new to this and might be missing out on something obvious..

Sorry if I was not supposed to mail directly...

Please let me know.

Thanks

Nick
