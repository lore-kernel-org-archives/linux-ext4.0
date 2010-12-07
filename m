From: Chris Mason <chris.mason@oracle.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Tue, 7 Dec 2010 09:21:45 -0500
Message-ID: <20101207142145.GA27861@think>
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun@gmail.com,
	linux-ext4@vger.kernel.org, Jon Nelson <jnelson@jamponi.net>
To: Matt <jackdachef@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26230 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0LGOWO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Dec 2010 09:22:14 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 05, 2010 at 12:47:11AM +0100, Matt wrote:
> > OK.
> 
> meanwhile I think I got some interesting news:
> 
> after some time of running (around 1 to 1.5 hours) I noticed the
> following BUG with ext4:
> 
> [ 4421.503477] ------------[ cut here ]------------
> [ 4421.503482] kernel BUG at fs/ext4/inode.c:2714!
>
> kernel compiled was from sources checked out at
> 1de3e3df917459422cb2aecac440febc8879d410

Looking at 1de3e3df917459422cb2aecac440febc8879d410:

Line 2714 in fs/ext4/inode.c is this:

       /*
         * If the page does not have buffers (for whatever reason),
         * try to create them using block_prepare_write.  If this
         * fails, redirty the page and move on.
         */
        if (!page_buffers(page)) {
	^^^^^^^^^^^^^^^^^^^^^^^^^^^
                if (block_prepare_write(page, 0, len,
                                        noalloc_get_block_write)) {
                redirty_page:
                        redirty_page_for_writepage(wbc, page);
                        unlock_page(page);
                        return 0;
                }
                commit_write = 1;
        }

Which means we're really hitting this:

/* If we *know* page->private refers to buffer_heads */
#define page_buffers(page)                                      \
        ({                                                      \
                BUG_ON(!PagePrivate(page));                     \
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                ((struct buffer_head *)page_private(page));     \
        })
#define page_has_buffers(page)  PagePrivate(page)

Looks like Ted fixed it here:

commit b1142e8fec6a594723e5054055a7b53379b90490
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Oct 28 17:33:57 2010 -0400

    ext4: BUG_ON fix: check if page has buffers before calling page_buffers()


Basically, once you hit this oops, ext4 is done.  No files you created
after the oops will be there when you reboot, and the rest of your
lockups etc are because the jbd process had some locks held when it
crashed.

Was there also a report of corruption w/dm-crypt and XFS?

Last night I ran dm-crypt + the cpu scalability patch + ext4 +
2.6.37-rc3 in a long stress, and it passed without any problems.  If
dm-crypt were not doing the IO properly, this test probably would have
found it (+/- strange block sizes, races with O_DIRECT and other exotic
fun).

-chris

