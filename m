From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix a bug when we try to open a file with
 O_TMPFILE flag
Date: Tue, 23 Jul 2013 17:59:28 +0800
Message-ID: <20130723095928.GA3278@gmail.com>
References: <20130717161944.GA19405@redhat.com>
 <20130719121405.GA3856@gmail.com>
 <CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49405 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3GWJ7g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jul 2013 05:59:36 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so7953003pdj.22
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jul 2013 02:59:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGW2f1GqTR8xtE_bEN3O+QrRy75h9EjHYkYVnn7-vaoRucaQzg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 23, 2013 at 07:51:41AM +0000, jon ernst wrote:
> Hi Zheng,
> 
> I updated my kernel code to this commit, built kernel and loaded this kernel.
> I checked "uname -r", it is 3.11.0-rc1+ But when I run your test code,
> I always got "O_TMPFILE" undeclared.
> Could you please help, what could be wrong? (I included fcntl.h)

Ah, actually I used the following program to hit the bug.  Just for your
information.  Please let me know if you have any question.

Regards,
                                                - Zheng

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>

#define __O_TMPFILE	020000000
#define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)

int main(int argc, char *argv[])
{
	int fd;

	fd = open(argv[1], O_RDWR|O_TMPFILE);
	if (fd < 0) {
		perror("open ");
		return -1;
	}
	close(fd);
	return 0;
}
