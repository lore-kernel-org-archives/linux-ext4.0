From: tytso@mit.edu
Subject: Re: [PATCH 2/2] ext4: Use slab allocator for sub-page sized
 allocations
Date: Wed, 2 Dec 2009 15:12:34 -0500
Message-ID: <20091202201234.GG6278@thunk.org>
References: <1259716451-26901-1-git-send-email-tytso@mit.edu>
 <1259716451-26901-2-git-send-email-tytso@mit.edu>
 <4B169B86.4040707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60844 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbZLBUMa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2009 15:12:30 -0500
Content-Disposition: inline
In-Reply-To: <4B169B86.4040707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 02, 2009 at 10:53:26AM -0600, Eric Sandeen wrote:
> 
> So, this undoes commit c089d490dfbf53bc0893dc9ef57cf3ee6448314d
> more or less, right:
> 
> JBD: Replace slab allocations with page allocations

Close, but not quite.  We still use getfreepage() in the case where
blocksize==pagesize.  So in the most common case of 4k blocks on
x86/x86_64, we won't be sufferring the overhead of using the
SLAB/SLUB/SLOB/SLQB machinery.

> Was alignment the only reason that commit went in?

Alignment and if debugging was enabled, it meant that you needed two
contiguous pages for every 4k shadow buffer_head used by the JBD
layer, not to mention the overhead of tracking each page in the slab
cache.

> Also, there is a race issue here I think, that we've had bugs
> on internally, but w/ the above commit it didn't matter anymore:
> 
> If you simultaneously mount several jbd(2)-based filesystems
> at once, before the slabs get created, nothing protects jbd2_slab[]
> and we can race on creation/initialization of that array.
> 
> See a proposed patch:
> 
> https://bugzilla.lustre.org/attachment.cgi?id=22906
> 
> but I think that patch is a little heavy-handed, the down_reads
> of the slab lock seem to be extraneous because if the fs is mounted,
> nobody will be tearing down that slab anyway, since that only
> happens on module unload, right?

Yeah, we only need the lock at mount time, when we are filling in the
jbd_slab[] array.  Thanks for pointing that out; I'll fix it and
resend the patch.

					- Ted
