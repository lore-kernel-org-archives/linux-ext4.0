From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [PATCH 2.6.27.y 2/3] ext4: Fix file fragmentation during large
 file write.
Date: Fri, 28 May 2010 21:12:36 -0500
Message-ID: <4C007814.3000207@jaysonking.com>
References: <4C001888.8020006@jaysonking.com> <4C001901.1070207@jaysonking.com> <20100529010657.GM26177@thunk.org>
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
Received: from bosmailout12.eigbox.net ([66.96.186.12]:42088 "EHLO
	bosmailout12.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0E2CqP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 May 2010 22:46:15 -0400
In-Reply-To: <20100529010657.GM26177@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/28/2010 08:06 PM, tytso@mit.edu wrote:
> On Fri, May 28, 2010 at 02:26:57PM -0500, Jayson R. King wrote:
>> From: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>> Date: Thu Oct 16 10:10:36 2008 -0400
>> Subject: ext4: Fix file fragmentation during large file write.
>>
>> commit 22208dedbd7626e5fc4339c417f8d24cc21f79d7 upstream.
>>
>> The range_cyclic writeback mode uses the address_space writeback_index
>> as the start index for writeback.  With delayed allocation we were
>> updating writeback_index wrongly resulting in highly fragmented file.
>> This patch reduces the number of extents reduced from 4000 to 27 for a
>> 3GB file.
>
> This isn't a critical bug fix either.  I don't really care a whole
> lot, since I don't plan to support ext4 with all of these patches but
> if you haven't been doing a full set of testing with these patches,
> I'd be very concerned about whether ext4 would be stable after
> applying this patch series.
>
> What sort of testing _have_ you done?

I've ran dbench for hours on an ext4 volume followed by fsck on the 
volume. Without the patches (particularly, just the last patch, "ext4: 
Implement range_cyclic..."), a typical, sustained moderate to high ext4 
fs load on .27 would often lead to a deadlock. A good demonstration is 
to run "dbench 500" which will usually cause a deadlock in a couple of 
minutes.

I wasn't aware of a way to apply the deadlock fix in "ext4: Implement 
range_cyclic..." without also introducing this patch, since some of the 
blocks it touches are created by this patch.

Thanks for looking.

Rgds,

Jayson
