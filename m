From: Johannes Bauer <dfnsonfsduifb@gmx.de>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Tue, 4 Oct 2016 23:54:24 +0200
Message-ID: <26892620-eac1-eed4-da46-da9f183d52b1@gmx.de>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
 <20161004084136.GD17515@quack2.suse.cz>
 <90dfe18f-9fe7-819d-c410-cdd160644ab7@gmx.de>
 <2b7d6bd6-7d16-3c60-1b84-a172ba378402@gmx.de>
 <CABYiri-UUT6zVGyNENp-aBJDj6Oikodc5ZA27Gzq5-bVDqjZ4g@mail.gmail.com>
 <087b53e5-b23b-d3c2-6b8e-980bdcbf75c1@gmx.de>
 <CABYiri_3qS6XgT04hCeF1AMuxY6W0k7QVEO-N0ZodeJTdG=xsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
To: Andrey Korolyov <andrey@xdel.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60671 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbcJDVyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Oct 2016 17:54:33 -0400
In-Reply-To: <CABYiri_3qS6XgT04hCeF1AMuxY6W0k7QVEO-N0ZodeJTdG=xsw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04.10.2016 22:17, Andrey Korolyov wrote:
>> I'm super puzzled right now :-(
>>
> 
> There are three strawman` ideas out of head, down by a level of
> naiveness increase:
> - disk controller corrupts DMA chunks themselves, could be tested
> against usb stick/sd card with same fs or by switching disk controller
> to a legacy mode if possible, but cascading failure shown previously
> should be rather unusual for this,

I'll check out if this is possible somehow tomorrow.

> - SMP could be partially broken in such manner that it would cause
> overlapped accesses under certain conditions, may be checked with
> 'nosmp',

Unfortunately not:

  CC [M]  drivers/infiniband/core/multicast.o
  CC [M]  drivers/infiniband/core/mad.o
drivers/infiniband/core/mad.c: In function ‘ib_mad_port_close’:
drivers/infiniband/core/mad.c:3252:1: internal compiler error: Bus error
 }
 ^

nuc [~]: cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.8.0 root=UUID=f6a792b3-3027-4293-a118-f0df1de9b25c
ro ip=:::::eno1:dhcp nosmp

> - disk accesses and corresponding power spikes are causing partial
> undervoltage condition somewhere where bits are relatively freely
> flipping on paths without parity checking, though this could be
> addressed only to an onboard power distributor, not to power source
> itself.

Huh that sounds like "defective hardware" to me, wouldn't it?

Cheers and thank you for your help,
Johannes

