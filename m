From: tytso@mit.edu
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Wed, 9 Dec 2009 09:32:19 -0500
Message-ID: <20091209143219.GF27692@thunk.org>
References: <1256647729-29834-1-git-send-email-jack@suse.cz>
 <1256647729-29834-5-git-send-email-jack@suse.cz>
 <20091116004641.GM4323@mit.edu>
 <20091116104331.GB23231@duck.suse.cz>
 <20091209035120.GA27692@thunk.org>
 <20091209045424.GB27692@thunk.org>
 <20091209112940.GF4863@quack.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZLIOcS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 09:32:18 -0500
Content-Disposition: inline
In-Reply-To: <20091209112940.GF4863@quack.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 09, 2009 at 12:29:40PM +0100, Jan Kara wrote:
> On Tue 08-12-09 23:54:24, tytso@mit.edu wrote:
> > Here's a revised version of your patch that I've included in the ext4
> > patch queue.  I've removed the use of the atomic_t data type.  I've
>   OK, I'm just unsure: Isn't even 32-bit read non-atomic if it is not
> properly aligned e.g. on powerPC? So shouldn't we make sure those inode
> fields are aligned to 32-bit boundary (or at least add a comment about
> that)?

But gcc guarantees such alignments, unless you do something horrible
from a performance point of view, such as using
__attribute__((packed)).  And in fact, if things are not aligned, on
some platforms unaligned access will trigger a software trap, and the
kernel trap handler has to fix up the unaligned access.  (I believe
Power is one of these platforms if memory serves correctly.)  Even on
platforms that don't, the performance hit where the hardware has to do
the unaligned access so horrible that gcc avoids the misalignment
automatically.

That's why sometimes I'll go around and try to adjust structure member
orders, since something like this:

struct foo {
       short int a;
       int   b;
       short int c;
} foo_array[2];

Will consume 24 bytes.... while this:

struct foo {
       short int a;
       short int c;
       int   b;
} foo_array[2];

... will consume 16 bytes.  For structures that are used in huge
amounts (like inode slab caches), it can mean a measurable memory
savings.

						- Ted
