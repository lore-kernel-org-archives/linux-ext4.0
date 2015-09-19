From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Fix style and return NULL
Date: Fri, 18 Sep 2015 23:48:48 -0400
Message-ID: <20150919034848.GD2921@thunk.org>
References: <tytso@mit.edu>
 <1442613662-5100-1-git-send-email-bino@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Albino B Neto <bino@riseup.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59759 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbbISDsu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2015 23:48:50 -0400
Content-Disposition: inline
In-Reply-To: <1442613662-5100-1-git-send-email-bino@riseup.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2015 at 07:01:02PM -0300, Albino B Neto wrote:
> Line "if (!ext4_has_metadata_csum(sb))".
> 
> Second patch and sorry error.

Please don't try to correct "style" --- in fact, you've made things
worse, and in fact, you've introduced compile errors when tried to fix
"style".

You also apparently didn't bother to check and see if the patch
compiled correctly.  Please *do* try to make sure you have (a) tested
your patches to make sure that they compile, and (b) at the very
*minimum* tested your patch to make sure that any code paths you have
changed has been exercised.

In addition, it is highly preferable that for ext4 changes that you
have tested them using kvm-xfstests[1] or gce-xfstests[2] before
submitting a patch.  This may seem like a lot of extra work, but
unlike other parts of the kernel, if you just make the kernel crash,
it will annoy users --- but if you corrupt their data, they users tend
to get really steamed, so we have somewhat higher standards in file
system code.

Of course, if your changes cause the kernel to not even compile, users
aren't at risk of losing their data; but then you tend to annoy your
fellow kernel developers.  :-)

Best regards,

						- Ted

[1] https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/plain/quick-start?h=META
[2] https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/tree/kvm-xfstests/README.GCE
