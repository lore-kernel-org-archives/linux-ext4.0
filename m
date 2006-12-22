From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] delayed allocation for ext4
Date: Fri, 22 Dec 2006 23:20:08 +0300
Message-ID: <m37iwjwumf.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: <linux-kernel@vger.kernel.org>, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppp85-141-207-24.pppoe.mtu-net.ru ([85.141.207.24]:35609 "EHLO
	gw.home.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752733AbWLVVJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Dec 2006 16:09:45 -0500
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Good day,

probably the previous set of patches (including mballoc/lg)
is too large. so, I reworked delayed allocation a bit so
that it can be used on top of regular balloc, though it
still can be used with extents-enabled files only.

this time series contains just 3 patches:

 - booked-page-flag.patch
   adds PG_booked bit to page->flags. it's used in delayed
   allocation to mark space is already reserved for page
   (including possible metadata)

 - ext4-block-reservation.patch
   this is scalable free space management. every time we
   delay allocation of some page, a space (including metadata)
   should be reserved

 - ext4-delayed-allocation.patch
   delayed allocation itself, enabled by "delalloc" mount option.
   extents support is also required. currently it works only
   with blocksize=pagesize.


all the patches can be used in ftp://ftp.clusterfs.com/pub/people/alex/2.6.20-rc1/

the series passed basic tests like dd/dbench/fsx.

any comments/questions are very welcome.

thanks, Alex
