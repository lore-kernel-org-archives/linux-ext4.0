From: jon ernst <jonernst07@gmail.com>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with O_TMPFILE flag
Date: Tue, 23 Jul 2013 13:39:39 +0000
Message-ID: <CAGW2f1GjYwVjw=b1O+_SmSW6CvCd9R1QP54TXFo7XoMguOqR=g@mail.gmail.com>
References: <20130717161944.GA19405@redhat.com>
	<20130719121405.GA3856@gmail.com>
	<CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
	<20130723095928.GA3278@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55083 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab3GWNjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jul 2013 09:39:40 -0400
Received: by mail-oa0-f44.google.com with SMTP id l10so11121726oag.17
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jul 2013 06:39:39 -0700 (PDT)
In-Reply-To: <20130723095928.GA3278@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Ah, actually I used the following program to hit the bug.  Just for your
> information.  Please let me know if you have any question.
>
> Regards,
>                                                 - Zheng
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
>
> #include <unistd.h>
> #include <sys/types.h>
> #include <fcntl.h>
>
> #define __O_TMPFILE     020000000
> #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
>
> int main(int argc, char *argv[])
> {
>         int fd;
>
>         fd = open(argv[1], O_RDWR|O_TMPFILE);
>         if (fd < 0) {
>                 perror("open ");
>                 return -1;
>         }
>         close(fd);
>         return 0;
> }

Thank you Zheng!  Pardon if this is a dumb question: why do we need to
manually define "O_TMPFILE"? Not like "O_APPEND" etc. ?  I saw it has
been defined in header file. (fcntl.h) Did I miss anything?

Thanks!
