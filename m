From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 00/11 RESEND] e4defrag: fragmentation score rework and
 cleanups
Date: Fri, 17 Jun 2011 14:13:41 +0900
Message-ID: <4DFAE285.9010503@sx.jp.nec.com>
References: <4DF916B8.5010001@wpkg.org> <4DF99052.8020201@sx.jp.nec.com> <4DF9BC52.40203@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60082 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1FQFOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 01:14:31 -0400
In-Reply-To: <4DF9BC52.40203@wpkg.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/06/16 17:18, Tomasz Chmielewski wrote:
> I noticed that when using e4defrag on such a file-based image, while the
> guest is running (i.e. the file is in use), all IO from that guest to
> the disk (disk is this file) is "frozen".
>
> In other words, as soon as we run e4defrag, any guest writes to that
> file will only complete if e4defrag finishes. As the images can be quite
> big, it can mean guest IO can be frozen even for hours.
>
>
> Is it a known/intended limitation (at least, it behaved like this when I
> tried e4defrag a few months ago)?

Thank you for the feedback. I will try to reproduce this problem later.

Regards,
Kazuya Mio
