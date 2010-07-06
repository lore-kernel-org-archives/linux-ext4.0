From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: extent counting fun
Date: Mon, 05 Jul 2010 19:50:08 -0500
Message-ID: <4C327DC0.4070305@redhat.com>
References: <4C323184.8020401@redhat.com> <AF4CA4E6-4ADE-41E3-843D-02266228E2CB@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267Ab0GFAuO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jul 2010 20:50:14 -0400
In-Reply-To: <AF4CA4E6-4ADE-41E3-843D-02266228E2CB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2010-07-05, at 13:24, Eric Sandeen wrote:
>> [root@host ~]# filefrag -B /mnt/test/file
>> /mnt/test/file: 34 extents found
>> [root@host ~]# filefrag /mnt/test/file
>> /mnt/test/file: 1058 extents found, perfection would be 1 extent
>>
>> Hum, is it 34 or 1058? :)
> 
> What do the extents look like on disk?  Is this just because it is running on a block-mapped file and is skipping a singleton block periodically for indirect blocks, or is there a bug in the way the extents are being reported?

Well, I didn't actually look but I'm 98% sure it's just because it's
not reporting the interspersed metadata blocks.

Sorry, above was on ext3, that wasn't clear, just a stock dd-streamed
file.

>> Older filefrag counted contiguous metadata as part of a contiguous
>> extent... newer filefrag works in fiemap query-only mode by default,
>> and just takes what fiemap tells it.  The inconsistency is weird
>> though, and led to a Red Hat bug that I'm inclined to NOTABUG... but
>> do people think this needs to be made any more consistent?
>>
>> Should we hack ext3_fiemap() to include the checks for contiguous
>> metadata?  Or was that too shady/clever to start with ...? :)
> 
> I wouldn't object to having FIEMAP add a flag for metadata blocks.  I've always thought it would be useful to be able to query/dump metadata blocks (e.g. indirect/index blocks) and the inode itself.

Hm don't we have that already?

Hmm... just xattr I guess.

In any case it's still a question of whether ext3 extent count should
be "fudged" to make blocks separated by metadata look contiguous
or not ...

-Eric

> Cheers, Andreas
> 
> 
> 
> 
> 

