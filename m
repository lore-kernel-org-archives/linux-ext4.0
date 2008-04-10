From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 compile error on m68k
Date: Thu, 10 Apr 2008 19:28:07 +0530
Message-ID: <20080410135807.GA7526@skywalker>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0804051345180.7216@anakin> <20080410104059.GA23116@skywalker> <je7if69bh4.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	zippel@linux-m68k.org, linux-ext4@vger.kernel.org,
	linux-m68k@vger.kernel.org
To: Andreas Schwab <schwab@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37374 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbYDJN6b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 09:58:31 -0400
Content-Disposition: inline
In-Reply-To: <je7if69bh4.fsf@sykes.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2008 at 01:48:55PM +0200, Andreas Schwab wrote:
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> writes:
> 
> > But m68k doesn't want to use the GENERIC_FIND_NEXT_BIT. Can I request
> > somebody knowledgeable about m68k to give a try in implementing
> > generic_find_next_le_bit  equivalent on m68k ?
> 
> What's the exact semantic of generic_find_next_le_bit?  Why is it not
> documented?
> 

Should be same  ext2_find_next_zero_bit except that it find the next
set bit rather than the zero bit. The API is used to find the set bit
in bitmap. To explain the little endian dependency, what we have is

0	x	n
[.......1.......]

Now we read this as (char *) and try to find the first set bit which
in the above example is x. To speed up most of the architectures would
like to consider it as an array of long. That implies that the value
in the array should be considered as a little endian long, hence the
*_le_bit.


-aneesh
