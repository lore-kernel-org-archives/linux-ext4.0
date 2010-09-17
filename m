From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RESEND][PATCH][BUG] ext4: fix infinite loop at ext4_da_writepages
 with the terminal extent block of too big file
Date: Fri, 17 Sep 2010 08:47:39 -0500
Message-ID: <4C93717B.2020401@redhat.com>
References: <20100917143556.bb9c303a.toshi.okajima@jp.fujitsu.com> <87aangepgg.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0IQNsJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Sep 2010 09:48:09 -0400
In-Reply-To: <87aangepgg.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> writes:
> 
>> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>>
>> On linux-2.6.36-rc2, if we execute the following script, we can encounter 
>> the hangup of '/bin/sync' command:
>> ================================================================================
>> #!/bin/sh
>>
>> echo -n "HANG UP TEST: "
>> /bin/dd if=/dev/zero of=/tmp/img bs=1k count=1 seek=1M 2> /dev/null
>> /sbin/mkfs.ext4 -Fq /tmp/img
>> /bin/mount -o loop -t ext4 /tmp/img /mnt
>> /bin/dd if=/dev/zero of=/mnt/file bs=1 count=1 \
>> seek=$((16*1024*1024*1024*1024-4096)) 2> /dev/null
>> /bin/sync
>> /bin/umount /mnt
>> echo "DONE"
>> exit 0
> On older kernels this testcase result in BUG_ON triggering
> at fs/ext4/mballoc.c:3229 ext4_mb_normalize_request()

If anyone feels up to the task, extending xfstest 071
("# Exercise IO at large file offsets.") to work on generic kernels,
it would have caught this earlier.  It needs work, however, configure
expected max offsets for various filesystems...

-Eric
