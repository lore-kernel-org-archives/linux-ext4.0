From: Theodore Tso <tytso@mit.edu>
Subject: Re: [stable] Stable patches for ext4
Date: Sat, 18 Oct 2008 15:28:56 -0400
Message-ID: <20081018192856.GB8383@mit.edu>
References: <E1KrCdX-0006L5-2q@closure.thunk.org> <20081018170305.GB20305@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, stable@kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41682 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750773AbYJRT3A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Oct 2008 15:29:00 -0400
Content-Disposition: inline
In-Reply-To: <20081018170305.GB20305@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 18, 2008 at 10:03:05AM -0700, Greg KH wrote:
> 
> Heh, you do realize that hundreds of thousands of users are going to be
> using 2.6.27.x "for production" as at least 3 distros are being based
> off of it?
> 
> So, either you send these patches to us if you want to have a sane idea
> of what the distros are using, or you rely on the distros themselves to
> get it right in cherry-picking from upstream here.  I know one distro
> already has done this, and I'm sure others have as well.
> 
> It comes down to who you trust, a random distro engineer, or you and
> your group of engineers :)

Heh**2.  What Fedora 10 at least is going to be doing is grabbing the
equivalent of ext4-stable.  If it were completely up to me, and Eric
Sandeen from Red Hat has made the same wish (although I suspectly
somewhat in jest) on #ext4, it would be great if we could pour all of
ext4-stable (i.e., what we got added into the malinline during the
2.6.28 merge window) into 2.6.27.x.  That would be easier for me to
support as well.  Only problem is that it rather blatently violates
the criteria as set forth in Documentation/stable_kernel_rules.txt.
(i.e., there are factor-of-five performance enhacements, code
cleanups, ext4dev gets renamed to ext4, etc.)

Regardless what goes into 2.6.27.x, I'll probably have to maintain a
patchset of everything else "left over" for those distributions that
want to be aggressive about letting users starting to play with ext4.  

> If you feel the second tree is something that you can support, and you
> feel is necessary for users if they want to use ext4 on this kernel
> release, I'd be glad to review them for inclusion.

If distribution users are going to use ext4 for real, then ENOSPC
issues are a real problem, and they should be solved.  But there are a
large number of patches involved here, and many of them go over 100
lines (although granted the wc -l listed below includes the commit
comments):

  161 /tmp/p/0015-ext4-invalidate-pages-if-delalloc-block-allocation.patch
  211 /tmp/p/0016-ext4-Make-sure-all-the-block-allocation-paths-reser.patch
  123 /tmp/p/0017-ext4-Retry-block-reservation.patch
  307 /tmp/p/0018-ext4-Add-percpu-dirty-block-accounting.patch
  113 /tmp/p/0019-ext4-Switch-to-non-delalloc-mode-when-we-are-low-on.patch
   93 /tmp/p/0020-ext4-Signed-arithmetic-fix.patch
   64 /tmp/p/0021-ext4-Fix-ext4-nomballoc-allocator-for-ENOSPC.patch
   86 /tmp/p/0022-ext4-Don-t-add-the-inode-to-journal-handle-until-af.patch
  190 /tmp/p/0023-ext4-Retry-block-allocation-if-we-have-free-blocks.patch
   50 /tmp/p/0024-ext4-truncate-block-allocated-on-a-failed-ext4_writ.patch
  169 /tmp/p/0025-ext4-Properly-update-i_disksize.patch

I am very confident about these patches, since they hit the ext4 tree
sometime in 2.6.27-rc2 or -rc3, so they've gotten quite a bit of
testing.  I just put them at the end of the for-stable-enospc branch
because they do technically violate the -stable rules.

So it's ultimately to you and Chris.  I'm happy to support any one of
for-stable, for-stable-enospc, or ext4-stable in 2.6.27.x.  The last
is less work for me since I won't have to create "this-is-in-mainline-
please-consider-this-for-your-distro" patch sets.  The real question
is what you're willing to review, and whether other -stable reviewers
will end up complaining and sending NACK's because they violate the
-stable rules.  (To be fair, if some other subsystem did this and I
saw such patches, with my stable reviewer hat on I'd at least send up
a red flag.)

							- Ted
