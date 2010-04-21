From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Wed, 21 Apr 2010 17:34:36 -0400
Message-ID: <20100421213436.GD5041@shell>
References: <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org> <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu> <20100421095221.GD13114@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, jblunck@suse.de,
	dwmw2@infradead.org, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0DUVe5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 17:34:57 -0400
Content-Disposition: inline
In-Reply-To: <20100421095221.GD13114@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 21, 2010 at 10:52:21AM +0100, Jamie Lokier wrote:
> Miklos Szeredi wrote:
> > Detecting mount points is best done by comparing st_dev for the parent
> > directory with st_dev of the child.  This is much simpler than parsing
> > /proc/mounts and will work for bind mounts as well as union mounts.
> 
> Sorry, no: That does not work for bind mounts.  Both layers can have
> the same st_dev.  Nor does O_NOFOLLOW stop traversal in the middle of
> a path, there is no handy O_NOCROSSMOUNTS, and no st_mode flag or
> d_type to say it's a bind mount.  Bind mounts are really a big pain
> for i_nlink+inotify name counting.
> 
> Besides, calling stat() on every entry in a large directory to check
> st_ino can be orders of magnitude slower than readdir() on a large
> directory - especially with a cold cache.  It is quicker, but much
> more complicated, to parse /proc/mounts and apply arcane rules to find
> the exceptions.
> 
> Can a union mount overlap two parts of the same filesystem?

No.  Each layer must be a separate file system, the bottom must be
read-only, the top must be writable, and they must be unioned at their
mount points.

> > I think there's no question that union mounts might break apps (POSIX
> > or not).  But I think there's hope that they are few and can easily be
> > fixed.
> 
> I agree, and union moint is a very useful feature that's worth
> breaking a few apps for :-)
> 
> I'm curious if there's a clear way to go about it in this case, or
> if it'll involve a certain amount of pattern recognition in /proc/mounts.

All it takes is looking for the "union" string in the mount options.

> Basically I'm wondering if it's been thought about already.

Not as much as it deserves. :) Do you have any thoughts about better
solutions?

Something to keep in mind is that most of the app issues are already
present with bind mounts.  In many cases, if an app doesn't work with
union mounts, it's also not going to work with bind mounts.  I think
you have a good point that we could use a more straightforward way to
say, "Hey, you can't use the normal st_dev/st_ino rules right now..."

-VAL
