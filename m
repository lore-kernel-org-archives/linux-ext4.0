From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Tue, 18 Mar 2008 00:23:40 -0400
Message-ID: <20080318042339.GO8368@mit.edu>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu> <47DEE2AE.1050105@redhat.com> <20080318022053.GL8368@mit.edu> <47DF35CC.7020604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49902 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbYCREYX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Mar 2008 00:24:23 -0400
Content-Disposition: inline
In-Reply-To: <47DF35CC.7020604@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 17, 2008 at 10:23:56PM -0500, Eric Sandeen wrote:
> ok... but I think *if* you are going to specify fs type and size, then
> they must be in the 1st and 2nd positions right?  I'm just going by the
> stuff like:

Yes, *if* you want to override the default filesystem type and size
type, then they must be the first and 2nd positions.  Or put another
way, what is specified by -T is:

     -T [fs_type,][size_type,]user_type[,additional_type...]

Where fs_type may be one of "ext2", "ext3", "ext4", or "ext4dev", and
size_type may be one of "floppy", "small", or "default".

> IOW if I do a (silly) -T string like ext3,floppy,largefile I get:
> 
> fs_types: 'ext3', 'floppy', 'largefile'
> 
> but if I do -T floppy,ext3,largefile I get:
> 
> fs_types: 'ext2', 'floppy', 'ext3', 'largefile'
> 
> so in this case I guess I have "ext2" overriding defaults before the
> others, when in the first case I did not?  And depending on how [ext2]
> is defined, this might matter.

That's true, but in practice, I think it's highly unlikely most users
will specify more than a single argument to the -T option.  Most users
will likely to do:

	mke2fs -T news

or

	mke2fs -T ext4

or maybe

	mke2fs -T news

etc.

I want something sane to happen if they type

	mke2fs -T ext4,news

and it should be no different than this:

	/sbin/mkfs.ext4 -T news

But truth be told, it's highly unlikely they would do something more
complicated such as:

	mke2fs -T tpc-h,tweek1,tweek2

...especially since nearly everything can be specified on the command
line anyway.  


> Right, for the named various named stanzas, it does matter in terms of
> what is more specific.  But, I meant "if I want to specify ext3 does it
> have to be first," and I think it does, because otherwise the algorithm
> picks ext2 for me...?

In practice, given that the ext3 filesystem stanza overrides
everything that is set by ext2, given the ordering rule which says
that last type wins, in practice

     mke2fs -T news,ext3

which will expand to "ext2,default,ext3,news" in practice probably
won't be any different than "default,ext3,news", and if there are no
configuration knobs set by both the "default" and "ext3" stanzas, then
"default,ext3,news" will end up being equivalent to
"ext3,default,news".  So in practice I don't expect things to be a
problem.

> > Hmm... good question.  That would be good if someone were to typo a
> > type string.
> 
> I think so.  Otherwise it's silently dropped/ignored which is probably
> not as planned.

The only downside of doing this is if someone overrides
/etc/mke2fs.conf with a custom /home/tytso/.mke2fs.conf by setting the
MKE2FS_CONFIG environment variable, and /home/tytso/.mke2fs.conf
doesn't have all of the system-defined stanzas, you wouldn't want it
to fail.  So probably the right way of resolving this is to flag an
error for a non-existent stanza if it was entered by the user on the
command-line, but not if it was automatically added by e2fsck.

> I mean that we have a few "special" stanza names:
> 
> [ext2], [ext3], [ext4], [ext4dev]
> [floppy], [small], [default]
> 
> which have some special meaning, (types and sizes), and will get filled
> in for you if you don't specify them, right?

Right.  Part of the problem was that previously mke2fs supported a
single argument to -T, and sometimes the argument was a pre-defined
size type ("floppy", "small") and sometimes the argument was a
pre-defined usage type (i.e., "news").  

So I needed to design a system which was backwards compatible with
existing usage, where -T was used to sometimes specify a size, and
sometimes a usage type (but not both), and make it more general.
That's one of the reasons why I designed it the way I did.

> I guess what I'm driving at is this: should the "if state == 1" and "if
> state == 2" tests go away, and just handle each comma-separated type
> completely equally.  I'd thinkg that -T news,largefile,ext4 should work
> - news should override all defaults, largefile should override anything
> thus far, and ext4 should have the final say for anything it specifies;

The problem is that "-T news,largefile,ext4" probably won't do what
the user wants.  In general the filesystem type (ext2, ext3, ext4),
etc., are going to define a set of general parameters, which you then
want to get overriden by the size, and then usage type overrides size
parameters.  So that's why the only order which makes sense is
"fs_type,size_type,usage_type".   

The question then is what to do when the user specifies something
non-sensical, where they put the filesystem type last.  One approach
would be to use a two-pass algorithm, where you first scan the list
for any filesystem type or size types, and if so, you suppress
prefixing the list with the fs_type and size_type.  I think that's
what you are suggesting.

Then there was my approach, which was admittedly partially influenced
by what was quicker and easier to code, which only checked the
expected position.

Yours probably does make a bit more sense, although it's a bit more of
a pain to code.  But either way, it's to deal with a situation that we
really don't want to train the user to use since it will probably
surprise him and not do what he wants.

					- Ted
