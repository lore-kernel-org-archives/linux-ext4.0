From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: delalloc is crippling fs_mark performance
Date: Sat, 19 Jul 2008 10:44:34 -0500
Message-ID: <48820BE2.6080800@redhat.com>
References: <4880C0B2.9040706@redhat.com> <4881207C.1040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYGSPog (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Jul 2008 11:44:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6JFiat7005620
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 11:44:36 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6JFia78011170
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 11:44:36 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6JFiYSN012876
	for <linux-ext4@vger.kernel.org>; Sat, 19 Jul 2008 11:44:35 -0400
In-Reply-To: <4881207C.1040004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> running fs_mark like this:
>>
>> fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0
>>
>> (256 subdirs, 100000 files/iteration, 4 threads, 20k files, no sync)
>>
>> on a 1T fs, with and without delalloc (mount option), is pretty interesting:
>>
>> http://people.redhat.com/esandeen/ext4/fs_mark.png
>>
>> somehow delalloc is crushing performance here.  I'm planning to wait
>> 'til the fs is full and see what the effect is on fsck, and look at the
>> directory layout for differences compared to w/o delalloc.
>>
>> But something seems to have gone awry here ...
>>
>> This is on 2.6.26 with the patch queue applied up to stable.
>>
>> -Eric
> 
> I oprofiled both with and without delalloc for the first 15% of the fs fill:
> 
> ==> delalloc.op <==
> CPU: AMD64 processors, speed 2000 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a
> unit mask of 0x00 (No unit mask) count 100000
> samples  %        image name               app name
> symbol name
> 56094537 73.6320  ext4dev.ko               ext4dev
> ext4_mb_use_preallocated
> 642479    0.8433  vmlinux                  vmlinux
> __copy_user_nocache
> 523803    0.6876  vmlinux                  vmlinux                  memcmp
> 482874    0.6338  jbd2.ko                  jbd2
> do_get_write_access
> 480687    0.6310  vmlinux                  vmlinux
> kmem_cache_free
> 403604    0.5298  ext4dev.ko               ext4dev
> str2hashbuf
> 400471    0.5257  vmlinux                  vmlinux
> __find_get_block
> 
> ==> nodelalloc.op <==
> CPU: AMD64 processors, speed 2000 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a
> unit mask of 0x00 (No unit mask) count 100000
> samples  %        image name               app name
> symbol name
> 56167198 56.8949  ext4dev.ko               ext4dev
> ext4_mb_use_preallocated

This was wrong, I forgot to clear stats before re-running.

With delalloc, the lg_prealloc list seems to just grow & grow in
ext4_mb_use_preallocated, searching up to 90,000 entries before finding
something, I think this is what's hurting - I need to look into how this
should work.

-Eric
