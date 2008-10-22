From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [stable] [PATCH] stable - ext[234]: Avoid printk floods in the
 face of directory corruption (CVE-2008-3528)
Date: Wed, 22 Oct 2008 11:21:08 -0500
Message-ID: <48FF52F4.10702@redhat.com>
References: <48FF42B8.3030606@redhat.com> <20081022161433.GB29489@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, ext4 development <linux-ext4@vger.kernel.org>
To: Greg KH <greg@kroah.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43384 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbYJVQVP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 12:21:15 -0400
In-Reply-To: <20081022161433.GB29489@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greg KH wrote:
> On Wed, Oct 22, 2008 at 10:11:52AM -0500, Eric Sandeen wrote:
>> This is a trivial backport of the following upstream commits:
>>
>> - bd39597cbd42a784105a04010100e27267481c67 (ext2)
>> - cdbf6dba28e8e6268c8420857696309470009fd9 (ext3)
>> - 9d9f177572d9e4eba0f2e18523b44f90dd51fe74 (ext4)
>>
>> This addresses CVE-2008-3528
>>
>> ext[234]: Avoid printk floods in the face of directory corruption
> 
> For what kernel releases is this applicable?  .27? .26? .25?  Earlier?

Sorry.. it is applicable to pretty much any kernel in the past :)  .27
certainly (that's what the patch is against), .26, .25.... yes.

It's not a particularly dangerous condition - you have to somehow get
the administrator to mount the filesystem before you can trigger the
"exploit" (which is a DoS, essentially) - so, I don't know if it's worth
porting back to the dawn of time...

Thanks,
-Eric

> thanks,
> 
> greg k-h

