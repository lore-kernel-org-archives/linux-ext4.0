From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/3] ext3/ext4: Factor out disk addressability
 check
Date: Mon, 16 Aug 2010 09:44:35 -0500
Message-ID: <4C694ED3.5070500__40358.0888211311$1281969899$gmane$org@redhat.com>
References: <874ofr2myq.fsf@patl.com> <20100812174215.GC6561@mail.oracle.com> <1F3EDC08-AC93-4D4D-8F83-A13C418DFC88@dilger.ca> <20100812201534.GA22777@mail.oracle.com> <209AEA97-E284-4ADB-8774-50C2630606B9@dilger.ca> <20100812222949.GC22777@mail.oracle.com> <20100813163006.GB4329@quack.suse.cz> <4C6821A8.5080805@redhat.com> <20100816025436.GA9061@mail.oracle.com> <4C68B244.6080406@redhat.com> <20100816092114.GB9061@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>, "Ted Ts'o" <tytso@mit.edu>,
	ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab0HPOor (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Aug 2010 10:44:47 -0400
In-Reply-To: <20100816092114.GB9061@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Joel Becker wrote:
> On Sun, Aug 15, 2010 at 10:36:36PM -0500, Eric Sandeen wrote:
>> Er, yeah.  I had 32 bits in my head since that's the case we're
>> checking for... whoops.
>>
>> So I guess your
>>
>>  	    ... ||
>> 	    ((last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits)) >
>> 	     (pgoff_t)(!0ULL))) {
>>
>> is right :)  (my feeble brain has a hard time reading that, though, TBH)
> 
> 	Well, note the bug in my quickly typed version: "(!0ULL)" vs
> "(~0ULL)".  

*nod* saw that but figured it was just a typo & didn't mention it ;)

> How about:
> 
> 	u64 last_fs_page = last_fs_block >> (PAGE_CACHE_SHIFT - blocksize_bits);
> 
> 	... ||
> 	(last_fs_page > (pgoff_t)(~0ULL))) {
> 
> Is that more readable?

To me, yes.  Maybe do similar for last_fs_sector.

If it's getting too verbose I understand, but less dense is a lot easier
to read, IMHO.  Just style though, really, so *shrug*

Thanks,
-Eric

> Joel
> 

