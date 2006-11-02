From: Grzegorz Kulewski <kangur@polcom.net>
Subject: Re: ext4 roadmap
Date: Thu, 2 Nov 2006 02:44:28 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0611020219290.14187@alpha.polcom.net>
References: <1162422997.13777.35.camel@kleikamp.austin.ibm.com>
 <Pine.LNX.4.63.0611020026000.14187@alpha.polcom.net>
 <20061102011753.GM5212@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alpha.polcom.net ([83.143.162.52]:46305 "EHLO alpha.polcom.net")
	by vger.kernel.org with ESMTP id S1752441AbWKBBog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 20:44:36 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20061102011753.GM5212@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2 Nov 2006, Andreas Dilger wrote:
> On Nov 02, 2006  00:52 +0100, Grzegorz Kulewski wrote:
>> Is there any chance to get compression and/or encryption in ext4?
>
> Note that all of the features mentioned in the list at least have some
> kind of prototype already or people working on it.  It isn't really a
> "feature request list".  I'm not sure how many people are interested
> in compression/encryption, but if they are they should come forward
> with a patch.

I understand that. Unfortunatelly I don't have enough time to write 
something like that and my knowledge about ext3/4 in the kernel is pretty 
limited too.

***This is only an idea if somebody with more code knowledge has time and 
thinks that this is worth implementing. This is simply something that I, 
a user (maybe a little more advanced one, but still user) of ext3, thinks 
would be usefull.***

Also (as to the compression) I think Linux's VFS and page cache and so on 
operates rather on data amounts of constant length and isn't too well 
suited for making them smaller (or larger) somewhere in the middle 
between userspace and the disk. But maybe I am completly wrong about it. 
But if I am not wrong extending core Linux components to allow easy 
generic compression (or other manipulation that changes size) should be 
probably done in cooperation with something that works pretty close with 
core kernel components (like ext3/4 in my opinion does). This could 
possibly allow to avoid having 10 different implementation for each 
filesystem in the future. Compression and especially encryption should not 
be (in my opinion) too much fs dependent (fs should not care too much 
about data only about metadata) and should have only minimal per-fs 
support (additional metadata to allow discovering that file was 
compressed and to allow seeks for example). But again, maybe I am 
completly wrong.

As to the encryption and per-dir quota they should be probably easier (I 
hope). Maybe even I can try to hack something like that if somebody could 
tell me how to do it in a way to not break too much in the process). But 
they would probably require some ext3 on-disk filesystem layout changes 
(and e2progs changes too) so maybe ext4-development time is good to 
introduce them?


> Note that there was previously a compression patch for ext2, maybe that
> could be moved forward for ext4?

I know about ext2 patch (I even think there was more than one) and I even 
used it in those old days when linux distro could be made to fit on 250MB 
disk without too much problems. I think I ever know (one of?) the author 
of it personally. Unfortunatelly IIRC this was rather some not very pretty 
and efficient hack. It should be probably reimplemented from scratch 
rather than ported. I think too much (journaling, ...) changed since then 
in ext3/4. But again, maybe I am completly wrong and those old bits of 
code could be made to work on newer kernels somehow.


Thanks,

Grzegorz Kulewski
