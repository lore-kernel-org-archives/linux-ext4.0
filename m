From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make ext4_has_inline_data() as a inline function
Date: Tue, 15 Jul 2014 10:08:52 -0400
Message-ID: <20140715140852.GA1491@thunk.org>
References: <1401709168-27403-1-git-send-email-wenqing.lz@taobao.com>
 <20140602145631.GD30598@thunk.org>
 <20140604071111.GA19191@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Ian Nartowicz <claws@nartowicz.co.uk>,
	Tao Ma <tm@tao.ma>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35928 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaGOOJG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2014 10:09:06 -0400
Content-Disposition: inline
In-Reply-To: <20140604071111.GA19191@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2014 at 03:11:11PM +0800, Zheng Liu wrote:
> Now ext4_has_inline_data() is used in wide spread codepaths.  So we need
> to make it as a inline function to avoid burning some CPU cycles.
> 
> text size (bytes):
> vanilla: 10350562
> patched: 10384933 (+0.33%)

This represents a difference of 34k, which was over 10% the text size
of ext4.o --- so this surprised me greatly.  I just did my own
testing, and difference I see is 117 bytes:

         text	  data	    bss     dec	    hex	filename
before: 326110	  19258	   5528	 350896	  55ab0	fs/ext4/ext4.o
after:  326227	  19258	   5528	 351013	  55b25	fs/ext4/ext4.o

So I'm going to adjust the patch include these numbers, which are much
less likely to cause embedded people to complain about a large
increase in code bloat.  :-)

Thanks, applied.

					- Ted
