From: Jan Kara <jack@suse.cz>
Subject: Re: Same magic in statfs() call for ext?
Date: Mon, 16 Mar 2009 17:27:38 +0100
Message-ID: <20090316162737.GC10596@duck.suse.cz>
References: <20090316133615.GA10596@duck.suse.cz> <49BE7A99.5050601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:59322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZCPQ1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 12:27:41 -0400
Content-Disposition: inline
In-Reply-To: <49BE7A99.5050601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 16-03-09 11:13:13, Eric Sandeen wrote:
> Jan Kara wrote:
> >   Hi,
> > 
> >   I've just noticed that EXT2_SUPER_MAGIC == EXT3_SUPER_MAGIC ==
> > EXT4_SUPER_MAGIC. 
> Just noticed?  *grin*
  ;-)

> > That is just fine for the disk format but as a result we
> > also return the same magic in statfs() syscall and thus a simple
> > application has hard time recognizing whether it works on ext2, ext3 or
> > ext4 (it would have to parse /proc/mounts and that is non-trivial if not
> > impossible when it comes to bind mounts). 
> 
> I have a guess as to why they want to know, and ...
> 
> > So should not we return different
> > magic numbers depending on how the filesystem is currently mounted?
> >   Now you may ask why should the application care - and I agree that in the
> > ideal world it should not. But for example there's a thread on GTK mailing
> > list [1] where they discuss the problem that with delayed allocation and
> > ext4, user can easily lose his data after crash 
> 
> ... sadly I was right.  :)
> 
> > (Ted wrote about it here in
> > some other mail some time ago). So they would like to call fsync() after
> > the file is written but on ext3 that is quite heavy and because of autosave
> > saving happens quite often. So they'd do fsync() only if the filesystem
> > is mounted as ext4...
> >   So I'm writing here so hear some opinions on returning different magic
> > numbers from statfs().
> > 
> > 								Honza
> > 
> > [1] http://mail.gnome.org/archives/gtk-devel-list/2009-March/msg00082.html
> 
> As an aside, Ted also pointed out that ext4-without-delalloc also hurts
> on fsync just like ext3 does, so testing "ext3 vs. ext4" isn't quite
> enough in general.
  Yes, I know but it's at least some approximation.

> I have been a bit dismayed that app writers just want the old ext3
> behavior (which still has a window for loss, doesn't it?) so that they
> can get away without fsyncing.  And talking to KDE folks and others, I
> think that if ext3 didn't hurt so much w/ fsync, they would just happily
> do the right posix-defined thing and add fsync() when needed.
> 
> But instead, since they are now justifiably afraid of fsync, we are in
> this quandary.  (maybe this is over-simplifying a bit).
> 
> But off the top of my head, I think that I would prefer to see
> applications generally do the right, posix-conformant thing w.r.t. data
> integrity (i.e. fsync()) unless, via statfs, they find out "fsync hurts,
> and we're likely to be reasoonably safe without it"
> 
> IOW, adding exceptions for ext3 sounds better to me than munging ext4,
> xfs, btrfs, and all future filesystems to conform to some behavior which
> isn't in any API or spec ...
  Yes, I agree that if they want data on disk, they should use fsync(). But
as you say for ext3 this is not really usable so they have to somehow
recognize that "they are on a filesystem where fsync() sucks" and avoid it
as much as possible. And I feel slightly in favor of giving them enough rope
(i.e., different magic numbers in statfs) to hang themselves ;-).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
