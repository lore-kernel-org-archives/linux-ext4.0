From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: check for overlapping extents in
 ext4_valid_extent_entries()
Date: Mon, 21 Oct 2013 18:06:23 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310211751370.1983@localhost.localdomain>
References: <1382002073-27862-1-git-send-email-guaneryu@gmail.com> <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1048973853-1382371586=:1983"
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3JUQGa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Oct 2013 12:06:30 -0400
In-Reply-To: <1382275647-4616-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1048973853-1382371586=:1983
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 20 Oct 2013, Eryu Guan wrote:

> Date: Sun, 20 Oct 2013 21:27:27 +0800
> From: Eryu Guan <guaneryu@gmail.com>
> To: linux-ext4@vger.kernel.org
> Cc: Eryu Guan <guaneryu@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
>     Lukáš Czerner <lczerner@redhat.com>
> Subject: [PATCH v2] ext4: check for overlapping extents in
>     ext4_valid_extent_entries()
> 
> A corrupted ext4 may have out of order leaf extents, i.e.
> 
> extent: lblk 0--1023, len 1024, pblk 9217, flags: LEAF UNINIT
> extent: lblk 1000--2047, len 1024, pblk 10241, flags: LEAF UNINIT
>              ^^^^ overlap with previous extent
> 
> Reading such extent could hit BUG_ON() in ext4_es_cache_extent().
> 
> 	BUG_ON(end < lblk);
> 
> The problem is that __read_extent_tree_block() tries to cache holes as
> well but assumes 'lblk' is greater than 'prev' and passes underflowed
> length to ext4_es_cache_extent(). Fix it by checking for overlapping
> extents in ext4_valid_extent_entries().
> 
> I hit this when fuzz testing ext4, and am able to reproduce it by
> modifying the on-disk extent by hand.
> 
> Ran xfstests on patched ext4 and no regression.

Looks ok, but I have some nitpicks bellow :)

> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Lukáš Czerner <lczerner@redhat.com>
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
> Hi,
> 
> My second try to find and report the corruption instead of hiding it,
> how about this one?
> 
> Thanks!
> 
> Eryu
> 
>  fs/ext4/extents.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c9ebcb9..855b11d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -387,11 +387,21 @@ static int ext4_valid_extent_entries(struct inode *inode,
>  	if (depth == 0) {
>  		/* leaf entries */
>  		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
> +		ext4_lblk_t block = 0;
> +		ext4_lblk_t prev = 0;
> +		int len = 0;
>  		while (entries) {
>  			if (!ext4_valid_extent(inode, ext))
>  				return 0;
> +
> +			/* Check for overlapping extents */
> +			block = le32_to_cpu(ext->ee_block);
> +			len = ext4_ext_get_actual_len(ext);
> +			if ((block <= prev) && prev)

Both ext4_valid_extent() and ext4_valid_extent_idx() are setting
s_last_error_block in the case of error. Maybe we should to the same
here ? Note that the block saved in that variable is physical, not
logical.

Also I am curious what happens when one of the extents is corrupted
in such a way that it crosses the 16TB boundary ? In this case the
check would not recognise that since prev will underflow, but maybe
something else catches that ?

Thanks!
-Lukas

> +				return 0;
>  			ext++;
>  			entries--;
> +			prev = block + len - 1;
>  		}
>  	} else {
>  		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
> 
--8323328-1048973853-1382371586=:1983--
