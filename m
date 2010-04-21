From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Date: Wed, 21 Apr 2010 18:36:05 +0100
Message-ID: <20100421173605.GD27575@shareable.org>
References: <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org> <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu> <20100421095221.GD13114@shareable.org> <E1O4X02-0003UN-IV@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jblunck@suse.de, vaurora@redhat.com, dwmw2@infradead.org,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:57460 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab0DURgY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 13:36:24 -0400
Content-Disposition: inline
In-Reply-To: <E1O4X02-0003UN-IV@pomaz-ex.szeredi.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Miklos Szeredi wrote:
> On Wed, 21 Apr 2010, Jamie Lokier wrote:
> > Sorry, no: That does not work for bind mounts.  Both layers can have
> > the same st_dev.
> 
> Okay.
> 
> >  Nor does O_NOFOLLOW stop traversal in the middle of
> > a path, there is no handy O_NOCROSSMOUNTS, and no st_mode flag or
> > d_type to say it's a bind mount.  Bind mounts are really a big pain
> > for i_nlink+inotify name counting.
> 
> I'm confused.  You are monitoring a specific file and would like to
> know if something is happening to any of it's links, right?

Not quite. I'm monitoring a million files (say), so I must use
directory watches for most of them.  I need directory watches anyway,
when the semantic is "calling open on /path/to/file and reading would
return the same data", because renames and unlinks are also a way to
invalidate monitored file contents.

At a high level, what we're talking about is the ability to cache and
verify the the validity information derived from reading files in the
filesystem, in a manner which efficiently triggers invalidation only
on changes.  Being able to answer, as quickly as possible, "if I read
this, that and other, will I get the same results as the last time I
did those operations, without having to actually do them to check".
There are many applications, provided the method is reliable.

> Why do you need to know about bind mounts for that?
> 
> Count the number of times you encounter that d_ino and if that matches
> i_nlink then every directory is monitored.  Simple as that, no?

When I see a file has i_nlink > 1, I must watch the file directly
using a file-watch (with inotify; polling with stat() with dnotify),
_unless_ I have seen all the links to that file.

When I've seen all the links to a file, I know that my directory
watches on the directories containing those links are sufficient to
detect changes to the file contents.  That's because every
file change will get notified on at least one of those paths.

I learn that I've seen all the links by seeing d_ino during readdir as
you suggested, or by st_ino in the cases where I've not had reason to
readdir and I have needed to open the file or call stat.

Let's look at some bind mounts.  One where st_ino doesn't work:

    /dirA/file1  [hard link to inode 100, i_nlink = 2]
    /dirA/bound  [bind mount, has /dirA/file1 mounted on it]
    /dirB/file2  [hard link to inode 100, i_nlink = 2]

If the program is asked to open /dirA/file1 and /dirA/bound at various
times, and never asked to readdir /dirA, it will have used fstat not
readdir, seen the same (st_dev,st_ino,i_nlink = 2), and _wrongly_
concluded that it is monitoring all directories containing paths to
the file.

To avoid that problem, it parses /proc/mounts and detects that
/dirA/bound does not contributed to the link count.  This is faster
than calling readdir in all possible places that it can happen.

Another one, where readdir + d_ino doesn't work anyway:

    /dirA/file1  [hard link to inode 100, i_nlink = 2]
    /dirB/dirX   [bind mount, has /dirA mounted on it]
    /dirC/file2  [hard link to inode 100, i_nlink = 2]

This time the program is asked to open /dirA/file1 and
/dirB/dirX/file1 at various times.  Suppose it aggressively calls
readdir on all of the places it goes near, and uses d_ino comparisons.

Bear in mind it can't hunt for /dirC because there may be millions of
directories; this is just an example.

Then it will see the same d_ino for /dirA/file1 and /dirB/dirX/file1,
and wrongly conclude that it is monitoring all directories containing
paths to the file.

So again, it must parse /proc/mounts to detect that everything found
under /dirB/dirX mirrors /dirA.

This is a bit more complicated by the fact that inotify/dnotify send
events to the watching dentry parent of the link used to access a
file, not necessarily the parent in the mounted path space.

Although this doesn't make the bind mount problem go away, this is
where union mounts complicate the picture more:

Ideally, the program may assume that d_ino and st_ino match as long as
the file is open (on any filesystem), or that the filesystem type is
in a whitelist of ones with stable inode numbers (most local
filesystems), and it's not a mountpoint.  So when it's asked to open
at one path, and something else asks it to readdir at another path, it
could combine the information to learn when it's found all entries,
without having to use redundant readdirs and stats.

I'm thinking that I might have to detect union mounts specially in
/proc/mounts, now that they are a VFS feature, and disable a bunch of
assumptions about d_ino when seeing them.  Hopefully it is possible to
unambiguously check for union mount points in /proc/mounts?

d_ino == directory's st_ino sounds neat.  Maybe that will be enough,
as a special magical Linux rule.  When reading a directory, it's cheap
to get the directory's st_ino with fstat().  It's possible to bind
mount a directory on it's _own_ child, so that st_ino == directory's
st_ino, but d_ino isn't affected so maybe that's the trick to use.

-- Jamie
