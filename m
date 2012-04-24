From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Tue, 24 Apr 2012 20:33:20 +0100
Message-ID: <20120424193320.GC21904@jl-vm1.vm.bytemark.co.uk>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:48874 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2DXUKc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Apr 2012 16:10:32 -0400
Content-Disposition: inline
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> As I had brought up during one of the lightning talks at the Linux
> Storage and Filesystem workshop, I am interested in introducing two new
> open flags, O_HOT and O_COLD.  These flags are passed down to the
> individual file system's inode operations' create function, and the file
> system can use these flags as a hint regarding whether the file is
> likely to be accessed frequently or not.
> 
> In the future I plan to do further work on how ext4 would use these
> flags, but I want to first get the ability to pass these flags plumbed
> into the VFS layer and the code points for O_HOT and O_COLD reserved.

As a developer of userspsace libraries and applications, I can't tell
when it would be a good idea to use these flags.

I get the impression that the best time to use them is probably
dependent on system-specific details, including the type of
filesystem, underlying storage, and intermediate device-mapper layers,
geometry, file sizes, etc.

I.e. ugly, tweaky stuff where the right answer depends on lots of
system-specific benchmarks.

Things which I can't really test except on the few systems I have
access to myself, so I can only guess how to use the flags for general
purpose code on other peoples' systems.

Suppose I'm writing a database layer (e.g. a MySQL backend).

Is there any reason I should not indiscriminately use O_HOT for all
the database's files?  If only to compete on the benchmarks that are
used to compare my database layer against others?

If I use O_HOT for frequently-accessed data, and O_COLD for
infrequently accessed (such as old logs), so that my application can
signal a differential and reap some benefit - what about the concerns
that it will be worse than using no flags at all, due to the seek time
from using different areas of the underlying storage?

Or if signalling a differential works well, will we end up needing a
"hot-cold cgroup" so each application's hot/cold requests indicate a
differential within the app only, allowing the administrator to say
which _whole apps_ are prioritised in this way?

In a nutshell, I can't figure out, as a userspace programmer, when I
should use these flags, and would be inclined to set O_HOT for all
files that have anything to do with something that'll be benchmarked,
or anything to do with a "job" that I want to run at higher priority
than other jobs.

I have queries about the API too.  I'd anticipate sometimes having to
use an LD_PRELOAD to set the flag for all opens done by a bunch of
programs run from a script.  So why not the ionice/ioprio_{get/set}
interface?  That was rhetorical: So that a program can set different
hot/coldness for different files, or the same files at different
times.

But there's a case for sometimes wanting other types of I/O priority
to vary for different open files in the same process too.  What's
special about O_HOT/O_COLD that makes it different from other kinds of
I/O priority settings?  Wouldn't it be better to devise a way to set
all I/O priority-like things per open file, not just hot/cold?

Sometimes I'd probably want to set O_HOT as a filesystem attribute on
a set of files in the filesystem (such as a subset of files in the
http/ directory), so that all programs opening those files get O_HOT
behaviour.  Mainly when it's scripts operating on the files, but also
to make sure any "outside the app" operations on the files (such as
stopping the app, copying its files elsewhere, and starting it at the
new location) don't lose the hot/coldness.

For database-like things, I'd want to set hot/cold on different
regions within a big file, rather than separate files.  Perhaps the
same applies to ELF files: The big debugging sections would be better cold.

If I've written a file with O_COLD and later change my mind, do I have
to open the file with O_HOT and rewrite all of the file with the same
contents to get it moved on the storage?  Or does O_HOT do that
automatically?

Is there any way I can query whether it's allocated hot/cold already,
or will I have to copy the data "just in case" from time to time?  For
example, if a system was restored from backups (normal file backups),
presumably the hottest files will have been restored "normal", whereas
they would have been written initially with O_HOT by the application
producing them.

If the allocated hot/coldness isn't something the application can
query from the filesystem, it won't know whether to inform the user
that performance could be improved by running a tool which converts
the file to an O_HOT-file.

Also, for the backup itself, or when copying files around a system
with normal tools (cp, rsync), or to another system, if there's no way
to query allocated hot/coldness, they won't be able to preserve that.

If there's a real performance difference, and no way to query whether
the file was previously allocated hot/cold, maybe some applications
will recommend "users should run this special tool every month or so
which copies all the data with O_HOT, as it sometimes improves
performance".  Which will be true.  You know what optimisation
folklore is like.

All the best,
-- Jamie
