From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Fri, 28 May 2010 21:21:03 -0500
Message-ID: <4C007A0F.6020304@jaysonking.com>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout19.eigbox.net ([66.96.184.19]:47454 "EHLO
	bosmailout19.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0E2Cwc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 22:52:32 -0400
In-Reply-To: <4C0070D8.8060500@jaysonking.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 08:41 PM, Jayson R. King wrote:
> On 05/28/2010 07:49 PM, tytso@mit.edu wrote:
>> This doesn't fix a bug; it's to make it easy for Dave Chinner to make
>> some changes to fix XFS's performance and to undo some ext4-specific
>> changes to write_cache_pages(). I'm not sure there's a good reason to
>> backport this to 2.6.27.y....
>
> The difference is that, 2.6.27's write_cache_pages() in page-writeback.c
> still updates wbc->nr_to_write, since the patch which changed that
> behavior was dropped from .27-rc2 due to the XFS regression it causes on
> mainline.

I meant, it was dropped from .27.47-rc2 stable. Sorry for any confusion.

> ext4 appears to want the behavior of write_cache_pages which
> does not update wbc->nr_to_write. This write_cache_pages_da() does what
> ext4 wants, without introducing the XFS regression. So I believe it is
> needed.
>
> Did I mis-judge?
>
> Rgds,
>
> Jayson
>
