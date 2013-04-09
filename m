From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Fwd: block level cow operation
Date: Tue, 9 Apr 2013 14:35:56 +0530
Message-ID: <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60004 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935971Ab3DIJGV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 05:06:21 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so2733433eei.34
        for <linux-ext4@vger.kernel.org>; Tue, 09 Apr 2013 02:06:19 -0700 (PDT)
In-Reply-To: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am trying to implement copy on write operation by reading the
original disk block and writing it to some other location and then
allowing the write to pass though (block the write operation till the
read or original block completes) I tried using submit_bio() /
sb_bread() to read the block and using the completion API to signal
the end of reading the block but the performance of this is very bad.
It takes around 12 times more time for any disk writes. Is there any
better way to improve the performance ?

Not waiting for the completion of the read operation and letting the
disk write go through gives good performance but under 10% of the
cases the read happens after the write and ends up the the new data
and not the original data.

Regards.
