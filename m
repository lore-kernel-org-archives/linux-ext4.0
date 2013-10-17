From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: don't cache out of order extents
Date: Thu, 17 Oct 2013 17:22:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310171704300.3212@localhost.localdomain>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com> <alpine.LFD.2.00.1310171534440.3212@localhost.localdomain> <20131017144044.GA3605@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1527324554-1382023381=:3212"
Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab3JQPXE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 11:23:04 -0400
In-Reply-To: <20131017144044.GA3605@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1527324554-1382023381=:3212
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 17 Oct 2013, Theodore Ts'o wrote:

> Date: Thu, 17 Oct 2013 10:40:44 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: don't cache out of order extents
> 
> On Thu, Oct 17, 2013 at 03:44:35PM +0200, Lukáš Czerner wrote:
> > 
> > So what will happen with the file system with this patch when
> > presented with such corruption ?
> > 
> > It seems to me that ext4_es_cache_extent() will happily skip this
> > extent because it will find that this particular offset is already
> > in the tree. Hence we'll have a gap in the status tree which really
> > should not be there and I suspect that something bad will happen.
> 
> Ah, I see what's going wrong.  __read_extent_tree_block() calls
> __ext4_ext_check() which is supposed to validate that extent tree
> block is valid.  The __ext4_ext_check() function calls
> ext4_valid_extent_entries() which is supposed to validate the
> individual entries in the extent.  However, it is not checking to make
> sure there are no overlapping extents.  We should add that check to
> ext4_valid_extent_entries(); that way, we will call ext4_error_inode()
> to mark the file system as corrupted.

I agree, since ext4_ext_check() should be really only used when
reading data from disk. That said, we might actually remove the
check from ext4_ext_precache() and ext4_ext_remove_space() because
it seems to be that the check has already been done in ext4_iget()
and it should be enough to check it once when reading from disk,
right ?

> 
> Eryu's patch, or something like it, will still be needed so that in
> the case of errors=countinue, we don't end up calling BUG_ON().

Hmm shouldn't we avoid that data in the case that it's corrupted
rather than using it ? It seems like this is what the code would do
anyway even with errors=continue when __ext4_ext_check() returns
error.

Thanks!
-Lukas

> 
> Thanks for finding this!
> 
> 						- Ted
> 
--8323328-1527324554-1382023381=:3212--
