From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs alignment issues
Date: Wed, 11 Jul 2012 20:05:03 -0400
Message-ID: <20120712000503.GC5838@thunk.org>
References: <4FFD7D9B.2080503@bobich.net>
 <4FFD9613.3050305@redhat.com>
 <20120711200557.GB5838@thunk.org>
 <4FFDEEA5.1020401@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38587 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2GLAFK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 20:05:10 -0400
Content-Disposition: inline
In-Reply-To: <4FFDEEA5.1020401@bobich.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 10:22:45PM +0100, Gordan Bobic wrote:
> >I will observe that being able to derefrence unaligned pointers is
> >something that Linus has said any architecture which does *not*
> >provide fixups is probably doomed to fail.
> 
> That sounds like a resigned recognition that a lot of developers
> will use unsafe practices anyway, not a model for how things should
> be done.

The reality is there is a lot of userspace code which does things a
certain way.  Ignoring that reality will very often doom you to
irrelvance.  (For example, Plan9 and Mach assumed that the existing
huge amount of Posix-compatible userspace code wasn't important, and
people would implement new applications to their new OS interfaces
from scratch.)

> >Yes, someone can send me patches.  :-)
> 
> Sure, I can sed __attribute__((aligned(4))) on every char[]
> definition, as long as no art rather than engineering oriented
> individuals aren;t going to complain that it "looks ugly". :)

Um, no.  NAK.

#1, it's not going to be necessary in all cases, and #2, we try very
hard in e2fsprogs to make sure we are not dependent on GCC extensions.
If you must use a GCC extension, it must be under an #ifdef __GNUC__
and there must be a reasonable alternative if it's compiled using (for
example) the Solaris icc....

Weren't you the one ranting on and on about how portability was so
important?

> >>  I think Gordan suggested (if I understand it
> >>right) that doing an array of ints might also solve the problem, since
> >>ints should be on natural alignment.  Or maybe in some cases malloc/free
> >>would be more obvious, if handling errors isn't too tricky.
> >
> >In the specific case which Gordon has pointed out, the obvious thing
> >to do is to just to set errno to ENOMEM, and return -1. since we
> >already reflect an error code up to the caller if the FIEMAP ioctl()
> >fails.
> >
> >If someone sends me the patch, I will happily apply it.
> 
> As opposed to aligning the char arrays explicitly?

The right thing in the case of the filefrag example which you gave is
to allocate the structure dynamically using malloc().

In other cases there may be other solutions which may be a better way
to do things.  Please do *not* bother to do a global sed style patch.
I will reject that summarily.  Thought and care are required, not a
blunt instrument.

> >What we are currently doing may not be 100% portable, but we're not
> >going to penalize sane archiectures like x86 just because there might
> >be some future insane architecture that requires 32-byte aligned ints!
> >All the ranting in the world about how this could hypothetically cause
> >file system corruption on said insane architecture will just cause me
> >to laugh at you.
> 
> By that definition, the majority of architectures supported by Linux
> are insane. Word alignment requirements apply to ARM, and IIRC to
> Itanium and SPARC (not sure about the most recent SPARCs) too. If
> you think that Linux should become x86-only, that's fair enough, I'm
> sure the ARM kernel maintainers are getting sufficiently frustrated
> with the current situation that they might think this is a positive
> development. But meanwhile, back in the real world, we do need to
> deal with the issue.

You're not reading what I wrote.  There are plenty of places where we
read in an on-disk structure into a malloc'ed buffer, where all of the
fields of that structure which have 4-byte alignment for 32-bit
fields, and 2-byte alignment for 16-bit fields.  We dereference those
fields directly, without doing a manual copy operation.  Strictly
speaking, this may not be portable, since there may be architectures
that do something insane with greater than 8 byte alignment
requirements for 4-byte types.

We (both e2fsprogs and the Linux kernel) also assume that the bit
pattern field for NULL is 0x00.  Strictly speaking the C standard does
not require this; it only requires that if you cast an integer value
of 0, the result must be the NULL pointer.  For example, on the
Honeywell GE-645, a NULL pointer was (segment -2, offset 0).

Architectures which have odd alignments or wierd bit patterns for NULL
pointers are what I am calling "insane".  And I don't care about
complete generic portability to weird architectures.  So please don't
try to make arguments about portability as a platonic ideal that we
must adhere to at all costs.  If we did that, we would have to
manually copy each field from the on-disk structure to an in-memory
structure, and that would be insanely slow.  Can you imagine doing
that in the TCP stack?!?

I am willing to support the ARM architecture, but we need to do this
in a careful way; not via some quick and dirty sed script.  But please
note that other architectures, including the Alpha, have always
supported doing unaligned pointer fixups (even if it is slow), because
if they didn't vast amounts of userspace *would* break.

Regards,

						- Ted
