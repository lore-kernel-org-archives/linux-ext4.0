From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: FAST paper on ffsck
Date: Thu, 30 Jan 2014 00:09:07 +0400
Message-ID: <CAG5DWogJ5kjKJ8-B8DLWUU7Kp-vWdFxoQSdGOgcsh1OJMDNxSA@mail.gmail.com>
References: <20131209180149.GA6096@thunk.org>
	<20140129185741.GA8798@birch.djwong.org>
	<CAG5DWogJ5SiBfpK6k-_4gB-Roea-F+KWTnDm8xRF1Sf-vmOFFw@mail.gmail.com>
	<20140129194022.GC30419@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59267 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaA2UJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jan 2014 15:09:08 -0500
Received: by mail-qc0-f180.google.com with SMTP id i17so3597058qcy.11
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jan 2014 12:09:08 -0800 (PST)
In-Reply-To: <20140129194022.GC30419@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 29, 2014 at 11:40 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Jan 29, 2014 at 11:21:07PM +0400, Azat Khuzhin wrote:
>>
>> Workload: there are _many_ files that don't deleted, append/full
>> rewrite/create only, lifetime 1-2 years:
>>
>>      8988871 inodes used (2.09%, out of 429817856)
>>      1012499 non-contiguous files (1.7%)
>>         2039 non-contiguous directories (0.0%)
>>              # of inodes with ind/dind/tind blocks: 0/0/0
>>              Extent depth histogram: 8616444/372389/30
>> # about 99% blocks in use wrong information, I shrinked fs before
>> this, to minimal size
>
>
> Shrinking the file system is known to result in really horrible
> fragmentation.  Part of this is because resize2fs has a really stupid
> block allocator, but if you're going to shrink the file system to
> minimal size the results can be truly catastrophic from a file
> fragmentation point of view.  (Imagine my horror when I was told that
> Fedora was creating bootable CD-ROM's by creating a large file system
> image, and then using resize2fs -M to shink it to minimal size.  Not
> only would the file layout be definitely non-optimal, but worse,
> CD-ROM drives are not know for fast seek times!)

Thanks, good to know.
Anyway, that fs already not used, it was once for migration,
and on new fs most of files already rewritten.

>
> We can probably make resize2fs smarter in the case where we are
> shrinking the file system slightly (say, to make room for LVM /thinp
> metadata when coverting a whole disk file system to one which is being
> managed via LVM).  But I'm not sure it's ever going to be worth it
> making resize2fs -M generate an optimal, minimally fragmented file
> system image.
>
>                                          - Ted



-- 
Respectfully
Azat Khuzhin
