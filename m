From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] ext4: Drop i_state_flags on architectures with
 64-bit longs
Date: Wed, 5 Jan 2011 15:29:52 -0500
Message-ID: <20110105202952.GO2959@thunk.org>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu>
 <1294189270-16733-6-git-send-email-tytso@mit.edu>
 <5A9C7BCF-AA25-494F-9C64-8A6553B44395@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47386 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1AEU3z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Jan 2011 15:29:55 -0500
Content-Disposition: inline
In-Reply-To: <5A9C7BCF-AA25-494F-9C64-8A6553B44395@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 05, 2011 at 11:43:08AM -0700, Andreas Dilger wrote:
> 
> It looks like you have compensated for the above by changing the
> code here, but I think it is risky/confusing if clearing the state
> flags has a side-effect on 64-bit arches, that doesn't exist on
> 32-bit arches.  It looks like a bug waiting to happen...

Yeah, I did think of this, but it seemed like extra/needless work that
I was trying to optimize away.  It's still not safe to do:

#define EXT4_CLEAR_STATE_FLAGS(ei)      (ei)->i_flags &= 0xffffffffULL;

... since we're not atomically updating i_flags.  So if anyone tries
using EXT4_CLEAR_STATE_FLAGS() aside from the two allocation contexts,
they need to be careful anyway.

I did think about putting the #ifdef BITS_PER_LONG < 64 inline in the
code, but that's ugly.  

Maybe the best thing to do is to clearly document this pitfall, and
then leave things as-is?   There aren't a lot of great solutions.

						- Ted
