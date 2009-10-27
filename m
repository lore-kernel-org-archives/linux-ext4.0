From: Fredrik Andersson <nablaman@gmail.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Tue, 27 Oct 2009 16:29:12 +0100
Message-ID: <a125a870910270829u794853c4x370d2bae86499de4@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4AE67A1B.8060704@redhat.com>
	 <a125a870910270117qa90debp8d5a9f90ffb8434@mail.gmail.com>
	 <4AE6FC25.3000801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:55232 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZJ0P3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Oct 2009 11:29:09 -0400
Received: by ewy4 with SMTP id 4so265268ewy.37
        for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2009 08:29:12 -0700 (PDT)
In-Reply-To: <4AE6FC25.3000801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> To try to emulate, how does it write into the preallocated space; lar=
ge or
> small IOs? =A0Sequential streaming? =A0mmap writes? =A0It may not be =
relevant but
> would be nice to try to match it as closely as possible.

This is a big file that is written sequentially using stdio buffered
I/O (with a setvbuf of about 4K) in the drdbmake process. No mmap.
It is regenerated from an earlier version of the same file, and we
preallocate a file that is 25% bigger than the
previous version, to allow for more data than was in the previous file
and to utilize the extent concept in ext4.
We then read the previous file sequentially, update some entries here
and there and
rewrite it sequentially into the new, fallocated file. There is one
single instance of random I/O: Once the whole new
file has been written, we seek back to the start to write a fixed-size
header. We then ftruncate the file to the proper size.
No process is concurrently reading from the file that is being
written. There is however another process, nodeserv,
that does random reads from the "previous" file (the one we're
sequentially reading in drdbmake).
The deadlock is always in the final ftruncate. It does not help to
close the file and reopen it again before the ftruncate call.

/Fredrik
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
