From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs alignment issues
Date: Wed, 11 Jul 2012 16:05:57 -0400
Message-ID: <20120711200557.GB5838@thunk.org>
References: <4FFD7D9B.2080503@bobich.net>
 <4FFD9613.3050305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gordan Bobic <gordan@bobich.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38553 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab2GKUGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 16:06:07 -0400
Content-Disposition: inline
In-Reply-To: <4FFD9613.3050305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 10:04:51AM -0500, Eric Sandeen wrote:
> On 7/11/12 8:20 AM, Gordan Bobic wrote:
> > I would like to bring the following bug report to people's
> > attention:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=680090
> > 
> > The issue is that the code used in e2fsprogs WRT allocating unaligned
> > buffers and then casting them into structs is non-portable and
> > dangerous - eyewateringly dangerous in something like e2fsprogs where
> > it can lead to thorough trashing of the file system.

I think you're being a bit over-dramatic here; can you point out a
place where this is actually going to lead to "trashing of the file
system"?

I will observe that being able to derefrence unaligned pointers is
something that Linus has said any architecture which does *not*
provide fixups is probably doomed to fail.  There's an awful lot of
userspace code out there which assumes this works.  Doing a quick
grep, I'm seeing code in the blkid library (which has now been moved
into util-linux) which does this.  I'm also seeing one case of it in
the tdb library (which we imported from Samba).

That being said, doing fixups is slow since it requires a kernel
fault, and I have no problem with trying to avoid this practice.

> > Can something be done to improve the portability of the userspace
> > code?

Yes, someone can send me patches.  :-)

Ranting and raving about how file systems are being trashed will be
met with the observation that no one has actually reported this.  And
this won't be the only place where the Linux kernel code makes
assumptions which are not guaranteed by the C standard, but the
official position that Linus has taken is any architecture (or C
compiler) is insane, and it's up to the architecture to provide
workarounds.

> Many of these are the result of things like:
> 
>         char buf[4096] = "";
>         struct fiemap *fiemap = (struct fiemap *)buf;
> 
> 
> Ted, is this construct just an attempt to avoid malloc/free for
> simplicity of the code?

Probably; it's the way Kalpak Shaw wrote the code when he submitted
it.  And while I do have higher standards of portability that the
Linux kernel, this is not one of the things that I test for.

Please do note that malloc() is guaranteed to return a block of memory
which satisifies the worse case alignment requirements of the
architecture, so there are plenty of places where we cast a buffer
pointer to an int * or a struct * which are completely safe.  It's
only when someone is allocating space on the stack where this is
potentially problematic.

>  I think Gordan suggested (if I understand it
> right) that doing an array of ints might also solve the problem, since
> ints should be on natural alignment.  Or maybe in some cases malloc/free
> would be more obvious, if handling errors isn't too tricky.

In the specific case which Gordon has pointed out, the obvious thing
to do is to just to set errno to ENOMEM, and return -1. since we
already reflect an error code up to the caller if the FIEMAP ioctl()
fails.

If someone sends me the patch, I will happily apply it.

> (IIRC "make gcc-wall" will also emit warnings for casts which change
> natural alignment, among other things)

I'd have to check to be sure, but I don't think so, since it would
have way too many false positives.  We *do* have code where we take
char *'s and and then cast them to some other pointer type, and then
dereference them.  And we do currently assume that it is safe to do
this for on-disk data structures which are 4 byte aligned, in the
directory entry code, for example.

I will *not* accept a patch which uses memcpy to copy each field in
the on-disk superblock, or directory entry, into an int, just in case
there is some insane architecture which requires that 4 byte integers
be 32-byte aligned, or something else insane like that.

What we are currently doing may not be 100% portable, but we're not
going to penalize sane archiectures like x86 just because there might
be some future insane architecture that requires 32-byte aligned ints!
All the ranting in the world about how this could hypothetically cause
file system corruption on said insane architecture will just cause me
to laugh at you.

But that being said, changing places where we allocate a char []
buffer on the stack and assuming that it is 4-byte aligned does seem
reasonable.  But I see this as an optimization issue more than I do a
performance issue....

Regards,

						- Ted
