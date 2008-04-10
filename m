From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 compile error on m68k
Date: Thu, 10 Apr 2008 16:11:32 +0530
Message-ID: <20080410104059.GA23116@skywalker>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0804051345180.7216@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	zippel@linux-m68k.org, linux-ext4@vger.kernel.org,
	linux-m68k@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:35106 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYDJKmI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 06:42:08 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804051345180.7216@anakin>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 05, 2008 at 01:48:02PM +0200, Geert Uytterhoeven wrote:
> On Sat, 5 Apr 2008, Adrian Bunk wrote:
> > Commit aa02ad67d9b308290fde390682cd039b29f7ab85
> > "ext4: Add ext4_find_next_bit()" causes the following regression:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  fs/ext4/mballoc.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c:696: error: implicit declaration of function 'generic_find_next_le_bit'
> > make[3]: *** [fs/ext4/mballoc.o] Error 1
> > 
> > <--  snip  -->
> 
> Known issue. The ext4 developers added a #define (with a different name than in
> the patch comment) in the commit below, but forgot to make sure
> generic_find_next_le_bit() is actually available.
> 

generic_find_next_le_bit is defined in lib/find_next_bit.c. 

But m68k doesn't want to use the GENERIC_FIND_NEXT_BIT. Can I request
somebody knowledgeable about m68k to give a try in implementing
generic_find_next_le_bit  equivalent on m68k ?

-aneesh
