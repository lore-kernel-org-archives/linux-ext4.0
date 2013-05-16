From: Autif Khan <autif.mlist@gmail.com>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 16 May 2013 14:31:45 -0400
Message-ID: <CADzUK1J9Zqc=kZhrFy3W9=h0p+L9vWzBhv5a3ZJbW_WAeawwOA@mail.gmail.com>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
	<5113EE8F.2080104@redhat.com>
	<CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34692 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3EPSbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 May 2013 14:31:47 -0400
Received: by mail-la0-f51.google.com with SMTP id lx15so1424816lab.10
        for <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 11:31:45 -0700 (PDT)
In-Reply-To: <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 7, 2013 at 2:37 PM, Autif Khan <autif.mlist@gmail.com> wrote:
>
> On Thu, Feb 7, 2013 at 1:12 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 2/7/13 10:43 AM, Autif Khan wrote:
> >> The standard operating procedure to power down my machine is to switch
> >> it off. To work around this, we use mSATA SSDs (actually we recently
> >> switched from SATA SSDs) with linux on a read only partition.
> >
> > Not sure the SSD part makes any significant difference, but the RO
> > mount should.
> >
> >> This works just fine, however, we want to be able to upgrade some
> >> parts of the application. To do this, we have put the application on
> >> /app partition. We mount it read only at start up. When we want to
> >> upgrade the app, we remount read-write sync (mount -o remount,rw,sync
> >> /app) perform the write operations and remount read only.
> >>
> >> If we yank the power cable after this, we get file system errors on
> >> the next reboot.
> >
> > What kind of errors? (and on what kernel?  Are you mounted with
> > barriers enabled?)
>
> Filesystem check errors that the OS throws at you on an unclean
> shutdown. Where it asks you to 'F'ix, 'S'kip, 'Ignore or 'M'anually
> fix the error using fsck. The kernel is a custom kernel for our
> hardware.
>
> > If you use barriers, remount RO, that completes, you yank the power,
> > and you see corruption, I would guess one of a few things is happening:
> >
> > 1) You're not mounting w/ barriers, and you lose data in the SSD's cache
>
> That was precisely my ignorance. I did not know about barrier. Adding
> it during mount ro and remount rw seems to have fixed these issues.
>
> Thanks you very much for all your help.
>
> Autif
>
> > 2) You *are* mounting w/ barriers, and the SSD is lying to you

Resurrecting this thread as we have run into a very peculiar problem.

We now mount our partitions either ro or rw,barriers=1 and remount
ro,barrier=1 after write is complete.

This worked beautifully well on the one prototype that we have.

We built another prototype with a different mSATA SSD and we are now
seeing FS corruption after we mount rw,barrier=1, write, remount
ro,barrier=1 and finally yank the power cable (after a considerable
wait ~10 seconds). We tried 3-4 different SSDs but we have the one SSD
that does not exhibit this issue and several SSDs that do exhibit this
issue. The issue travels with the SSD.

I am guessing that the SSD is lying (Eric's choice of the word - above :-)

How can we tell if an SSD supports barriers or flushes etc?

(Apologies to Eric for spam - somehow I replied, instead of reply to all)

> > 3) There's a bug in our remount,ro path which doesn't quiesce things properly
> >
> > mount -o remount,ro should be >this< close to an unmount; things should
> > be stable on disk when it's done.
> >
> > -Eric
> >
> >> We can display a message to the user telling them that it is safe to
> >> power down the machine.
> >>
> >> My question is
> >>
> >> 1) Is this the right place to discuss this or should I have posted
> >> this in the file systems mailing list?
> >>
> >> 2) how can we determine that all the writes are flushed? (and this it
> >> is safe to yank the power cable)
> >>
> >> 3) is there a better way to do this? - for example we may not have to
> >> remount read write sync - and we can force a sync before remounting
> >> read only or something
> >>
> >> I have already tried "sudo sync" before remounting the filesystem as
> >> read only. It does not help.
> >>
> >> Please advise.
> >>
> >> Thanks
> >>
> >> Autif
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
