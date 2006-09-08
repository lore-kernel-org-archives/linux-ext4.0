From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: Re: Updated ext4 patches for 2.6.18-rc6
Date: Fri, 8 Sep 2006 18:13:24 +0200
Message-ID: <20060908161324.GA19256@openx1.frec.bull.fr>
References: <20060908131144sho@rifu.tnes.nec.co.jp> <1157698868.8616.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, shaggy@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52424 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750967AbWIHQNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Sep 2006 12:13:36 -0400
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <1157698868.8616.20.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Sep 08, 2006 at 12:01:08AM -0700, Mingming Cao wrote:
> Hello,
> 
> Just give you all an update about the latest ext4 patches before I leave
> for vacation: The latest ext4 patches (clone ext4 + 48bit ext4) is
> against 2.6.18-rc6, as usual, could be found at:
> 
> http://ext2.sourceforge.net/ext4/patches/latest/
> 
> Haven't done series testing yet, but fsx test runs fine a few hours on
> ext4dev filesystem mounted with extents:)
> 
> change log since last release (2.6.18-rc4)
> 
> rebase ext4/jbd2 clone patches to 2.6.18-rc6 (Mingming Cao<cmm@us.ibm.com>)
> rename ext3dev to ext4dev (Randy  Dunlap <rdunlap@xenotime.net>, Mingming Cao <cmm@us.ibm.com)
> register-ext4dev.patch
> +register-jbd2.patch
> 
> *comment fixs in extent patch (Randy  Dunlap <rdunlap@xenotime.net>)
> +extents_comment_fix.patch
> 
> *change some micro and inline functions to c fuctions(Avantika Mathur<mathur@us.ibm.com)
> +64bitmetadata_inline_funcs_fix.patch
> 
> *change ext4/jbd2 block type from sector_t to unsigned long long. (Mingming Cao<cmm@us.ibm.com>). remove sector_fmt.patch
> +ext4_blk_type_from_sector_t_to_ulonglong.patch
> +ext4_remove_sector_t_bits_check.patch
> +jbd2_blks_type_from_sector_t_to_ull.patch
> -sector_fmt.patch
> 
> Andrew, you could pull all the patches(in quilt style) from here(a
> series of patches)
> http://ext2.sourceforge.net/ext4/patches/latest/broken-out/
> 
> Shaggy has nicely offered to maintain and forward all these patches from
> here while I am out, thanks, Shaggy:)
>

hi,

there are 2 more patches:

* ext4_remove_relative_block_numbers:

  use 48bit absolute block numbers instead of mixed relative/absolute block
  numbers. This is simpler and seems to fix issues with large file systems.
   
* ext4_allow_larger_descriptor_size:

  allow larger block group descriptors: this patch will allow to add new
  features that need more space in the block descriptor.

here is the complete patch set:

http://www.bullopensource.org/ext4/20060908/ext4-linux-2.6.18-rc6.tar.gz

there's also a patch set for the latest e2fsprogs that is in sync with the
kernel patches:

http://www.bullopensource.org/ext4/20060908/ext4-e2fsprogs-1.39.tar.gz

cheers,

-- Alexandre
