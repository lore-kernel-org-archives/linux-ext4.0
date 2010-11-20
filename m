From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Garbage returned in nanosecond component of timestamps
Date: Sat, 20 Nov 2010 01:53:24 -0600
Message-ID: <4CE77E74.2070006@redhat.com>
References: <4CE76938.8050304@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jordan Russell <jr-list-2010@quo.to>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0KTHx2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Nov 2010 02:53:28 -0500
In-Reply-To: <4CE76938.8050304@quo.to>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/20/10 12:22 AM, Jordan Russell wrote:
> [Fedora 14 with vendor kernel 2.6.35.6-48.fc14.i686.PAE]
> 
> When nanosecond timestamp resolution isn't supported on an ext4
> partition (inode size = 128), stat() appears to be returning
> uninitialized garbage in the nanosecond component of timestamps.
> 
> See the following tests.
> Expected: All timestamps should end with '.0000000000'.
> Actual: '.0026721629' popping up on a different file each time.
> 
>> # tune2fs -l /dev/md0 | fgrep 'Inode size'
>> Inode size:               128
>> # echo 3 >/proc/sys/vm/drop_caches
>> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
>> Wed Nov  4 16:53:20.0026721629 2009 - /boot/oldconfigs/config-2.6.27.38-170.2.113.fc10.i686.PAE
>> # echo 3 >/proc/sys/vm/drop_caches
>> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
>> Thu Nov  8 20:38:30.0026721629 2007 - /boot/oldconfigs/config-2.6.23.1-49.fc8PAE
>> # echo 3 >/proc/sys/vm/drop_caches
>> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
>> Thu Aug 12 17:44:51.0026721629 2010 - /lib/firmware/emi26/bitstream.fw
>> # echo 3 >/proc/sys/vm/drop_caches
>> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
>> Thu Aug 12 17:44:51.0026721629 2010 - /lib/firmware/slicoss/gbdownload.sys
>> # echo 3 >/proc/sys/vm/drop_caches
>> # find / -xdev -type f -printf '%t - %p\n' | fgrep -v '.0000000000'
>> Fri Nov  5 01:16:32.0026721629 2010 - /boot/grub/e2fs_stage1_5
> 
> 
> Shouldn't EXT4_INODE_GET_XTIME zero out tv_nsec when EXT4_FITS_IN_INODE
> evaluates to false...?

Yep I think so, good catch...

-Eric

>> #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)                          \
>> do {                                                                           \
>>         (inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
>>         if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
>>                 ext4_decode_extra_time(&(inode)->xtime,                        \
>>                                        raw_inode->xtime ## _extra);            \
>> } while (0)
> 

