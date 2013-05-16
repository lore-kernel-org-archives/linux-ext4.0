From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How can I flush all writes before yanking the power cable?
Date: Thu, 16 May 2013 15:03:42 -0400
Message-ID: <20130516190342.GA29931@thunk.org>
References: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
 <5113EE8F.2080104@redhat.com>
 <CADzUK1LnJ7nhgMf-6nigxfnaa0MY16NOwpAkuy4qEy7E=wG7hg@mail.gmail.com>
 <CADzUK1J9Zqc=kZhrFy3W9=h0p+L9vWzBhv5a3ZJbW_WAeawwOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Autif Khan <autif.mlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49044 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab3EPTDr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 15:03:47 -0400
Content-Disposition: inline
In-Reply-To: <CADzUK1J9Zqc=kZhrFy3W9=h0p+L9vWzBhv5a3ZJbW_WAeawwOA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 16, 2013 at 02:31:45PM -0400, Autif Khan wrote:
> > >
> > > 1) You're not mounting w/ barriers, and you lose data in the SSD's cache
> >
> > That was precisely my ignorance. I did not know about barrier. Adding
> > it during mount ro and remount rw seems to have fixed these issues.

What kernel version and file system (ext3 vs ext4) are you using?
Barriers have been enabled by default for quite a while.

> > > 2) You *are* mounting w/ barriers, and the SSD is lying to you
> 
> Resurrecting this thread as we have run into a very peculiar problem.
> 
> We now mount our partitions either ro or rw,barriers=1 and remount
> ro,barrier=1 after write is complete.
> 
> This worked beautifully well on the one prototype that we have.
> 
> We built another prototype with a different mSATA SSD and we are now
> seeing FS corruption after we mount rw,barrier=1, write, remount
> ro,barrier=1 and finally yank the power cable (after a considerable
> wait ~10 seconds). We tried 3-4 different SSDs but we have the one SSD
> that does not exhibit this issue and several SSDs that do exhibit this
> issue. The issue travels with the SSD.

Are the SSD's from different manufacturers?  If they are from the same
manufacturer and have the same model number, do they have the same
firmware version?

Note that there are some cheap (or to put another way, crappy) SSD's
where yanking the power cable at the wrong time causes the SSD's
internal metadata for its Flash Translation Layer to get corrupted,
and you end up with a completely bricked SSD.

This was much more common in the past with Compact Flash cards, where
stories of wedding photographers who lost all of their photos from a
wedding shoot after they accidentally ejected their flash card, and
the CF card was complteely toasted.  If you were lucky, the compact
flash manufacturer had special recovery software that would allow you
to do the moral equivalent of running fsck on the FTL metadata (since
the FTL can be thought of as a file system, where instead of file
names you use sector numbers instead), and then you might get to
recover some of the photos.  If you were not so lucky, you got to
replace the compact flash card (which was annoying, but the cost of
losing all of the wedding photos was often far more expensive from a
commercial perspective).

> I am guessing that the SSD is lying (Eric's choice of the word - above :-)
> 
> How can we tell if an SSD supports barriers or flushes etc?

Well, it's not necessarily lying --- it could just be buggy.  That is,
it tried to make sure all of the data was written to the flash chips,
but on a ower pull, the SSD's FTL metadata got corrupted, and this
caused the wrong data to be returned when you try to read from the SSD
--- which in some ways is worse, since if the SSD is lying, it's
generally only the most recently written blocks which get lost.  If
the SSD is buggy, blocks written hours or days ago could get lost when
the FTL gets corrupted.

Well, if you're a manufacturer, you write programs which test to see
whether the SSD does the right thing after a power pull (i.e. write a
test progam which writes blocks with timestamps and periodic CACHE
FLUSH commands, and then execute a power drop, and then verify that
the data on the disk is as you expect).  If it isn't, then you reject
the SSD vendor as providing devices which are not fit for purpose.
Since as a manufacturer, you're purchasing SSD's or eMMC devices by
the millions, you have a certain amount of leverage over the
manufacturer.  :-)

If you're some random end user, you're basically at the mercy of the
SSD manufacturer.  You can look at various review sites, but
unfortunately not all reviewers test to make sure the barriers work
correctly and that the device is robust against power drops.  The
problem is all of the reviewers tend to do performance tests, and so
there is a huge temptation to optimize for performance over
robustness....

     	 	   	  	  	       - Ted
