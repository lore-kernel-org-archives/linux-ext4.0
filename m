From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Any qualms about reverting 3d0518f4, ext4: New rec_len encoding
 for very large blocksizes ?
Date: Tue, 03 Aug 2010 17:49:22 -0500
Message-ID: <4C589CF2.9030406@redhat.com>
References: <4C58987B.2040602@redhat.com> <38BC6435-5556-422C-BFA3-A964F6C6E6B9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Wei Yongjun <yjwei@cn.fujitsu.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0HCWt3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 18:49:29 -0400
In-Reply-To: <38BC6435-5556-422C-BFA3-A964F6C6E6B9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2010 05:44 PM, Andreas Dilger wrote:
> On 2010-08-03, at 16:30, Eric Sandeen wrote:
>> commit 3d0518f4758eca4339e75e5b9dbb7e06a5ce08b4 Author: Wei Yongjun
>> <yjwei@cn.fujitsu.com> Date:   Sat Feb 14 23:01:36 2009 -0500
>> 
>> ext4: New rec_len encoding for very large blocksizes
>> 
>> The rec_len field in the directory entry is 16 bits, so to encode 
>> blocksizes larger than 64k becomes problematic.  This patch allows
>> us to supprot block sizes up to 256k, by using the low 2 bits to
>> extend the range of rec_len to 2**18-1 (since valid rec_len sizes
>> must be a multiple of 4).  We use the convention that a rec_len of
>> 0 or 65535 means the filesystem block size, for compatibility with
>> older kernels.
>> 
>> It's a novel solution to the problem, but I'm not sure it's a
>> problem that needs to be solved today since we cannot even make
>> filesystems with
>>> 
>>> 64k blocks:
> 
> I don't object to reverting the > 64kB support, but we should strive
> to keep 64kB directory blocks working, if that is possibly going to
> break with reverting this patch.  I don't think any of the other extN
> code is expecting to handle block sizes larger than 64kB, so little
> value to do it just in the directory handling code.

As far as I know, reverting it won't break 64kb dir blocks...?

A simpler solution to the perf problem might be to just re-inline the
function, but I'm not sure what the point of all this is, as you say.

Thanks,
-Eric

>> Just for reference, the testing I did on RHEL6 was:
>> 
>> # bonnie++ -u root -s 0 -f -x 200 -d /mnt/test -n 32
>> 
>> (this does 200 iterations) and got this for the file creations:
>> 
>> ext4 stock:   Average = 21206.8 files/s
>> ext4 patched: Average = 22822.1 files/s
>> 
>> This is a 7.6% improvement...
> 
> Nothing to sneeze at.
> 
> Cheers, Andreas
