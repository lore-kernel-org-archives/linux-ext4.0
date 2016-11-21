From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: sanity check the block and cluster size at
 mount time
Date: Mon, 21 Nov 2016 10:24:10 -0500
Message-ID: <20161121152410.inqbocgogeuy2g2i@thunk.org>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
 <955b7ea8-2fb2-a958-bb8a-5b5003668765@kyup.com>
 <20161118175838.q67hqgjdtydnl22f@thunk.org>
 <CAJFSNy62erBHU6vr2ubO0BXLjCK=xOVJWaq+C=X6PYuHTWoNjg@mail.gmail.com>
 <20161119023603.ujqj6r4yudkmu5vg@thunk.org>
 <141f9598-225e-f1c0-3897-fce5c0a7cd81@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, stable@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36696 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbcKUPYR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Nov 2016 10:24:17 -0500
Content-Disposition: inline
In-Reply-To: <141f9598-225e-f1c0-3897-fce5c0a7cd81@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 21, 2016 at 09:46:45AM +0200, Nikolay Borisov wrote:
> 
> So I downloaded the image again and tested and it indeed doesn't
> reproduce. However, testing with the same image, but downloaded
> couple of days ago I can still reproduce this. The checksums of both
> images differ though. The freshly downloaded has the same checksum
> as your whereas my earlier download of it doesn't. All of this
> without 4/4 being applied.
> 
> With patch 4/4 applied I can actually mount my "earlier" image which
> was causing a crash even with your other patches applied:
> 

Just for the record, can you send me a copy of the older image?  I
just want to be sure I understand what was going on.

Thanks!!

					- Ted
