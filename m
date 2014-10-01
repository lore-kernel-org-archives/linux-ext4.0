From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: 3.17? problems
Date: Wed, 1 Oct 2014 10:48:10 +0200
Message-ID: <20141001084810.GA17405@quack.suse.cz>
References: <20140929114408.GC2738@quack.suse.cz>
 <87iok6ojis.fsf@openvz.org>
 <20140928124658.GB6694@thunk.org>
 <20140930210108.GB14283@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140930210108.GB14283@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 30-09-14 23:01:08, Pavel Machek wrote:
> > > On next boot to Debian stable, I got stacktrace, and messages about
> > > ext4 corruption. Back to Debian testing. systemd ran fsck, determined
> >   It would be really good to get those messages... Ideally you could also
> > use
> >   e2image -r <partition> | bzip2 -c
> > to store fs metadata before doing anything else with the fs to a usb stick.
> > That is invaluable for future analysis.
> 
> Too late for that :-(.
  OK, you can take a note for next time ;)

> > > it can't fix it, dropped me into emergency shell, _but mounted the
> > > filesstem, anyway_. Oops.
> >   What kernel versions are you running in Debian testing and stable?
> 
> Debian testing was 3.17-rc4, AFAICT. For debian stable -- not sure.
  OK, there were some changes to orphan list locking in 3.17-rc1. If I
screwed up it could cause orphan list corruption. But for now I don't think
that's the issue.

> > My guess would be that kernel had problems only during orphan inode
> > recovery (i.e. when deleting already deleted files) and we let the mount
> > proceed if this fails because it's a relatively harmless problem.
> 
> Is there some phase during shutdown where journalling no longer
> protects fs integrity?
  No. We first finish all modifications to the fs and only after that clean
up the journal. So that makes all changes to the fs protected.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
