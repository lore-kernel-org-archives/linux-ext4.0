From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: Check for cases where EOFBLOCKS_FL is
 unnecessarily set
Date: Tue, 11 May 2010 21:44:03 -0400
Message-ID: <20100512014403.GZ18762@thunk.org>
References: <1273609878-22746-1-git-send-email-tytso@mit.edu>
 <4BE9D4F3.9080003@redhat.com>
 <20100512004452.GY18762@thunk.org>
 <4BE9FFEE.9030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35272 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0ELBoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 21:44:05 -0400
Content-Disposition: inline
In-Reply-To: <4BE9FFEE.9030102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 11, 2010 at 08:10:06PM -0500, Eric Sandeen wrote:
> tytso@mit.edu wrote:
> > On Tue, May 11, 2010 at 05:06:43PM -0500, Eric Sandeen wrote:
> >> Theodore Ts'o wrote:
> >>> Some kernels will crash if EOFBLOCKS_FL is set when it is it not
> >> Is there a kernel fix to go with this, then?
> > 
> > There will be; Dmitry sent a patch in the ext4 patch a while back.
> > 
> > http://patchwork.ozlabs.org/patch/50469/
> > 
> > The fix to prevent the crash is tiny.  The rest of the patch I need to
> > review more carefully....  I'll get to it RSN.
> 
> Ok sorry, I didn't put 2 & 2 together, there.  :)
> 
> Thanks for the reminder,

To be clear, the fix to prevent the crash is:

		EXT4_ERROR_INODE(inode,
	     			"eh->eh_entries == 0 ee_block %d",
 				ex->ee_block);

to:

		EXT4_ERROR_INODE(inode,
				"eh->eh_entries == 0, iblock = %u"
				iblock);

(this is the quick fix that we dropped into our production kernels,
anyway; the problem is that ex is NULL, which means instead of marking
the file system as needing repair, we Oops the system instead.)

I just haven't had the time to analyze the rest of the patch yet.

One of the things I've been considering is whether we should be trying
to test for this failure at all.  Is there a downside if EOFBLOCKS_FL
is set when it shouldn't matter?  Should we simply not try to check
for the case?  Or if we do check, should we just clear the flag and
print a warning?  The other side of the argument is if this is wrong,
then either we have a kernel bug (see the first patch) or we had a
hardware error, in which case something else might be wrong and maybe
we should force a file system check.

						- Ted
