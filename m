From: TAEIL UM <taeil.ted.um@gmail.com>
Subject: ext4: how to guarantee the contiguous block allocation?
Date: Tue, 16 Jul 2013 13:50:13 -0700
Message-ID: <CA+dkQCkUMDtUOSjamObC1K3suAikb3TuyjwUt9-ANKN-Cdb8rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57168 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab3GPUuN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jul 2013 16:50:13 -0400
Received: by mail-pd0-f181.google.com with SMTP id 14so1056662pdj.40
        for <linux-ext4@vger.kernel.org>; Tue, 16 Jul 2013 13:50:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have a situation that needs the contiguous block allocation from
application point of view.
For example, is there any way for ext4 to allocates the contiguous
blocks for my 128KB file write?

In the source code, mballoc seems to guarantee the contiguous blocks
allocation with the maximum of s_mb_stream_request, which is 16 by
default.
the comment in the source code also says s_mb_stream_request is
configurable by /sys/fs/ext4/<partition>/mb_stream_req.
If it works, I can set s_mb_stream_request to 32 for 128KB contiguous
block allocation in case of 4KB block size.

Thanks,
Ted
