From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check incompatible mount options when mounting
 ext2/3
Date: Thu, 8 Nov 2012 12:02:02 -0500
Message-ID: <20121108170202.GB19977@thunk.org>
References: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60106 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757179Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <1351798331-14456-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 01, 2012 at 05:32:11PM -0200, Carlos Maiolino wrote:
> 
> I have not added all mount options I believe need to raise a
> warning, just those with a flag set on superblock, but I expect to
> generate a discussion here about which mount options should be
> warned and get suggestions about how to deal with argumented options
> (ex: commit= opt), to be included in a V2 of this patch.

Let's take a step back, and see if we can be explicit about why it
would be useful to warn when a user uses mount options that we were
not present with the implementation of the file system drivers found
in fs/ext2 and fs/ext3.  While we're at it, we can also examine the
same question with respect to file system features --- i.e., if
someone mounts a file system with an extent feature enabled using
mount -t ext2, what if anything should we do.  What are we trying to
achieve, or conversely what are we trying to prevent?

Suppose the user does something like this:

   mount -t ext3 -o delalloc /dev/sdb /u1

Yes, the traditional ext3 driver code doesn't understand the delalloc
mount option, but what's the concern that is leading us to want to
print a warning message to the log (that the user may or may not even
see).  Are we worried that what should happen is not sufficiently
well-defined?  Are we worried that while it might work with a
particular kernel which is compiled a certain way, it might not work
with another kernel?  Is it part of the larger question of wanting to
warn if the user is using a set of not-well-tested combination of
mount options and/or file system features?

If it is the latter, what is the right approach?  At Barcelona, I was
chatting with Ric Wheeler and Ralf Flaxa, and they had differing
opinions about what the right thing to do for features which are not
supported.  Ralf felt that warning in the syslog might be sufficient.
I sugested setting a new kernel taint flag, to make it easier for the
supper desk to twig to the fact that the user was doing something
unusual.  Ric offerred his opinion that it was better to hard-fail the
mount.  And of course, this is with distro kernels; for the upstream
kernel, I think our goal is to (a) warn the user that they are doing
something unusual, and (b) ask them to tell us (at linux-ext4) what
they are doing and why, so we have a better understanding of what
users want, so we can either add it to our test matrix, or perhaps
warn the user off.

So not only do we need to decide which mount options and file system
features we want to support, or warn against etc., it's also useful to
think about what we want to do when the user does something a little
out of the norm.

And since I very much doubt that upstream, Red Hat, SuSE, Canonical,
etc., will ever agree on the right thing is, this is probably one of
those things where we want to have a scheme where it is relatively
easy for distributors to set their own policy, which may differ for a
community versus enterprise distro kernel.

But in order to make sure we don't end up talking past each other, I
think it's useful to be very explicit about why we want to do this,
before we try to figure what's and the how's.

       	      	 	       	       - Ted
