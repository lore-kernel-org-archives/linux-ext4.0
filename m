From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 00/11 RESEND] e4defrag: fragmentation score rework and cleanups
Date: Fri, 17 Jun 2011 09:08:19 -0400
Message-ID: <BANLkTimFCQNt=Bptn-rhPeTbYRgfGdQLxQ@mail.gmail.com>
References: <4DF916B8.5010001@wpkg.org> <4DF99052.8020201@sx.jp.nec.com>
 <4DF9BC52.40203@wpkg.org> <4DFAE285.9010503@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab1FQNIv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 09:08:51 -0400
Received: by bwz15 with SMTP id 15so747213bwz.19
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2011 06:08:49 -0700 (PDT)
In-Reply-To: <4DFAE285.9010503@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 17, 2011 at 1:13 AM, Kazuya Mio <k-mio@sx.jp.nec.com> wrote:
> 2011/06/16 17:18, Tomasz Chmielewski wrote:
>>
>> I noticed that when using e4defrag on such a file-based image, while the
>> guest is running (i.e. the file is in use), all IO from that guest to
>> the disk (disk is this file) is "frozen".
>>
>> In other words, as soon as we run e4defrag, any guest writes to that
>> file will only complete if e4defrag finishes. As the images can be quite
>> big, it can mean guest IO can be frozen even for hours.
>>
>>
>> Is it a known/intended limitation (at least, it behaved like this when I
>> tried e4defrag a few months ago)?
>
> Thank you for the feedback. I will try to reproduce this problem later.
>
> Regards,
> Kazuya Mio

Kazuya,

When trying to come up with a better plan for handling large files,
you may want to review this msg and Akira's response from last spring:

http://www.kerneltrap.com/mailarchive/linux-ext4/2010/3/30/6899823

Greg
