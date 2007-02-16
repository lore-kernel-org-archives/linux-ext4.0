From: Alex Tomas <alex@clusterfs.com>
Subject: Re: booked-page-flag.patch
Date: Fri, 16 Feb 2007 10:56:55 +0300
Message-ID: <m3hctm3588.fsf@bzzz.home.net>
References: <20070215004504.023a90f0.akpm@linux-foundation.org>
	<45D495EA.3060200@redhat.com> <m3k5yj49bw.fsf@bzzz.home.net>
	<20070215125654.b0f18ab3.akpm@linux-foundation.org>
	<m3fy973z9w.fsf@bzzz.home.net>
	<20070215152352.6ddcfa92.akpm@linux-foundation.org>
	<m3sld636g0.fsf@bzzz.home.net>
	<20070215234640.d52e5908.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.245.246] ([80.71.245.246]:56431 "EHLO nsold.rialcom.ru"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966180AbXBPH4x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Feb 2007 02:56:53 -0500
In-Reply-To: <20070215234640.d52e5908.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu\, 15 Feb 2007 23\:46\:40 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Andrew Morton (AM) writes:

 AM> Well, one could just assume that the page has no disk mapping and go and
 AM> make the space reservation.  Things will work out OK when we come to do
 AM> writepage().

 AM> Or one could do both: call get_block() only if the page was inside i_size.

well, even so we need to reserve not that block ony, but
also needed metadata (for the worst case). probably this
is work for get_block or some different method? anyway,
we have to call it if the page is being written partial. 

thanks, Alex
