From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 00:06:06 -0800
Message-ID: <20070216000606.08372d6f.akpm@linux-foundation.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
	<m3k5yj49bw.fsf@bzzz.home.net>
	<20070215125654.b0f18ab3.akpm@linux-foundation.org>
	<m3fy973z9w.fsf@bzzz.home.net>
	<20070215152352.6ddcfa92.akpm@linux-foundation.org>
	<m3sld636g0.fsf@bzzz.home.net>
	<20070215234640.d52e5908.akpm@linux-foundation.org>
	<m3hctm3588.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966176AbXBPIGp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 03:06:45 -0500
In-Reply-To: <m3hctm3588.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Feb 2007 10:56:55 +0300 Alex Tomas <alex@clusterfs.com> wrote:

> >>>>> Andrew Morton (AM) writes:
> 
>  AM> Well, one could just assume that the page has no disk mapping and go and
>  AM> make the space reservation.  Things will work out OK when we come to do
>  AM> writepage().
> 
>  AM> Or one could do both: call get_block() only if the page was inside i_size.
> 
> well, even so we need to reserve not that block ony, but
> also needed metadata (for the worst case).

Right.  Reserve all the blocks for the page and all the metadata for a page
at that file offset.  Worst case.

> probably this
> is work for get_block or some different method?

umm, when I did this I think I added a new ->reservepage address_space op
and called that from within the VFS's delalloc_prepare_write().

> anyway,
> we have to call it if the page is being written partial. 

Not necessarily.  If we're operating in nobh mode that page is brought
uptodate in prepare_write().
