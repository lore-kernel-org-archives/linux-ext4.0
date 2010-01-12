From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 17:43:21 +0100
Message-ID: <4B4CA6A9.3030401@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com> <20100112163828.GA14633@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab0ALQnv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 11:43:51 -0500
In-Reply-To: <20100112163828.GA14633@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 05:38 PM, Christoph Hellwig wrote:
> Ok, I looked at the issue.  The problem is that the Xen backend drivers
> are (as expected) utterly braindead and submit bios directly from the
> virtualization backed without using proper abstractions and thus
> bypassing all the cache coherency features in the fileystems (the block
> device nodes are just another mini-filesystem in that respect).  So
> when you first have buffered access in the host pages may stay in cache
> and get overwritten directly on disk by a Xen guest, and once the guest
> is down the host may still use the now stale cached data.
>
> I would recommend to migrate your cutomers to KVM which uses the proper
> abtractions and thus doesn't have this problem.  There's a reason after
> all why all the Xen dom0 mess never got merged to mainline.
>    
So, do you think the problem is in the Xen backend drivers and to make 
it working right in Xen the driver fix is needed?
