From: Theodore Tso <tytso@mit.edu>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Wed, 24 Jun 2009 20:05:58 -0400
Message-ID: <20090625000558.GD7035@mit.edu>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com> <20090621004919.GA6798@mit.edu> <4A42513C.6020607@redhat.com> <4A4256A6.7070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZFYAGK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 20:06:10 -0400
Content-Disposition: inline
In-Reply-To: <4A4256A6.7070707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 24, 2009 at 11:39:02AM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Theodore Tso wrote:
> 
> >> I can see some things we can do to optimize stack usage; for example,
> >> struct ext4_allocation_request is allocated on the stack, and the
> >> structure was laid out without any regard to space wastage caused by
> >> alignment requirements.  That won't help on x86 at all, but it will
> >> help substantially on x86_64 (since x86_64 requires that 8 byte
> >> variables must be 8-byte aligned, where as x86_64 only requires 4 byte
> >> alignment, even for unsigned long long's).  But it's going have to be
> >> a whole series of incremental improvements; I don't see any magic
> >> bullet solution to our stack usage.
> > 
> > XFS forces gcc to not inline any static function; it's extreme, but
> > maybe it'd help here too.
> 
> Giving a blanket noinline treatment to mballoc.c yields some significant
> stack savings:

So stupid question.  I can see how using noinline reduces the static
stack savings, but does it actually reduce the run-time stack usage?
After all, if function ext4_mb_foo() call ext4_mb_bar(), using
noinline is a great way for seeing which function is actually
responsible for chewing up disk space, but if ext4_mb_foo() always
calls ext4_mb_bar(), and ext4_mb_bar() is a static inline only called
once by ext4_mb_foo() unconditionally, won't we ultimately end up
using more disk space (since we also have to save registers and save
the return address on the stack)?

					- Ted
