From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 23:46:40 -0800
Message-ID: <20070215234640.d52e5908.akpm@linux-foundation.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
	<m3k5yj49bw.fsf@bzzz.home.net>
	<20070215125654.b0f18ab3.akpm@linux-foundation.org>
	<m3fy973z9w.fsf@bzzz.home.net>
	<20070215152352.6ddcfa92.akpm@linux-foundation.org>
	<m3sld636g0.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbXBPHrU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 02:47:20 -0500
In-Reply-To: <m3sld636g0.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Feb 2007 10:30:39 +0300 Alex Tomas <alex@clusterfs.com> wrote:

> >>>>> Andrew Morton (AM) writes:
> 
>  -> get_block(with BH_Delay) can be used to signal
>  >> filesystem that no actual allocation is required.
>  >> so, aware filesystem can just reserve space. then
>  -> writepages() should walk through the pages like
>  >> it does currently, collect contiugous sequences
>  >> and again call ->get_block(w/o BH_Delay) with b_size
>  >> covering all contiguous pages ...
>  >> 
> 
>  AM> That sounds like it'd work, yes.
> 
>  AM> Except for an address_space which is using delayed allocation, its
>  -> prepare_write wouldn't call get_block at all, so perhaps that isn't
>  AM> needed.
> 
> hmm. I thought it has to call get_block() at least to know whether
> the block is already allocated. and I was going to reserve space
> in prepare_write for which some fs-specific method is needed becase
> only fs knows how much metadata it'd need.

Well, one could just assume that the page has no disk mapping and go and
make the space reservation.  Things will work out OK when we come to do
writepage().

Or one could do both: call get_block() only if the page was inside i_size.
