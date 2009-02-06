From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090206: deadlock on ext4
Date: Fri, 6 Feb 2009 21:04:08 +0300
Message-ID: <a4423d670902061004i424817e1vd699a61e335f010a@mail.gmail.com>
References: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>
	 <498C7671.1050309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:37294 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZBFSEK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Feb 2009 13:04:10 -0500
In-Reply-To: <498C7671.1050309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/2/6 Eric Sandeen <sandeen@redhat.com>:
> Alexander Beregalov wrote:
>> Hi
>>
>> I run dbench on ext4 on loop device.
>>
>> EXT4-fs: barriers enabled
>> kjournald2 starting: pid 2420, dev loop0:8, commit interval 5 seconds
>> EXT4 FS on loop0, internal journal on loop0:8
>> EXT4-fs: delayed allocation enabled
>> EXT4-fs: file extents enabled
>> EXT4-fs: mballoc enabled
>> EXT4-fs: mounted filesystem loop0 with ordered data mode
>> JBD: barrier-based sync failed on loop0:8 - disabling barriers
>>
>> INFO: task pdflush:2339 blocked for more than 120 seconds.
>
> Looks a lot like a bug I filed:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=12579
>
> but I'm having trouble reproducing it, now.  I'll try dbench!
Yes, I can reproduce it easy with dbench.
