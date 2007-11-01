From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc fragmenting files?
Date: Thu, 01 Nov 2007 10:20:18 -0500
Message-ID: <4729EEB2.9090406@redhat.com>
References: <47225B1E.2060708@redhat.com> <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com> <47291F62.3000008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbXKAPUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2007 11:20:23 -0400
In-Reply-To: <47291F62.3000008@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> please, try the patch attached.

Looks quite a bit better:

http://people.redhat.com/esandeen/seekwatcher/ext4-alex.png
http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-dd-write.png
http://people.redhat.com/esandeen/seekwatcher/ext4-alex-ext4-xfs-dd-write.png

It is much less fragmented, although still not exactly the nice linear
allocation I'd expect from a single threaded large write on a fresh fs...

-Eric

> thanks, Alex
> 
> Eric Sandeen wrote:
>> One thing that seems to be happening is that thanks to delalloc, a nice
>> big request is coming in (only 1036 blocks of the 4096, not quite sure
>> why), but then it gets into ext4_mb_normalize_request(), which finds the
>> most blocks it can "preallocate" is 256, and chops down the request to
>> 256 blocks.  Shouldn't this preallocation be over & above what was asked
>> for, vs. reducing the request?
>>
>> Ok, so, we get allocations in 256-block chunks...  Why they don't all
>> come out contiguous, I don't know yet...
>>
>> -Eric
> 
