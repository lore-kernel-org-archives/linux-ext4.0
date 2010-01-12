From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 17:51:18 +0100
Message-ID: <4B4CA886.8070808@redhat.com>
References: <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com> <20100112163828.GA14633@infradead.org> <4B4CA6A9.3030401@redhat.com> <20100112164748.GA26895@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0ALQvr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 11:51:47 -0500
In-Reply-To: <20100112164748.GA26895@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 05:47 PM, Christoph Hellwig wrote:
> On Tue, Jan 12, 2010 at 05:43:21PM +0100, Michal Novotny wrote:
>    
>> So, do you think the problem is in the Xen backend drivers and to make
>> it working right in Xen the driver fix is needed?
>>      
> Yes, the Xen blkback driver just submits I/O directly without using
> the right interfaces to force cache coherency.  It might be relatively
> easy to hack a call in to flush all caches when it starts up, but given
> how it bypasses all abstractions it's almost impossible to give full
> coherency as if using the normal block device interfaces.
>
>    
Ok, this way the fix to the drivers should be done. Thanks for your 
investigation. I just forwarded your reply to other members of my team.

Thanks,
Michal
