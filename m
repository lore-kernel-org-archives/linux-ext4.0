From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Sat, 04 Apr 2009 16:46:31 -0500
Message-ID: <49D7D537.50502@redhat.com>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com> <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZDDVqi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Apr 2009 17:46:38 -0400
In-Reply-To: <20090404212507.GC3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Apr 04, 2009  08:04 -0500, Eric Sandeen wrote:
>> And from another report, another user's zfs partition:
>>
>> # hexdump -C first_400K | grep "0c b1 07 b0 f5 02 00 00"
>> # hexdump -C first_400K | grep "00 00 02 f5 b0 07 b1 0c"
>> # hexdump -C first_400K | grep "0c b1 ba 00"
>> 00015e30  30 e8 ff ff 85 c0 5b 75  48 8b 06 35 0c b1 ba 00
>>
>> Should we be looking for 0x00babloc at offset 00015e30?
> 
> In probe.c I see the magic (that I've been assuming is correct, because
> it isn't really that easy to read):
> 
>   { "zfs",       8,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
>   { "zfs",       8,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },
>   { "zfs",     264,      0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c", probe_zfs },
>   { "zfs",     264,      0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0", probe_zfs },

Yep and that's different from the patch you originally submitted, Andreas...

> but looking at this I have no idea what this magic value is supposed
> to represent, from reading the ondiskformat0822.pdf (ZFS spec) document.

VDEV_BOOT_MAGIC ...

  333 /* ZFS boot block */
  334 #define VDEV_BOOT_MAGIC         0x2f5b007b10cULL

but I can't find much in that spec about where it's supposed to be, at
least from a very quick skim.

I'll let you IBM er... SUN guys sort it out  ;)

-Eric
