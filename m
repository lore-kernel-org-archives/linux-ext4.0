From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: errors following ext3 to ext4 conversion
Date: Wed, 26 Aug 2015 22:43:45 -0500
Message-ID: <55DE8771.9050109@redhat.com>
References: <55DE5F79.4010004@yale.edu> <20150827033949.GA12151@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Chris Hunter <chris.hunter@yale.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbbH0Dns (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2015 23:43:48 -0400
In-Reply-To: <20150827033949.GA12151@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/26/15 10:39 PM, Theodore Ts'o wrote:

> Merely turning on the extents feature doesn't actually convert any
> files to use extents.  So if e2fsck is showing errors like this:
> 
>> e2fsck shows a variety of errors:
>> Pass 1: Checking inodes, blocks, and sizes
>> Inode 118843400, end of extent exceeds allowed value
>>         (logical block 1409, physical block 3803034390, len 976)
>> Inode 118843400, end of extent exceeds allowed value
>>         (logical block 2385, physical block 3803056554, len 4294966945)
> 
> This suggests that the file system was likely corrupted before you
> tried converting the file system, since there should not have been any
> extent-mapped files in an ext3 file system.

Hm, do we not require a freshly-fsck'd fs (tm) prior to a conversion attempt,
like we do (I think) for resize?

That might be a good idea ...

-Eric

