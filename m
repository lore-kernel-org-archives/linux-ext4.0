From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Potential bug in fs/ext4/inline.c?
Date: Thu, 21 Aug 2014 21:02:46 -0700
Message-ID: <20140822040246.GA12576@birch.djwong.org>
References: <20140821220126.GA3597@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gnehzuil.liu@gmail.com, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18162 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHVECv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2014 00:02:51 -0400
Content-Disposition: inline
In-Reply-To: <20140821220126.GA3597@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 21, 2014 at 06:01:26PM -0400, Theodore Ts'o wrote:
> In ext4_find_inline_entry(), there is the following:
> 
> 	if (ext4_get_inline_size(dir) == EXT4_MIN_INLINE_DATA_SIZE)
> 		goto out;
> 
> Am I missing something, or shouldn't this be:
> 
> 	if (ext4_get_inline_size(dir) <= EXT4_MIN_INLINE_DATA_SIZE)
> 		goto out;
> 
> ?

I'm not sure it matters, since I see:

EXT4_I(inode)->i_inline_size = len + EXT4_MIN_INLINE_DATA_SIZE

scattered all over the code.  I'm not sure I like the idea that both ext4 and
e2fsprogs think that the inline data size is never <= 60, but afaict it doesn't
cause any problems.

--D

> 
> Thanks,
> 
> 						- Ted
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
