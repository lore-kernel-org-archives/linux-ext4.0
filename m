From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Wed, 24 Jul 2013 07:38:59 +0800
Message-ID: <20130723233859.GA5435@gmail.com>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
 <20130723095928.GA3278@gmail.com>
 <CAGW2f1GjYwVjw=b1O+_SmSW6CvCd9R1QP54TXFo7XoMguOqR=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39926 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968Ab3GWXjQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jul 2013 19:39:16 -0400
Received: by mail-pd0-f171.google.com with SMTP id y14so8634765pdi.30
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jul 2013 16:39:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGW2f1GjYwVjw=b1O+_SmSW6CvCd9R1QP54TXFo7XoMguOqR=g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 23, 2013 at 01:39:39PM +0000, jon ernst wrote:
> > Ah, actually I used the following program to hit the bug.  Just for your
> > information.  Please let me know if you have any question.
> >
> > Regards,
> >                                                 - Zheng
> >
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <string.h>
> >
> > #include <unistd.h>
> > #include <sys/types.h>
> > #include <fcntl.h>
> >
> > #define __O_TMPFILE     020000000
> > #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
> >
> > int main(int argc, char *argv[])
> > {
> >         int fd;
> >
> >         fd = open(argv[1], O_RDWR|O_TMPFILE);
> >         if (fd < 0) {
> >                 perror("open ");
> >                 return -1;
> >         }
> >         close(fd);
> >         return 0;
> > }
> 
> Thank you Zheng!  Pardon if this is a dumb question: why do we need to
> manually define "O_TMPFILE"? Not like "O_APPEND" etc. ?

My purpose is to trigger this bug and fix it.  So I manually define this
flag for my convenience.

> I saw it has
> been defined in header file. (fcntl.h) Did I miss anything?

I guess that you might 'include <fcntl.h>' header file, right?  But the
O_TMPFILE is defined in $LINUX/include/uapi/asm-generic/fcntl.h.  So
maybe compiler couldn't find this header file.

Regards,
                                                - Zheng
