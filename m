From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Segmentation Faults with 062508 ext4-patch-queue snapshot
Date: Wed, 25 Jun 2008 23:14:10 -0500
Message-ID: <48631792.3040202@redhat.com>
References: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mingming <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbYFZEPR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jun 2008 00:15:17 -0400
In-Reply-To: <3.0.6.32.20080625135340.02423ed8@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Gary Hawco wrote:
> I redid my tests on the last few ext-patch-queue snapshots.
> 
> The snapshot:
> ext4-patch-queue-476b1104923c2228b48aee73070cddd5430b3b54.tar.gz from
> 062408 @2256hrs GMT works fine. No segfaults.
> 
> The latest snapshot:
> ext4-patch-queue-b5db22ef52ed53d8e3fa978a5a29e1609c9333aa.tar.gz from 
> 062508 @ 0019hrs GMT causes segmentation faults whenever I do extensive
> copying of small files (my Gentoo portage tree & metadata cache folders) to
> another ext4dev partition set up identically and then when I make a tarball
> from this copied data.
> 
> I have been able to reproduce the segfaults consistently. Both partitions
> were formatted with flex_bg & meta_bg features enabled (obviously no
> resize_inodes) and are set for ordered data mode.
> 
> I assume delalloc is enabled although ext4-patch-queue does not yet print
> message saying so on boot like mballoc does.
> 
> Any suggestions would be most appreciated.

Do you get kernel messages when this happens?  If so can you provide them?

Thanks,

-Eric
