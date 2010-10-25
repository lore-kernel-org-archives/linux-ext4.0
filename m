From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [RFC] Ext4 snapshots design challenges
Date: Mon, 25 Oct 2010 18:05:23 +0200
Message-ID: <AANLkTikO8Mi+pfkb0U6WkCEOPd0ar4m+1auVdsf9uUhD@mail.gmail.com>
References: <AANLkTim=4-uyczhhLOA79gsj7oHh=7O8f7ZiLMj3q3sB@mail.gmail.com>
	<AANLkTikGK8X-Tupdo0oqNe60DTyHRUB5svvBBiWwkytj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	next3-devel@lists.sourceforge.net
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62063 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0JYQFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 12:05:24 -0400
Received: by qyk10 with SMTP id 10so1848623qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 09:05:23 -0700 (PDT)
In-Reply-To: <AANLkTikGK8X-Tupdo0oqNe60DTyHRUB5svvBBiWwkytj@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 5:24 PM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> Amir,
>
> I recently saw an announcement for X-Ways Forensics
> (http://www.x-ways.net/) that they now support next3 as a filesystem
> to analyze. =A0See Oct. 10 msg under topic "Announcements: X-Ways
> Forensics 15.8" at http://www.winhex.net/ =A0(I think that is a publi=
c
> posting board.)
>
> I was surprised to see that, but assuming it was indeed your project
> they added support for, I congratulate you on the above.
>

Thanks! I guess :-)
I am pretty clueless with regards to the big players in the storage mar=
ket.
I do not know X-Ways, but it looks like they are a big player.

> I'm curious what level of support they offer. =A0In particular, they
> only offer limited support for NTFS shadow copies, so I'm curious if
> the next3 support is similarly limited.
>
> Or since next3 is GPL they may have been able to do a more
> comprehensive job with it than with ntfs shadow copies.
>
> Any info you have would be appreciated.
> Greg
>

As you can figure out, I was not involved or notified about this move.
Judging from their release notes, I would say that the added support is
mostly adding some information tags and verifying the correctness of th=
e
exclude bitmap:

* Support for the Linux file system next3. The exclude bitmap inode
will be evaluated,
  and snapshot files are marked with (SF) in the Attribute column.
  Specialist license or higher required.

You shouldn't be too surprised to learn that the only file system
integrity test that
I have added in my e2fsprogs patches is verifying the correctness of
the exclude bitmap ;-)

Thanks for the info and sorry if your post was rejected from next3-deve=
l.
I fixed the permissions for out of list posts.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
