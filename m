From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] remove unnecesary while loop in ext2_xattr_get
Date: Mon, 12 Jul 2010 18:40:43 +0200
Message-ID: <20100712164018.GC5658@bicker>
References: <201007122309063128435@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: crosslonelyover <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab0GLQmM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jul 2010 12:42:12 -0400
Content-Disposition: inline
In-Reply-To: <201007122309063128435@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 11:09:09PM +0800, crosslonelyover wrote:
> Hi,
>      In ext2_xattr_get, we'll check the xattr entry one 
> by one in the following loop:
>          entry = FIRST_ENTRY(bh);
>          while (!IS_LAST_ENTRY(entry)) {
>                  struct ext2_xattr_entry *next =
>                          EXT2_XATTR_NEXT(entry);
>                  if ((char *)next >= end)
>                          goto bad_block;
>                  if (name_index == entry->e_name_index &&
>                      name_len == entry->e_name_len &&
>                      memcmp(name, entry->e_name, name_len) == 0)
>                          goto found;
>                  entry = next;
>          }
> We can only execute the code immediately following 
> the loop when !IS_LAST_ENTRY(entry) is true. So the
> followed while loop seems unnecessary. I think we can
> remove it.
>       Following is my patch. It's against 2.6.35-rc4.
> Please check it.
> 

Yes.  This is dead code.  This stuff is from the days before git
so we'll never know who to blame for it.

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

