From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 corruption causing a crash
Date: Wed, 16 Nov 2016 13:17:50 -0500
Message-ID: <20161116181750.vjyqznnbucvpaoix@thunk.org>
References: <f4fcebfd-292e-5238-b592-65fa605f1445@kyup.com>
 <d2aea076-15c1-2131-faca-0fb977f3d082@kyup.com>
 <6afc40e8-50fd-0019-a172-03e52028ba25@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>,
        bp@alien8.de
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49052 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752282AbcKPSSB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 16 Nov 2016 13:18:01 -0500
Content-Disposition: inline
In-Reply-To: <6afc40e8-50fd-0019-a172-03e52028ba25@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2016 at 03:03:35PM +0200, Nikolay Borisov wrote:
> 
> Ok so with the help of bpetkov we managed to get to the bottom it, 
> essentially what happens is that we overflow the page allocated in 
> ext4_calculate_overhead while working in the following loop in count_overhead: 
> 
> for (j = ext4_bg_num_gdb(sb, grp); j > 0; j--) {
> 	ext4_set_bit(EXT4_B2C(sbi, s++), buf);
> 	count++;
> }
> 
> so ext4_bg_num_gdb returns a big number - 32768 and since sbi->s_cluster_bits 
> is 0 the result of EXT4_B2C(sbi, s++) becomes just s, which incremented on 
> every iteration and eventually becomes a large number. This causes to overflow 
> the page used as a buf. This can be seen easily from the crash produced when 
> debug_pagealloc is enabled:

Thanks for digging into this!  It sounds like we need to add more
sanity checking at mount time, as well as some safety constraints to
make sure we don't overrun memory.

Can you send me dumpe2fs -h output from the drive that provoked this?

Thanks,

						- Ted
