From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular
 file
Date: Mon, 5 May 2014 16:04:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051558040.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain> <20140505135239.GB22287@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1613508857-1399298701=:2223"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbaEEOFD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:05:03 -0400
In-Reply-To: <20140505135239.GB22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1613508857-1399298701=:2223
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon, 5 May 2014 09:52:39 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular file
> 
> On Mon, May 05, 2014 at 03:41:01PM +0200, Lukáš Czerner wrote:
> > On Mon, 5 May 2014, Theodore Ts'o wrote:
> > 
> > > Date: Mon,  5 May 2014 09:04:02 -0400
> > > From: Theodore Ts'o <tytso@mit.edu>
> > > To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> > > Cc: Theodore Ts'o <tytso@mit.edu>
> > > Subject: [PATCH 1/3] mke2fs: print a message when creating a regular file
> > 
> > Description is missing.
> 
> I didn't think more of a description was needed; can you suggest one?

something along those lines ?

In the previous patch "..." we've added an ability to automatically
create file if it does not exist prior creating the file system. We
should at least notify the user that that's the case to avoid surprises
in the case of misspelled device/file names.

> 
> > >  	/* Can't undo discard ... */
> > > -	if (!noaction && discard && (io_ptr != undo_io_manager)) {
> > > +	if (!noaction && discard && dev_size && (io_ptr != undo_io_manager)) {
> > 
> > I wonder whether it's possible not to have dev_size set at this point ?
> 
> I checked, and I don't believe so.  ext2fs_get_device_size2() never
> returns EXT2_ET_UNIMPLEMENTED any more; and it hasn't for quite some
> time, since it will use st_size for a regular file or do a binary
> search trying to figure out the device size in the worst case.  So in
> fact, there are some code paths we can eliminate in misc/mke2fs.c
> which will simplify this analysis.
> 
> Even if there is some case in the future where dev_size could be left
> unset, it will be initialized to zero, at which point we will fail
> safe by skipping the mke2fs_discard_device() call.

ok.

> 
> > 
> > > +	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
> > > +		fl |= O_CREAT;
> > > +		fd = open(device, fl, 0666);
> > > +		if (fd >= 0 && (flags & VERBOSE_CREATE))
> > 
> > Do we have to use VERBOSE_CREATE ? quiet is global variable so we
> > can as well just test that here, or am I missing something ?
> 
> The problem is that util.c gets used by both mke2fs.c and tune2fs.c,
> and it's only a global variable for mke2fs.c.
> 
> My long-term plans is to rename libquota to libsupport, which would
> never be built as a shared library, and move some of our various
> internal shared utility functions (i.e., e2fsck/profile.c,
> misc/util.c, etc.) into that internal e2fsprogs insternal support
> library.  So in general I'd prefer to minimize the number of global
> functions which misc/util.c relies upon.

Ah, it's in a different file, right. Agreed.

Thanks!
-Lukas

> 
> Cheers,
> 
> 					- Ted
> 
--8323328-1613508857-1399298701=:2223--
