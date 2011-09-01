From: Josef Bacik <josef@redhat.com>
Subject: Re: lock i_mutex for fallocate?
Date: Thu, 1 Sep 2011 13:59:27 -0400
Message-ID: <20110901175926.GC29299@dhcp231-156.rdu.redhat.com>
References: <4E5ED2D5.8040302@linux.vnet.ibm.com> <4E5EDBE4.8010604@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab1IAR7o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 13:59:44 -0400
Content-Disposition: inline
In-Reply-To: <4E5EDBE4.8010604@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 06:12:04PM -0700, Allison Henderson wrote:
> Oh, I meant for this to go to linux-fsdevel instead of linux-kernel, but  
> all feedback is welcome!  :)
>
> On 08/31/2011 05:33 PM, Allison Henderson wrote:
>> Hi All,
>>
>> In ext4 punch hole, we realized that the punch hole operation needs to
>> be done under i_mutex just like truncate. i_mutex for truncate is held
>> in the vfs layer, so we dont need to lock it at the file system layer,
>> but vfs does not lock i_mutex for fallocate. We can lock i_mutex for
>> fallocate at the fs layer, but question was raised then: should i_mutex
>> for fallocate be held in the vfs layer instead? I do not know if other
>> file systems need i_mutex to be locked for fallocate, or if they might
>> be locking it already, so I am doing some investigating on this idea,
>> and also the appropriate use of i_mutex in general. Can someone provide
>> some insight this topic? Thx!
>>

Btrfs has range locking for our extents, so we don't really need to be holding
the i_mutex, even tho it appears we do it anyway.  So I'd rather this not be
moved to VFS for us who can do more fine grained locking.  Thanks,

Josef
