From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Race condition in ext4 (was Re: 4.11-rc1 acpi stomping ext4
 slabs)
Date: Wed, 8 Mar 2017 20:58:48 -0500
Message-ID: <20170309015848.42fipjxkxjvu7gkl@thunk.org>
References: <86f1c7af-0d74-f1fd-e1fb-cc2302824e27@gmail.com>
 <CAJZ5v0h47dTwpOPJfzyM41YaS8u3es83wh7xtJ3fxn1cKbuELA@mail.gmail.com>
 <507b9b64-798b-d542-8169-17738c405aad@gmail.com>
 <1018b7d9-2566-c0f2-bef7-8274617facd6@gmail.com>
 <f94d78dc-1424-2f92-0381-ea706fe8802c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50638 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdCICgd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 8 Mar 2017 21:36:33 -0500
Content-Disposition: inline
In-Reply-To: <f94d78dc-1424-2f92-0381-ea706fe8802c@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 07, 2017 at 10:40:53PM +0200, Nikolay Borisov wrote:
> So this is wrong, the reason why the issues seemed fix is because I
> switched my compiler to version 5.4.0. So this manifests only if I'm
> using gcc 4.7.4. With the pr_info added here is the output of a boot. So
> there are multiple invocations of ext4_ext_map_blocks and the freeing,
> including with the address being used in subsequent kasan reports :
> ffff88006ae8fdb0

Can you help bisect this, then?  I'm using Debian Testing, and the
default gcc is gcc 6.3.0.  I'm currently forcing the use of gcc 5.4.1
because I was running into problems with gcc 6.x a while back.  (TBH,
I was thinking about trying to see if gcc 6.3 was stable for kernel
compiles when I had some spare time.)  But I don't have access to
*any* gcc 4.x on my development system, and I don't think I've tried
using gcc 4.x in a long, Long, LONG time.

I'm currently kicking off a test run using 5.4.1 with KASAN enabled to
see if I can trigger it myself.  Can you send me a copy of your
.config so I can see what else might be interesting with your config?
(e.g., SLAB vs SLUB, etc.)

Thanks,

	     	     	       - Ted
