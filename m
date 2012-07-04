From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_fallocate
Date: Wed, 04 Jul 2012 08:20:07 -0400
Message-ID: <4FF434F7.2070906@redhat.com>
References: <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <20120702031611.GB2406@gmail.com> <4FF1CD5D.8010904@redhat.com> <20120702174421.GM6679@quack.suse.cz> <4FF39924.7070602@ubuntu.com> <20120704023634.GB16947@gmail.com> <4FF3B352.3040707@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
	wenqing.lz@taobao.com
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2GDMUW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2012 08:20:22 -0400
In-Reply-To: <4FF3B352.3040707@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/03/2012 11:06 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 07/03/2012 10:36 PM, Zheng Liu wrote:
>> Actually the workload needs to flush the data after writting a small
>> random bits.  This workload is met in our product system at Taobao.
>> Thus, the application has to wait this write to be done.  Certainly if
>> we don't flush the data, the problem won't happen but there is a risk
>> that we could loss our data.
> Ohh, I see now... you want lots of small, random, synchronous writes.  Then I think the only way to avoid the metadata overhead is with the unsafe stale data patch.  More importantly, this workload is going to have terrible performance no matter what the fs does, because even with all of the blocks initialized, you're still doing lots of seeking and not allowing the IO elevator to help.  Maybe the application can be redesigned so that it does not generate such pathological IO?
>
> Or is this another case of userspace really needing access to barriers rather than using the big hammer of fsync?
>
> Is there any technical reason why a barrier flag can't be added to the aio interface?

For reasonably sized files, you might just as well really write out the full 
file with "write" (do pre-allocation the old fashioned way).

Performance of course depends on the size of the file, but for a 1GB file you 
can do this in a few seconds and prevent fragmentation and totally eliminate the 
performance of flipping extents.

How large is the file you need to pre-allocate? How long does the job typically 
run (minutes? hours? days?) :)

ric


