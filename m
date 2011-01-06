From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] ext4: Drop i_state_flags on architectures with
 64-bit longs
Date: Thu, 6 Jan 2011 12:55:26 -0500
Message-ID: <20110106175526.GA2857@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-6-git-send-email-tytso@mit.edu>
 <5A9C7BCF-AA25-494F-9C64-8A6553B44395@dilger.ca>
 <20110105202952.GO2959@thunk.org>
 <B0A77358-77C0-41DB-8281-FC7CEA4BC826@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39393 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1AFRza (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jan 2011 12:55:30 -0500
Content-Disposition: inline
In-Reply-To: <B0A77358-77C0-41DB-8281-FC7CEA4BC826@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 06, 2011 at 12:23:53AM -0700, Andreas Dilger wrote:
> > Yeah, I did think of this, but it seemed like extra/needless work that
> > I was trying to optimize away.  It's still not safe to do:
> > 
> > #define EXT4_CLEAR_STATE_FLAGS(ei)      (ei)->i_flags &= 0xffffffffULL;
> > 
> > ... since we're not atomically updating i_flags.
> 
> This code would only be used on a 64-bit arch, so it should be
> updating the whole word at once (unlike a 32-bit arch).

Masking off the low 32-bits is a read / mask / write set of operations
on RISCy architectures.  Even on an Intel architecture, unless you
specifically use the LOCK prefix on the AND operation, you can still
risk racing with another CPU while you do the mask operation.  So no,
it's not atomic.

This is why we did a wholesale replacement of explicit C bit
operations on ei->i_flags and replaced them with
ext4_{set/get/clear}_inode_flags.  And why in the jbd/jbd2 layer, we
take an explicit spinlock before modifying j_flags.  (An obvious thing
to try doing to reduce spinlock contention on big 48-core machines is
to replace do a similar replacement in the jbd2 layer; on my todo
list.)

> > I did think about putting the #ifdef BITS_PER_LONG < 64 inline in the
> > code, but that's ugly.  
> 
> I'm missing the point of that - isn't the EXT4_CLEAR_STATE_FLAGS() macro
> masking already conditional on 64-bit architectures?

Sorry, I must not have been clear.  I was referring to putting in an
inline #if statement into the C code as being ugly.

> The one call in ext4_do_update_inode() that is masking i_flags is redundant,
> since the cpu_to_le32() macro is itself either masking the value before
> swabbing, and/or it is truncated by the assignment to i_flags.

(Actually, I think the C compiler will likely notice that the earlier
i_flags is redudant, and optimize it out.)

I could have replaced things with this instead:

#if BITS_PER_LONG < 64
	ei->i_state_flags = 0
#endif

That's more "correct", but it's ugly.  On the other hand, it does make
explicit what is going on, instead of hiding it in a header file.
Whether we think it's better depends on how likely that people will
get confused in the future.  If we think it's likely this section of
code will be regularly modified, then we can keep it explicit to
minimize the chances that a future change in the code will move things
around and I don't notice when I'm reviewing the patch.

If we think the section of code is less likely to be changed, then
hiding this detail could make it easier for the casual reader to
understand the code.

To be honoest, it's a minor point either way.  I don't have strong
feelings about how this gets done one way or another; I just had to
pick one, and I went with the latter approach.  I'm certainly willing
to be pursuaded otherwise that the chances that someone could fall
into the pitfall would be huge.

						- Ted
