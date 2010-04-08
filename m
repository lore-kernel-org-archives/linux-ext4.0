From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: "data=writeback" and TRIM don't get along
Date: Thu, 08 Apr 2010 11:17:27 +0400
Message-ID: <8739z6v2ew.fsf@openvz.org>
References: <4BBD285B.9000603@gmail.com> <4BBD2FDF.4040407@redhat.com>
	<4BBD3365.90306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:3397 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758411Ab0DHHR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 03:17:57 -0400
In-Reply-To: <4BBD3365.90306@gmail.com> (Nebojsa Trpkovic's message of "Thu,
	08 Apr 2010 03:37:41 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nebojsa Trpkovic <trx.lists@gmail.com> writes:

> On 04/08/10 03:22, Eric Sandeen wrote:
>> How does it fail?
>> 
>> Surely a bug.  :)  If you can provide details we'll look into it.
>> (perhaps it's obvious on first try but still worth saying exactly
>> what problematic behavior you saw, when reporting a bug you
>> encountered)
>
> Well, I've done a simple test, described like:
>
> "get the used sectors for a file
> hdparm --fibmap filename
> read a sector from the file eg. with
> sudo hdparm --read-sector 66385920 /dev/sda
> delete the file and sync
> rm filename;sync
> and read the sector a second time"
>
>
> And I get something like this:
>
> ================================
> # dd if=/dev/urandom of=tempfile count=100 bs=512k oflag=direct
> 100+0 records in
> 100+0 records out
> 52428800 bytes (52 MB) copied, 6.47137 s, 8.1 MB/s
>
> # hdparm --fibmap tempfile
>
> tempfile:
>  filesystem blocksize 4096, begins at LBA 0; assuming 512 byte sectors.
>  byte_offset  begin_LBA    end_LBA    sectors
>            0   37094400   37196799     102400
>
> # hdparm --read-sector 37094400 /dev/sdb
>
> /dev/sdb:
> reading sector 37094400: succeeded
> b0e8 3ad7 d080 84e8 b4b2 7e60 21f1 eff3
> 0ef9 fa10 b172 89f8 186f 0194 4cb1 e190
> d6b5 b2fe 2577 5dba e6f2 5ad7 34a0 f09f
> ca5c 07ef 6e86 c3a8 9e77 77f3 78ff 672f
> af71 dea7 ac23 a55d e31e ff83 164e bb76
> 8ea4 416d 343a 9f5e b41f b1d0 b6e9 6ed8
> 90c0 3cba ec07 1d96 fdd6 3940 1290 7cd2
> c506 c3ee c120 3732 17eb 6e68 11aa 721c...
>
> # rm tempfile
> # sync
> ================================
>
> Now, if I have "data=writeback" enable and I run
> # hdparm --read-sector 37094400 /dev/sdb
> again, I'll get the same random bytes.
> Reboot doesn't help.
>
> If I disable "data=writeback" and run
> # hdparm --read-sector 37094400 /dev/sdb
> I'll get all zeroes:
> ================================
> # hdparm --read-sector 37094400 /dev/sdb
>
> /dev/sdb:
> reading sector 37094400: succeeded
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> ...
> ================================
>
> So, TRIM command works well, but not with "data=writeback" mount option.
>
> Other info:
>
> Intel X25-V 40GB (latest firmware)
can you please provide an actual version of firmware.
As soon as i know X25 zeroing was disabled.
Can you please post an output of your queue flags 
cat /sys/block/sdXXX/queue/discard_zeroes_data 
>
> Linux box 2.6.33-gentoo #4 SMP Sat Apr 3 05:02:04 CEST 2010 x86_64
> Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz GenuineIntel GNU/Linux
>
>
> Nebojsa
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
