From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [RFC] delayed allocation for ext4
Date: Sat, 23 Dec 2006 22:15:43 +0300
Message-ID: <m3vek2todc.fsf@bzzz.home.net>
References: <m37iwjwumf.fsf@bzzz.home.net>
	<20061223033123.GL44411608@melbourne.sgi.com>
	<20061223092718.GA26276@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Alex Tomas <alex@clusterfs.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppp85-141-207-24.pppoe.mtu-net.ru ([85.141.207.24]:37026 "EHLO
	gw.home.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753683AbWLWTP5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Dec 2006 14:15:57 -0500
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20061223092718.GA26276@infradead.org> (Christoph Hellwig's
	message of "Sat\, 23 Dec 2006 09\:27\:18 +0000")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Christoph Hellwig (CH) writes:

 CH> Note that recording delayed alloc state at a page granularity in addition
 CH> to just the buffer heads has a lot of advantages aswell and would help
 CH> xfs, too.  But I think it makes a lot more sense to record it as a radix
 CH> tree tag to speed up the gang lookups for delalloc conversion.

please, exaplein about radix tree tag. in ext4-delalloc I use this
bit the only way - to avoid multiple reservation space for same
page. I guess you need to find non-allocated pages. probably to
flush them and update number of reserved blocks in case of -ENOSPC?

thanks, Alex
