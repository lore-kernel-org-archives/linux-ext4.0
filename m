From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk addressability
 check
Date: Sun, 15 Aug 2010 22:36:36 -0500
Message-ID: <4C68B244.6080406@redhat.com>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com> <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca> <20100812201534.GA22777@mail.oracle.com> <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca> <20100812222949.GC22777@mail.oracle.com> <20100813163006.GB4329@quack.suse.cz> <4C6821A8.5080805@redhat.com> <20100816025436.GA9061@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab0HPDgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Aug 2010 23:36:42 -0400
In-Reply-To: <20100816025436.GA9061@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Joel Becker wrote:
> On Sun, Aug 15, 2010 at 12:19:36PM -0500, Eric Sandeen wrote:
>>>> +	    (last_fs_block >
>>>> +	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - blocksize_bits))) {
>>>             ^^^ I don't get the pgoff_t check. Shouldn't it rather be
>>> (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)?
>> Argh that was my fault...  Thankfully not too many 1k-blocksize-formatted
>> 16T devices out there, I guess.
>>
>> I went through the math again and also came up with:
>>
>> total fs pages is blocks / (blocks per page)
>> total pages is blocks / (1 << PAGE_CACHE_SHIFT / 1 << blocksize_bits)
>> total pages is blocks / (1 << (PAGE_CACHE_SHIFT - blocksize_bits))
>> total pages is blocks * (1 >> (PAGE_CACHE_SHIFT - blocksize_bits))
>> total pages is blocks >> (PAGE_CACHE_SHIFT - blocksize_bits)
>>
>> too big if total pages is > (pgoff_t)(~0ULL)
>> too big if blocks >> (PAGE_CACHE_SHIFT - blocksize_bits) > (pgoff_t)(~0ULL)
> 
> 	Why not stop here, which is what I put in my other email?
> "blocks >> SHIFT-bits" is "how many pages do I need?".

yeah, ok.  Was going for pointless symmetry w/ the other test...

>> too big if blocks > (pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)
>> and to not overflow:
>> too big if blocks > (u64)(pgoff_t)(~0ULL) << (PAGE_CACHE_SHIFT - blocksize_bits)
> 
> 	This still overflows.  pgoff_t is a u64 on 64bit machines,
> right?  So shift that left by anything and you wrap.

Er, yeah.  I had 32 bits in my head since that's the case we're
checking for... whoops.

So I guess your

 	    ... ||
	    ((last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits)) >
	     (pgoff_t)(!0ULL))) {

is right :)  (my feeble brain has a hard time reading that, though, TBH)

-Eric

> Joel
> 

