From: Ryan Lortie <desrt@desrt.ca>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 11:24:45 -0400
Message-ID: <1371828285.23425.140661246894093.6DC945E0@webmail.messagingengine.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <20130621143347.GF10730@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40578 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422893Ab3FUPYq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 11:24:46 -0400
In-Reply-To: <20130621143347.GF10730@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

On Fri, Jun 21, 2013, at 10:33, Theodore Ts'o wrote:
> Based on how the implementation is currently implemented, any modified
> blocks belonging to the inode will be staged out to disk --- Although
> with out an explicit CACHE FLUSH command, which is ***extremely***
> expensive.

Okay -- so any modified blocks, not just unallocated ones, therefore
fallocate() doesn't affect us here.... Good.

So why are we seeing the problem happen so often?  Do you really think
this is related to a bug that was introduced in the block layer in 3.0
and that once that bug is fixed replace-by-rename without fsync() will
become "relatively" safe again?

> Why are you using fallocate, by the way?  For small files, fallocate
> is largely pointless.  All of the modern file systems which use
> delayed allocation can do the right thing without fallocate(2).  It
> won't hurt, but it won't help, either.

g_file_set_contents() is a very general purpose API used by dconf but
also many other things.  It is being used to write all kinds of files,
large and small.  I understand how delayed allocation on ext4 is
essentially giving me the same thing automatically for small files that
manage to be written out before the kernel decides to do the allocation
but doing this explicitly will mean that I'm always giving the kernel
the information it needs, up front, to avoid fragmentation to the
greatest extent possible.  I see it as "won't hurt and may help" and
therefore I do it.

I'm happy to remove it on your (justified) advice, but keep in mind that
people are using this API for larger files as well...

> The POSIX API is pretty clear: if you care about data being on disk,
> you have to use fsync().

Well, in fairness, it's not even clear on this point.  POSIX doesn't
really talk about any sort of guarantees across system crashes at all...
and I can easily imagine that fsync() still doesn't get me what I want
in some really bizarre cases (like an ecryptfs over NFS from a virtual
server using an lvm setup running inside of kvm on a machine with hard
dives that have buggy firmware).

I guess I'm trying to solve for the case of "normal ext4 on a normal
partition on real metal with properly working hardware".  Subject to
those constraints, I'm happy to call fsync().

> As file system designers, we're generally rather hesitant to make
> guarantees beyond that, since most users are hypersensitive about
> performance, and every single time we make additional guarantees
> beyond what is specified by POSIX, it further constrains us, and it
> may be that one of these guarantees is one you don't care about, but
> will impact your performance.  Just as the cost of some guarantee you
> *do* care about may impact the performance of some other application
> which happens to be renaming files but who doesn't necessarily care
> about making sure things are forced to disk atomically in that
> particular instance.

That's fair... and I do realise the pain in the ass that it is if I call
fsync() on a filesystem that has an ordered metadata guarantee.  I'm
asking you to immediately write out my metadata changes that came after
other metadata, so you have to write all of it out first.

This is part of why I'd rather avoid the fsync entirely...

aside: what's your opinion on fdatasync()?  Seems like it wouldn't be
good enough for my usecase because I'm changing the size of the file....

another aside: why do you make global guarantees about metadata changes
being well-ordered?  It seems quite likely that what's going on on one
part of the disk by one user is totally unrelated to what's going on on
another other part by a different user... ((and I do appreciate the
irony that I am committing by complaining about "other guarantees that I
don't care about")).

> There are all sorts of rather tricky impliciations with this.  For
> example, consider what happens if some disk editor does this with a
> small text file.  OK, fine.  Future reads of this text file will get
> the new contents, but if the system crashes, when the file read, they
> will get the old value.  Now suppose other files are created based on
> that text file.  For example, suppose the text file is a C source
> file, and the compiler writes out an object file based on the source
> file --- and then the system crashes.  What guarantees do we have to
> give about the state of the object file after the crash?  What if the
> object file contains the compiled version of the "new" source file,
> but that source file hsa reverted to its original value.  Can you
> imagine how badly make would get confused with such a thing?

Ya... I can see this.  I don't think it's important for normal users,
but this is an argument that goes to the heart of "what is a normal
user" and is honestly not a useful discussion to have here...

I guess in fact this answers my previous question about "why do you care
about metadata changes being well ordered?"  The answer is "make".

In any case, I don't expect that you'd change your existing guarantees
about the filesystem.  I'm suggesting that using this new 'replace file
with contents' API, however, would indicate that I am only interested in
this one thing happening, and I don't care how it relates to anything
else.

If we wanted a way to express that one file's contents should only be
replaced after another file's contents (which might be useful, but
doesn't concern me) then the API could be made more advanced...

> Beyond the semantic difficulties of such an interface, while I can
> technically think of ways that this might be workable for small files,
> the problem with the file system API is that it's highly generalized,
> and while you might promise than you'd only use it for files less than
> 64k, say, inevitably someone would try to use the exact same interface
> with a multi-megabyte file.  And then complain when it didn't work,
> didn't fulfill the guarantees, or OOM-killed their process, or trashed
> their performance of their entire system....

I know essentially nothing about the block layer or filesystems, but I
don't understand why it shouldn't work for files larger than 64k.  I
would expect this to be reasonably implementable for files up to a
non-trivial fraction of the available memory in the system (say 20%). 
The user has successfully allocated a buffer of this size already, after
all...  I would certainly not expect anything in the range of
"multi-megabyte" (or even up to 10s or 100s of megabytes) to be a
problem at all on a system with 4 to 8GB of RAM.

If memory pressure really became a big problem you would have two easy
outs before reaching for the OOM stick: force the cached data out to
disk in real time, or return ENOMEM from this new API (instructing
userspace to go about more traditional means of getting their data on
disk).


There are a few different threads in this discussion and I think we've
gotten away from the original point of my email (which wasn't addressed
in your most recent reply): I think you need to update the ext4
documentation to more clearly state that if you care about your data,
you really must call fsync().

Thanks
