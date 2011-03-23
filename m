From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: unused variables cleanup in check_eofblocks_fl
 and ext4_ext_map_blocks
Date: Wed, 23 Mar 2011 14:10:18 -0400
Message-ID: <20110323181018.GA2548@thunk.org>
References: <20110322115126.GB5086@swordfish.minsk.epam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58749 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab1CWSK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 14:10:27 -0400
Content-Disposition: inline
In-Reply-To: <20110322115126.GB5086@swordfish.minsk.epam.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 22, 2011 at 01:51:26PM +0200, Sergey Senozhatsky wrote:
> ext4 extents cleanup:
> 
>   . remove unused `*ex' from check_eofblocks_fl
>   . remove unused `*eh' from ext4_ext_map_blocks
> 
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Added to the ext4 patch queue, thanks.

				- Ted
