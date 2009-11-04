From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 4/4 v2] Fix direct IO return values over fullfilled
	fallocate space
Date: Tue, 3 Nov 2009 21:27:07 -0500
Message-ID: <20091104022707.GI6510@mit.edu>
References: <1255050792.4931.185.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50989 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbZKDC1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2009 21:27:03 -0500
Content-Disposition: inline
In-Reply-To: <1255050792.4931.185.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 08, 2009 at 06:13:12PM -0700, Mingming wrote:
> @@ -2827,8 +2828,8 @@ static int ext4_split_unwritten_extents(
>   	 * the size of extent to write, there is no need to split
>   	 * uninitialized extent
>   	 */
> - 	if (allocated <= max_blocks)
> -		return ret;
> + 	if (iblock == ee_block && allocated <= max_blocks)
> +		return allocated;

The change to add "iblock == ee_block" isn't explained in the patch
description and it makes the comment above the conditional no longer
accurate.

Can you add an explanation why it's necessary?

Thanks,
					- Ted
