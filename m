From: Andreas Dilger <adilger@sun.com>
Subject: Re: Use of kmalloc vs vmalloc in ext4?
Date: Mon, 06 Apr 2009 03:33:10 -0600
Message-ID: <20090406093310.GJ3199@webber.adilger.int>
References: <6601abe90903110732n5c9df9b9td317be316921b7a6@mail.gmail.com>
 <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Curt Wohlgemuth <curtw@google.com>, linux-ext4@vger.kernel.org
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53647 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZDFJdU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 05:33:20 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n369XGJJ008214
	for <linux-ext4@vger.kernel.org>; Mon, 6 Apr 2009 02:33:16 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHO00800ACHYN00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 06 Apr 2009 02:33:16 -0700 (PDT)
In-reply-to: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 05, 2009  23:45 -0700, Michael Rubin wrote:
> Anyone have any comments? Or historical reasons? We operate with some
> constrained memory situations, and were wondering if a patch to move
> from kmalloc to vmalloc would be well received.

On 32-bit machines vmalloc space is tiny, and in all cases vmalloc
performance sucks, so traditionally very little kernel allocation
is done with vmalloc.  For one-off allocations like per-fs it is
probably OK to change them to vmalloc.

> On Wed, Mar 11, 2009 at 7:32 AM, Curt Wohlgemuth <curtw@google.com> w=
rote:
> > I've been running various tests of ext4 partitions lately, and have
> > found that with very low memory situations, I'm getting intermitten=
t
> > mount failures due to ENOMEM from ext4_mb_init() and
> > ext4_fill_flex_info() . =A0Here's a typical dmesg from the latter:
> >
> > =A0 =A0 =A0 =A0 =A0EXT4-fs: not enough memory for 8198 flex groups
> > =A0 =A0 =A0 =A0 =A0EXT4-fs: unable to initialize flex_bg meta info!
> >
> > This is from a kzalloc() call of size ~64k . =A0I think the
> > ext4_mb_init() calls to kmalloc() and alloc_percpu() are even small=
er.
> >
> > I was wondering why all the code in ext4 (and ext[23], for that
> > matter) uses kmalloc() and friends instead of vmalloc(), at least
> > where it's safe; is it just for performance reasons?
> >
> > I've seen the above errors when I do a mount -a, causing several
> > partitions to be mounted; I can usually mount the failed ones by ha=
nd
> > right afterwards, but this is a big difference for us, in our
> > environment, compared to, say, ext2 partitions.
> >
> > Thanks,
> > Curt
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
