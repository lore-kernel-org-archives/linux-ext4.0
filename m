From: jon ernst <jonernst07@gmail.com>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with O_TMPFILE flag
Date: Wed, 24 Jul 2013 21:58:45 +0000
Message-ID: <CAGW2f1HgtwdekeETXpZvm-KT6Sdw1bUas799yWjQ_jZp3kwaug@mail.gmail.com>
References: <20130717161944.GA19405@redhat.com>
	<20130719121405.GA3856@gmail.com>
	<CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
	<20130723095928.GA3278@gmail.com>
	<CAGW2f1GjYwVjw=b1O+_SmSW6CvCd9R1QP54TXFo7XoMguOqR=g@mail.gmail.com>
	<20130723233859.GA5435@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53041 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3GXV6r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 17:58:47 -0400
Received: by mail-ob0-f176.google.com with SMTP id v19so14217307obq.21
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jul 2013 14:58:46 -0700 (PDT)
In-Reply-To: <20130723233859.GA5435@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> My purpose is to trigger this bug and fix it.  So I manually define this
> flag for my convenience.
>
>> I saw it has
>> been defined in header file. (fcntl.h) Did I miss anything?
>
> I guess that you might 'include <fcntl.h>' header file, right?  But the
> O_TMPFILE is defined in $LINUX/include/uapi/asm-generic/fcntl.h.  So
> maybe compiler couldn't find this header file.
>
> Regards,
>                                                 - Zheng
--
Got it. Thank you.  BTW, the weird thing is I didn't see any
discussion on ext4 mailing list before Al Viro committed this change.
The first time I heard about this is someone reporting a bug about it.
Document about this FLAG might be necessary.
Also, about this code:

/* a horrid kludge trying to make sure that this will fail on old kernels */
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)

why not doing something like this:

#ifndef O_TMPFILE
/* a horrid kludge trying to make sure that this will fail on old kernels */
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
#endif

Thanks,
Jon
