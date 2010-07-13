From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
Date: Mon, 12 Jul 2010 22:46:50 -0600
Message-ID: <DA64905D-C83B-4CF5-9405-65F7F82F9563@dilger.ca>
References: <871vbax86w.fsf@patl.com> <87zkxyvtjt.fsf@patl.com> <3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca> <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:42214 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0GMEqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 00:46:54 -0400
In-Reply-To: <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-12, at 19:08, Patrick J. LoPresti wrote:
> On Mon, Jul 12, 2010 at 5:21 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
>>> 
>>> +     /* Absolute addressability check (borrowed from ext4/super.c) */
>>> +     if ((max_block >
>>> +          (sector_t)(~0LL) >> (osb->sb->s_blocksize_bits - 9)) ||
>>> +         (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIFT -
>>> +                                          osb->sb->s_blocksize_bits))) {
>>> +             mlog(ML_ERROR, "Volume too large "
>>> +                  "to mount safely on this system");
>>> +             status = -EFBIG;
>>> +             goto out;
>>> +     }
>> 
>> This hunk of code is actually in several filesystems.  It wouldn't be a bad idea to make it a library function that can be called by the filesystem to check the kernel page cache and block layer can handle these large filesystems.
> 
> True, but some of them do it differently (e.g. see the #if switch in
> xfs_sb_validate_fsb_count).  Tracking down all variants and changing
> them is a much larger task than my simple patch.
> 
> Are you suggesting I need to do this before my patch is accepted at
> all?  Or is this a refactoring that can happen later?

I'm just suggesting it should be done at some point.  I thought it would be better to do it first, rather than add yet another copy of this code.  That said, I hate to block useful fixes because of cleanup (and I have no control over OCFS2 anyway :-).  However, I've found that once the fix is in people usually forget (or become too busy) to do the cleanup and it just lingers on unseen.

Cheers, Andreas





