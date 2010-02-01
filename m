From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: What represent 646345728 bytes
Date: Mon, 01 Feb 2010 11:34:42 -0600
Message-ID: <4B6710B2.9020701@redhat.com>
References: <7618835.18201265033304935.JavaMail.www@wsfrf1112> <871vh427qr.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: paul.chavent@fnac.net, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab0BARe6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Feb 2010 12:34:58 -0500
In-Reply-To: <871vh427qr.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K. V wrote:
> On Mon,  1 Feb 2010 15:08:24 +0100 (CET), <paul.chavent@fnac.net> wrote:
>> Hi
>>
>> I'am writing an application that write a stream of pictures of fixed size on a disk.
>>
>> My app run on a self integrated gnu/linux (based on a 2.6.31.6-rt19 kernel).
>>
>> My media is formated with
>>
>> # mke2fs -t ext4 -L DATA -O large_file,^has_journal,extent -v /dev/sda3
>> [...]
>>
>> And it is mounted with 
>>
>> # mount -t ext4 /dev/sda3 /var/data/
>> EXT4-fs (sda3): no journal
>> EXT4-fs (sda3): delayed allocation enabled
>> EXT4-fs: file extents enabled
>> EXT4-fs: mballoc enabled
>> EXT4-fs (sda3): mounted filesystem without journal
>>
>> My app opens the file with "O_WRONLY | O_CREAT | O_TRUNC | O_SYNC | O_DIRECT" flags.
>>
>> Each write takes ~4.2ms for 304K (it is very good since it is the write bandwidth of my hard drive). There is a write every 100ms.
>>
>> But every exactly 646345728 bytes, the write takes ~46ms.
> 
> I guess that would be balance_dirty_pages starting to writeback the
> delayed allocated pages. You can try if that changes by changing
> /proc/sys/vm/dirty_ratio

But he's doing direct IO...

-Eric
