From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH][BUG] ext4: dx_map_entry cannot support over 64KB block
 size
Date: Mon, 8 Jun 2009 16:30:55 +0900
Message-ID: <20090608163055.0eab9737.toshi.okajima@jp.fujitsu.com>
References: <20090605165049.e8bd9c74.toshi.okajima@jp.fujitsu.com>
	<20090605212000.GV9002@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43869 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZFHHqi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 03:46:38 -0400
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id n587kdo5007390
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Mon, 8 Jun 2009 16:46:39 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1636C45DD77
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2009 16:46:39 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id DCB1345DD6F
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2009 16:46:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id D04951DB801C
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2009 16:46:38 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 89AF51DB8016
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2009 16:46:38 +0900 (JST)
In-Reply-To: <20090605212000.GV9002@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
> On Jun 05, 2009  16:50 +0900, Toshiyuki Okajima wrote:
> > > From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> > > 
> > > The dx_map_entry structure doesn't support over 64KB block size by current
> > > usage of its member("offs"). Because "offs" treats an offset of copies of
> > > the ext4_dir_entry_2 structure as is. This member size is 16 bits. But real
> > > offset for over 64KB(256KB) block size needs 18 bits. However, real offset
> > > keeps 4 byte boundary, so lower 2 bits is not used.
> > > 
> > > Therefore, we do the following to fix this limitation:
> > > For "store": 
> > > 	we divide the real offset by 4 and then store this result to "offs" 
> > > 	member.
> > > For "use":
> > > 	we multiply "offs" member by 4 and then use this result 
> > > 	as real offset.
> 
> This patch unfortunately doesn't address all of the issues related
> to blocksize > 64kB.
> 
> There are a number of other places where there are limits related
> to > 64kB blocksize like ext4_dir_entry_2 itself having only a
> "__u16 rec_len", so without changing the on-disk format it is not
> possible to have > 64kB blocksize.
> 
> You would only notice this if you create a large enough directory.
> It might be possible to force very large directory blocks to have
> multiple directory entries (max size 65536 bytes using the helpers
> ext4_rec_len_{to,from}_disk() to convert 0xffff -> 0x10000).

This patch isn't one of the patches in order to support "blocksize > 64KB"
 with ext4. It only fixes dx_map_entry handling when we use "blocksize > 64KB".
You know, ext4_rec_len_{to,from}_disk() has already supported 
"blocksize > 64KB". But dx_map_entry doesn't support "blocksize > 64KB" now.
So, I have posted it to fix dx_map_entry handling on "blocksize > 64KB".

I understand ext4_rec_len_{to,from}_disk() are useful for almost purpose of 
ext4_dir_entry_2 handling. But "offs" which is the member of dx_map_entry is 
exceptional. Because dx_map_entry must treat "0" value (offset = 0) but they 
cannot treat "0" value.
("0" is special value for them.)

>  unsigned int ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
>  {
>          unsigned len = le16_to_cpu(dlen);
>   
>          if (len == EXT4_MAX_REC_LEN || len == 0)
                                          ^^^^^^^^^
>                   return blocksize;
                    ^^^^^^^^^^^^^^^^^
>           return (len & 65532) | ((len & 3) << 16);
>   }

So, we cannot use them for "offs".
Therefore I decided to use shift operations instead of them
because it is easy implementation.

[store]
> > > +			map_tail->offs = ((char *) de - base)>>2;
[use]
> > > +		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) 
> > > +							(from + (map->offs<<2));
 
Thanks,
Toshiyuki Okajima
