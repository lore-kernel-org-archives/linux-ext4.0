From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] libext2fs: fix bad cast which causes problems for
 file systems > 512EB
Date: Tue, 04 Oct 2011 13:15:15 -0500
Message-ID: <4E8B4D33.3020000@redhat.com>
References: <20111004040033.GM6684@thunk.org> <1317702420-31085-1-git-send-email-tytso@mit.edu> <1317702420-31085-2-git-send-email-tytso@mit.edu> <4E8AF240.7010905@sandeen.net> <20111004180555.GB10007@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853Ab1JDSPT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 14:15:19 -0400
In-Reply-To: <20111004180555.GB10007@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/4/11 1:05 PM, Ted Ts'o wrote:
> On Tue, Oct 04, 2011 at 06:47:12AM -0500, Eric Sandeen wrote:
>> On 10/3/11 11:27 PM, Theodore Ts'o wrote:
>>> If the number of block groups exceeds 2**32, a bad cast would lead to
>>> a bogus "Not enough space to build proposed filesystem while setting
>>> up superblock" failure.
>>
>> It's the proper cast now, but I don't think it fixes the problem, since they
>> are both __u32...
> 
> Hmm, yes.
> 
> And to be quite honest I'm not sure it's worth fixing.  2**32 block
> groups gets us up to 2**59 bytes assuming 4k blocks.  The theoretical
> maximum given the current extent tree format is 2**60 assuming 4k
> blocks.  So changing dgrp_t to be 64-bits just to get that last power
> of two (i.e., from 512EB to a full PB) doesn't seem worth it.  Simply
> using a bigalloc cluster size of 8k would make the problem go away
> (and arguably we'd probably want a large cluster size if someone
> wanted to create a file system that big anyway).
> 
> So maybe we should just check to see if the required number of block
> groups is greater than 2**32, and if so, give an error.
> 
>        	  	       	      	  - Ted
> 

As long as we have a consistent, predictable, well-designed and well-understood
maximum (theoretical) size for the fs, I'm all for documenting & enforcing it.

TBH I'm still trying to get all the moving parts together in my head, between
meta_bg & bigalloc & whatnot, at these sizes.

The initialization functions are looking pretty ad-hoc to me right now. :)

-Eric
