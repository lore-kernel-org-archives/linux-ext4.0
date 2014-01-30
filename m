From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] A draft for making ext4 support project quota
Date: Fri, 31 Jan 2014 07:19:21 +1100
Message-ID: <20140130201921.GN2212@dastard>
References: <20140128064248.GA8653@gmail.com>
 <20140128143514.GB13676@quack.suse.cz>
 <20140129034824.GA12757@gmail.com>
 <A5AD0D66-C4F5-4177-9F87-E3BC59B348B8@dilger.ca>
 <20140130194224.GA22955@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Li Xi <pkuelelixi@gmail.com>, Ben Myers <bpm@sgi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21512 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbaA3UT0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Jan 2014 15:19:26 -0500
Content-Disposition: inline
In-Reply-To: <20140130194224.GA22955@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 30, 2014 at 08:42:24PM +0100, Jan Kara wrote:
> On Thu 30-01-14 11:57:10, Andreas Dilger wrote:
> > On Jan 28, 2014, at 8:48 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > > On Tue, Jan 28, 2014 at 03:35:14PM +0100, Jan Kara wrote:
> > >> On Tue 28-01-14 14:42:49, Zheng Liu wrote:
> > >>> For project quota, the key issue is how to handle link(2)/rename(2).  We
> > >>> summarize the behaviour in xfs as following.
> > >>> 
> > >>> *Note*
> > >>> + unaccounted dir
> > >>> x accounted dir
> > >>> 
> > >>> link(2)
> > >>> -------
> > >>> 		+		x
> > >>> +		ok		error (EXDEV)
> > >>> x		ok		error (EXDEV)
> > 
> > Presumably this accounted-to-accounted link() is only an error if
> > it is between directories of two different projects?
>   Yes, I understand it that way.

Correct. You can have multiple hardlinks within a project, just not
across projects.

> > >>> rename(2)
> > >>> ---------
> > >>> 		+		x
> > >>> +		ok		ok
> > >>> x		wrong		ok
> > >> 
> > >>  So moving unaccounted file/dir into an accounted dir would be OK? How is
> > >> that?
> > > 
> > > Actually xfs will return EXDEV error when we try to move unaccounted
> > > file/dir into an accounted dir.  Then userspace tools (e.g. mv(1)) will
> > > use create(2)/read(2)/write(2) syscalls to create these files/dirs from
> > > scratch, and get the same id from their parent.
> > 
> > Why wouldn't renaming an unaccounted file into an accounted directory
> > just be implemented by doing the equivalent of chown() to change the
> > project ID and setting the quota?  That could avoid a HUGE amount of
> > data copying for large files.
>   Well, the trouble is not so much with a file but with a directory. If you
> move an unaccounted directory in an accounted dir, you would have to
> recursively go through it and account each file. That isn't possible to do
> reliably from the kernel... And allowing files but disallowing dirs seems
> inconsistent so I'm in favor of a simple API.

Even files are problematic. Think of a file with multiple hard
links. You can't rename one of those links across to a directory
with a different project quota ID for the same reason you can't
create hard links across different project ID contexts...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
