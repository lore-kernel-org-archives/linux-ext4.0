From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: Wed, 14 Nov 2012 15:39:42 -0500
Message-ID: <20121114203942.GA23511@thunk.org>
References: <20121114054347.GA20380@thunk.org>
 <20121114072021.28351.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32883 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423338Ab2KNUjq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2012 15:39:46 -0500
Content-Disposition: inline
In-Reply-To: <20121114072021.28351.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 14, 2012 at 02:20:21AM -0500, George Spelvin wrote:
> 
> If you don't mind, *my* primary question is "what can I salvage from this
> rubble?", since I didn't happen to have 8 TB of backup space available
> to me when I did the resize, and there's soem stuff on the FS I'd
> rather not lose...

Sigh...  ok, unfortunately that's not something I can answer right
away.  I *can* tell you what happened, though.  Figuring out the best
way to help you recover while minimizing data loss is going to require
more thought....

First of all, the support for 64-bit online-resizing didn't hit the
3.6 kernel, and since it's a new feature, it's unlikely the stable
kernel gatekeepers will accept it unless and until at leastr one
distribution who is using a stable kernel is willing to backport the
patches to their distro kernel.  So in order to use it, you'll need a
3.7-rc1 or newer kernel.  That explains why the on-line resizing
didn't work.

The reason why you lost so badly when you did an off-line resize was
because you explicitly changed the resize limit default, via the -E
resize=NNN option.  (Can you explain to me your thinking about why you
specified this, just out of curiosity?)  Normally the default is 1000
times the size of the original file system, or for a file system
larger than 1.6TB, enough so that the file system can be resized to
the maximum amount that can be supported via the resize_inode scheme,
which is 16TB.  In practice, for pretty much any large file system,
including pretty much any raid arrays, the default allows us to do
resizes without needing to move any inode table blocks.

So the way things would have worked with a default file system is that
resize2fs would (in off-line mode) resize the file system up to the
maximum 16TB, and then stop.  Using online resizing, a sufficiently
new enough kernel would use the resize_inode up to the number of
reserved gdt blocks (which would by default take you to the 16TB
limit) and then switch over to the meta_bg scheme for doing on-line
resizing, which has no limits.

Unfortunately resize2fs in off-line resizing mode, (a) does not yet
know how to use the meta_bg scheme for resizing, and (b) doesn't deal
well with the case where you (1) have multiple inode tables in the
same block group, as is the case when flex_bg is enabled, as it is
with ext4 file systems, and (2) when it needs to move inode tables.
We protect against this by disallowing growing filesystems using
off-line resizing in the case where the file system has flex_bg but
does not have the resize_inode feature enabled.  *However*, if the
file system does have a resize_inode, but there is not a sufficient
number of gdt blocks (because of an explicitly specified -E resize=NNN
option to mke2fs), then this case isn't caught, and as a result
resize2fs will corrupt the file system.

Sigh.  Unfortunately, you fell into this corner case, which I failed
to forsee and protect against.

It is relatively easy to fix resize2fs so it detects this case and
handles it appropriately.  What is harder is how to fix a file system
which has been scrambed by resize2fs after the fact.  There will
definitely be some parts of the inode table which will have gotten
overwritten, because resize2fs doesn't handle the flex_bg layout
correctly when moving inode table blocks.  The question is what's the
best way of undoing the damage going forward, and that's going to have
to require some more thought and probably some experimentation and
development work.

If you don't need the information right away, I'd advise you to not
touch the file system, since any attempt to try to fix is likely to
make the problem worse (and will cause me to to have to try to
replicate the attempted fix to see what happened as a result).  I'm
guessing that you've already tried running e2fsck -fy, which aborted
midway through the run?

						- Ted

P.S.  This doesn't exactly replicate what you did, but it's a simple
repro case of the failure which you hit.  The key to triggering the
failure is the specification of the -E resize=NNN option.  If you
remove this, resize2fs will not corrupt the file system:

# lvcreate -L 32g -n bigscratch /dev/closure
# mke2fs -t ext4 -E resize=12582912 /dev/closure/bigscratch
# lvresize -L 64g /dev/closure/bigscratch
# e2fsck -f /dev/closure/bigscratch
# resize2fs -p /dev/closure/bigscratch
# e2fsck -fy /dev/closure/bigscratch

