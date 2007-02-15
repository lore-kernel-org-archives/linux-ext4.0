From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: booked-page-flag.patch
Date: Thu, 15 Feb 2007 15:23:52 -0800
Message-ID: <20070215152352.6ddcfa92.akpm@linux-foundation.org>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com>
	<m3k5yj49bw.fsf@bzzz.home.net>
	<20070215125654.b0f18ab3.akpm@linux-foundation.org>
	<m3fy973z9w.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38478 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422702AbXBOXYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 18:24:42 -0500
In-Reply-To: <m3fy973z9w.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 16 Feb 2007 00:07:55 +0300
Alex Tomas <alex@clusterfs.com> wrote:

> >>>>> Andrew Morton (AM) writes:
> 
>  AM> If the page doesn't have buffer-heads, set PG_private and clear page->private
> 
>  AM> If the page does have buffer_heads, use BH_Delay.
> 
> I did exactly this way in the first version, but later
> got feeling that the community'd discard "ugly hack".

These things can be wrapped in nice helper functions in header files.  that
allows us to easily reimplement if a better idea comes along.

And we already do all sorts of horrid things to save space in the page
struct.

> one more question: how much of it you want in VFS?

As much as possible, really.  It's probably too late for XFS to reuse any
new infrastructure, but if the infrastructure is well-designed it _should_
be possible to us it in new filesytems, and to convert ext2.

> ->get_block(with BH_Delay) can be used to signal
> filesystem that no actual allocation is required.
> so, aware filesystem can just reserve space. then
> ->writepages() should walk through the pages like
> it does currently, collect contiugous sequences
> and again call ->get_block(w/o BH_Delay) with b_size
> covering all contiguous pages ...
> 

That sounds like it'd work, yes.

Except for an address_space which is using delayed allocation, its
->prepare_write wouldn't call get_block at all, so perhaps that isn't
needed.
