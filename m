From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Sat, 03 Jan 2015 23:16:14 +0400
Message-ID: <87zj9zzncx.fsf@openvz.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org> <1417518054-21733-4-git-send-email-dmonakhov@openvz.org> <20141211200540.GE31008@thunk.org> <878uidgshe.fsf@openvz.org> <20141217035713.GW17575@thunk.org> <87y4q6joy4.fsf@openvz.org> <20141227153924.GC24553@thunk.org> <87tx0f7gel.fsf@openvz.org> <20141229041310.GE24553@thunk.org> <20150102200301.GC10927@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59687 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACTQR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Jan 2015 14:16:17 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so1115770wib.10
        for <linux-ext4@vger.kernel.org>; Sat, 03 Jan 2015 11:16:16 -0800 (PST)
In-Reply-To: <20150102200301.GC10927@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> On Sun, Dec 28, 2014 at 11:13:10PM -0500, Theodore Ts'o wrote:
>> On Sun, Dec 28, 2014 at 10:55:46PM +0400, Dmitry Monakhov wrote:
>> > Yes. I've already sent you updated patches
>> > https://patchwork.ozlabs.org/patch/422594/
>> > https://patchwork.ozlabs.org/patch/422595/
>> 
>> Thanks, this somehow got lost from my inbox.  I'm not sure how it
>> happened, but I do see it in patchwork.
>
> I tried applying both of these patches, but I'm still seeing a failure:
>
> % git log --oneline -2
> e195ba5 ext4: fix seek_data for indirect layout
> dd634e3 ext4: fix seek_data cleanup
>
> # uname -a
> Linux kvm-xfstests 3.18.0-rc3-00003-ge195ba5 #2548 SMP Fri Jan 2 14:35:32 EST 2015 i686 GNU/Linux
> # mke2fs -t ext4 -O ^extent,^flex_bg,^uninit_bg -Fq /dev/vdd
> /dev/vdd contains a ext4 file system
> 	 last mounted on /vdd on Fri Jan  2 14:49:58 2015
> # mount -t ext4 -o nodelalloc /dev/vdd /vdd
> # xfstests/src/seek_sanity_test  /vdd/seek_sanity_testfile
> File system magic#: 0xef53
> Allocation size: 4096
>
> ...
> 10. Test a huge file for offset overflow
> 10.01 SEEK_HOLE expected 65536 or 0, got 0.                       FAIL
> 10.02 SEEK_HOLE expected 65536 or 0, got 1.                       FAIL
> 10.03 SEEK_DATA expected 0 or 0, got -1.                          FAIL
> 10.04 SEEK_DATA expected 1 or 1, got -1.                          FAIL
> 10.05 SEEK_HOLE expected 0 or 0, got -65536.                      FAIL
> 10.06 SEEK_DATA expected -65536 or -65536, got -1.                FAIL
> 10.07 SEEK_DATA expected -65535 or -65535, got -1.                FAIL
> 10.08 SEEK_DATA expected -65536 or -65536, got -1.                FAIL
>
> I'm getting the exact same failure with a kernel compiled with
>
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_USE_FOR_EXT23=y
>
> and then using "mke2fs -t ext3 -Fq /dev/vdd" and "mount -t ext3
> /dev/vdd /vdd" and I'm seeing the same failure.  Which really worries
> me, since that's something that many more users will be using.
>
> At this point I'm beginning to think that we would be better off
> reverting 14516bb7bb6 until we can figure out what is going on.  I'm
> really wondering why you're not seeing this failure, but I am.
Crap. I do not understand why I cant not reproduce this.
I'm out of my normal dev environment for couple of days,
so patch reverting looks reasonable.  But please add code which
break the loop on signal because otherwise this result in DOS for huge file 
#touch file
#truncate -s 1T file
#./seek_hole file

>
>        		     	    	       	    - Ted
