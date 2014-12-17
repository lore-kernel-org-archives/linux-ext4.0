From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents
 traversial
Date: Tue, 16 Dec 2014 22:57:13 -0500
Message-ID: <20141217035713.GW17575@thunk.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
 <1417518054-21733-4-git-send-email-dmonakhov@openvz.org>
 <20141211200540.GE31008@thunk.org>
 <878uidgshe.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60033 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaLQD5Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2014 22:57:16 -0500
Content-Disposition: inline
In-Reply-To: <878uidgshe.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 12, 2014 at 11:52:29AM +0300, Dmitry Monakhov wrote:
> Oh. Indeed That is my mistake.
> 
> ret = ext4_fiemap(inode, &fie, offset, maxsize - offset);
> /* No extents found, EOF */
> if (!fie.fi_extents_mapped) {
>      ret = -ENXIO;
>      break;
>   }                                                                           
> Delalloc case handled incorrectly. Will fix that ASAP.

Hi Dmitry, how are things going with a fix?  It would be great if I
can get something which I can test and push to Linus before he
releases -rc1.

Thanks!!

					- Ted
