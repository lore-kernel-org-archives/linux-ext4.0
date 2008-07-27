From: "Peter Meier" <meiepeter@gmail.com>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Sun, 27 Jul 2008 10:58:30 +0000
Message-ID: <c354edc90807270358g6df6b3cbib2c419ed912485fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:4476 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYG0K6b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 06:58:31 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5112347wfd.4
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2008 03:58:30 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi again,

some more info:

The x and y in the error messages used to be around 20k
or  30k for x and 8192 for y. Googling around, it seems that's
supposed to say that the maxium transaction size is 8192
blocks. Further, the maximum transaction size is supposedly
1/4 of the journal size. Assuming mke2fs -t ext4dev created
the FS with 4096 blocks (dunno) that would mean the journal
is 128MB, which is apparently typical. At least I have a 40GB
ext3 here that got the same journal size.

So I guess the question is why a basic operation like using
links to download a 130MB tar archive to an ext4dev file sys-
tem or unpacking it with tar would die by way of huge trans-
actions that don't work with a normal journal.

Still hoping I'll be able to continue with the installation today
before the work week starts again ;). Kernel hackers read
lists on Sunday, I hope :-).


Greetings,
Peter

PS.: I'm writing via the shitty GMail web interface from an in-
stall CD; here's hoping replying will work better than I fear it
might.
