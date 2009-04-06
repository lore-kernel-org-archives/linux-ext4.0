From: Michael Rubin <mrubin@google.com>
Subject: Re: Use of kmalloc vs vmalloc in ext4?
Date: Sun, 5 Apr 2009 23:45:10 -0700
Message-ID: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
References: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:3379 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZDFGpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 02:45:15 -0400
Received: from zps78.corp.google.com (zps78.corp.google.com [172.25.146.78])
	by smtp-out.google.com with ESMTP id n366jDDQ000529
	for <linux-ext4@vger.kernel.org>; Sun, 5 Apr 2009 23:45:13 -0700
Received: from gxk17 (gxk17.prod.google.com [10.202.11.17])
	by zps78.corp.google.com with ESMTP id n366jBIC010942
	for <linux-ext4@vger.kernel.org>; Sun, 5 Apr 2009 23:45:12 -0700
Received: by gxk17 with SMTP id 17so4398727gxk.21
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2009 23:45:11 -0700 (PDT)
In-Reply-To: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Anyone have any comments? Or historical reasons? We operate with some
constrained memory situations, and were wondering if a patch to move
from kmalloc to vmalloc would be well received.

mrubin

On Wed, Mar 11, 2009 at 7:32 AM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> I've been running various tests of ext4 partitions lately, and have
> found that with very low memory situations, I'm getting intermittent
> mount failures due to ENOMEM from ext4_mb_init() and
> ext4_fill_flex_info() . =A0Here's a typical dmesg from the latter:
>
> =A0 =A0 =A0 =A0 =A0EXT4-fs: not enough memory for 8198 flex groups
> =A0 =A0 =A0 =A0 =A0EXT4-fs: unable to initialize flex_bg meta info!
>
> This is from a kzalloc() call of size ~64k . =A0I think the
> ext4_mb_init() calls to kmalloc() and alloc_percpu() are even smaller=
=2E
>
> I was wondering why all the code in ext4 (and ext[23], for that
> matter) uses kmalloc() and friends instead of vmalloc(), at least
> where it's safe; is it just for performance reasons?
>
> I've seen the above errors when I do a mount -a, causing several
> partitions to be mounted; I can usually mount the failed ones by hand
> right afterwards, but this is a big difference for us, in our
> environment, compared to, say, ext2 partitions.
>
> Thanks,
> Curt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
