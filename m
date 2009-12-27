From: tytso@mit.edu
Subject: Re: 2.6.33-rc1: kernel BUG at fs/ext4/inode.c:1063 (sparc)
Date: Sun, 27 Dec 2009 17:52:16 -0500
Message-ID: <20091227225216.GB4429@thunk.org>
References: <a4423d670912241428n6917d2adsad887548612cf8ce@mail.gmail.com>
 <a4423d670912241449y2da43d5fi3e5a18c114b84178@mail.gmail.com>
 <87hbrfdylc.fsf@openvz.org>
 <a4423d670912251133u795338a4wd32d5cdef8c36c75@mail.gmail.com>
 <87eimir4yk.fsf@openvz.org>
 <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
	dmitry.torokhov@gmail.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZL0WwT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Dec 2009 17:52:19 -0500
Content-Disposition: inline
In-Reply-To: <a4423d670912271232y5bb928f7wb667ca71f1a93f8a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 27, 2009 at 11:32:25PM +0300, Alexander Beregalov wrote:
> >> I will try to crosscompile the kernel with Ted's patch on another host.
> 
> Here is output of 2.6.33-rc2 plus Ted's patch
> 
> EXT4-fs (sda1): inode #1387643: mdb_free (1) < mdb_claim (2) BUG

OK, can you give me the output of:

debugfs /dev/sda1
debugfs: stat <1387643>
debugfs: ncheck 1387643
debugfs: quit

Thanks!!

						- Ted
