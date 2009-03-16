From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Same magic in statfs() call for ext?
Date: Mon, 16 Mar 2009 11:13:13 -0500
Message-ID: <49BE7A99.5050601@redhat.com>
References: <20090316133615.GA10596@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbZCPQNb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 12:13:31 -0400
In-Reply-To: <20090316133615.GA10596@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>   Hi,
> 
>   I've just noticed that EXT2_SUPER_MAGIC == EXT3_SUPER_MAGIC ==
> EXT4_SUPER_MAGIC. 

Just noticed?  *grin*

> That is just fine for the disk format but as a result we
> also return the same magic in statfs() syscall and thus a simple
> application has hard time recognizing whether it works on ext2, ext3 or
> ext4 (it would have to parse /proc/mounts and that is non-trivial if not
> impossible when it comes to bind mounts). 

I have a guess as to why they want to know, and ...

> So should not we return different
> magic numbers depending on how the filesystem is currently mounted?
>   Now you may ask why should the application care - and I agree that in the
> ideal world it should not. But for example there's a thread on GTK mailing
> list [1] where they discuss the problem that with delayed allocation and
> ext4, user can easily lose his data after crash 

... sadly I was right.  :)

> (Ted wrote about it here in
> some other mail some time ago). So they would like to call fsync() after
> the file is written but on ext3 that is quite heavy and because of autosave
> saving happens quite often. So they'd do fsync() only if the filesystem
> is mounted as ext4...
>   So I'm writing here so hear some opinions on returning different magic
> numbers from statfs().
> 
> 								Honza
> 
> [1] http://mail.gnome.org/archives/gtk-devel-list/2009-March/msg00082.html

As an aside, Ted also pointed out that ext4-without-delalloc also hurts
on fsync just like ext3 does, so testing "ext3 vs. ext4" isn't quite
enough in general.

I have been a bit dismayed that app writers just want the old ext3
behavior (which still has a window for loss, doesn't it?) so that they
can get away without fsyncing.  And talking to KDE folks and others, I
think that if ext3 didn't hurt so much w/ fsync, they would just happily
do the right posix-defined thing and add fsync() when needed.

But instead, since they are now justifiably afraid of fsync, we are in
this quandary.  (maybe this is over-simplifying a bit).

But off the top of my head, I think that I would prefer to see
applications generally do the right, posix-conformant thing w.r.t. data
integrity (i.e. fsync()) unless, via statfs, they find out "fsync hurts,
and we're likely to be reasoonably safe without it"

IOW, adding exceptions for ext3 sounds better to me than munging ext4,
xfs, btrfs, and all future filesystems to conform to some behavior which
isn't in any API or spec ...

-Eric

