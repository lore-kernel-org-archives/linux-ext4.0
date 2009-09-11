From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Fri, 11 Sep 2009 09:15:39 -0500
Message-ID: <4AAA5B8B.3010905@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com> <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com> <20090910215158.GI9372@webber.adilger.int> <4AA97652.4010802@redhat.com> <20090910231946.GF6705@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbZIKOPo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 10:15:44 -0400
In-Reply-To: <20090910231946.GF6705@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Sep 10, 2009 at 04:57:38PM -0500, Eric Sandeen wrote:
>> Problem is I don't quite trust debugfs etc to get it right, so when I
>> see < 32 bits, I'm not sure if it's really there, or if the
>> reporting/debug tool wrapped it ;)
> 
> Debugfs from pu branch definitely does get it right --- I've checked.
> 
> 	     	       		       	   - Ted

I couldn't get debugfs from pu to even load a large filesystem, odd...

# debugfs/debugfs ../bigfile
debugfs 1.41.9 (22-Aug-2009)
../bigfile: Filesystem too large to use legacy bitmaps while reading 
block bitmap

I haven't yet looked into this...

-Eric
