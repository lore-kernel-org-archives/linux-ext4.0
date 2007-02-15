From: Alex Tomas <alex@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 00:07:55 +0300
Message-ID: <m3fy973z9w.fsf@bzzz.home.net>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com> <m3k5yj49bw.fsf@bzzz.home.net>
	<20070215125654.b0f18ab3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:59517 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161297AbXBOVHz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Feb 2007 16:07:55 -0500
In-Reply-To: <20070215125654.b0f18ab3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu\, 15 Feb 2007 12\:56\:54 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> If the page doesn't have buffer-heads, set PG_private and clear page->private

 AM> If the page does have buffer_heads, use BH_Delay.

I did exactly this way in the first version, but later
got feeling that the community'd discard "ugly hack".

one more question: how much of it you want in VFS?

->get_block(with BH_Delay) can be used to signal
filesystem that no actual allocation is required.
so, aware filesystem can just reserve space. then
->writepages() should walk through the pages like
it does currently, collect contiugous sequences
and again call ->get_block(w/o BH_Delay) with b_size
covering all contiguous pages ...

thanks, Alex
