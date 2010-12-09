From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext2: speed up file creates by optimizing rec_len
 functions
Date: Wed, 08 Dec 2010 20:13:46 -0600
Message-ID: <4D003B5A.5060807@redhat.com>
References: <4CFE7347.8030807@redhat.com> <4CFE7409.9090609@redhat.com> <20101207130708.71c894e9.akpm@linux-foundation.org> <4CFEA5AF.2000702@redhat.com> <20101207133308.eb2144da.akpm@linux-foundation.org> <63DB7A38-7D0F-406E-8ACD-9CE5DB977DD9@dilger.ca> <4CFFF394.1020303@redhat.com> <F51EB2BF-8C99-4E2F-943E-E795A0F4DF7F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0LICOA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Dec 2010 21:14:00 -0500
In-Reply-To: <F51EB2BF-8C99-4E2F-943E-E795A0F4DF7F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/8/10 3:44 PM, Andreas Dilger wrote:
> On 2010-12-08, at 14:07, Eric Sandeen wrote:
>> On 12/08/2010 01:01 PM, Andreas Dilger wrote:
>>> I think an important factor here is that this is being tested on
>>> a ramdisk, and is likely CPU bound, so any CPU reduction will
>>> directly be measured as a performance improvement.  Probably
>>> oprofile is in order to see where other major CPU users are.
>> 
>> Yep, I ran oprofile.
>> 
>> samples  %        app name                 symbol name 1140046
>> 41.8702  ext2.ko                  ext2_find_entry 1052117  38.6408
>> ext2.ko                  ext2_add_link 98424     3.6148  vmlinux
>> native_safe_halt 40461     1.4860  vmlinux
>> wait_on_page_read 29084     1.0682  vmlinux
>> find_get_page
>> 
>> pretty slammed on those 2 ext2 functions!  I think it's pretty 
>> overwhelmed by the linear search.
> 
> Can you test ext4 with nojournal mode, but with dir_index enabled?  I
> suspect that testing ext2 for directory performance is pointless.

Oh, I agree.  I just had a report of a regression in a certain distro,
which is frowned upon... :)  I'm positive ext4 nojournal would beat the
pants off it due to dir_index.

> My personal threshold for ext2 directories was 10k files before I
> considered it a lost cause, and all of your tests are with 10k+ files
> per directory.

Agreed, it's not very realistic but then it was a simple fix too.
Still took time though...

> Just another log on the fire beneath getting rid of ext2 (and
> eventually ext3) in favour of ext4, IMHO.  I'd be surprised if there
> are many benchmarks that ext2 can beat ext4 in nojournal mode, if
> allowed to enable "reversible" format changes like dir_index,
> uninit_bg, etc.

Hey, I wouldn't complain.

-Eric

> Cheers, Andreas
> 
> 
> 
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-ext4" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

