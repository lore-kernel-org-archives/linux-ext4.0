From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 0/8] Ext4 encryption support for blocksize < pagesize
Date: Sat, 13 Jan 2018 10:20:20 -0800
Message-ID: <1fff9920-ccd2-0b22-fe34-07fa644bd0f0@infradead.org>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
 <1aa4981a-63ef-aaa4-97da-9c9137d52862@infradead.org>
 <4200254.IvU45QXq6O@localhost.localdomain>
 <20180113124842.GA15364@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu
To: Matthew Wilcox <willy@infradead.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbeAMSUX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Jan 2018 13:20:23 -0500
In-Reply-To: <20180113124842.GA15364@bombadil.infradead.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/13/2018 04:48 AM, Matthew Wilcox wrote:
> On Sat, Jan 13, 2018 at 10:58:00AM +0530, Chandan Rajendra wrote:
>> On Saturday, January 13, 2018 12:37:59 AM IST Randy Dunlap wrote:
>>> On 01/12/18 06:11, Chandan Rajendra wrote:
>>>> This patchset implements code to support encryption of Ext4 filesystem
>>>> instances that have blocksize less than pagesize. The patchset has
>>>> been tested on both ppc64 and x86_64 machines.
>>>
>>> strictly "less than" or "less than or equal to"?
>>
>> I have tested the patchset for the use cases of "less than or equal to
>> page size" i.e. On ppc64, the patchset was tested with blocksizes of 
>> 4k and 64k. On x86_64, the patchset was tested with blocksizes of 2k 
>> and 4k.
> 
> I think there's a miscommunication here.  ext4 already supports encryption
> of filesystems with block size == page size.  Chandan is adding support
> for encrypting filesystems with block size < page size.  Without removing
> support for block size == page size ;-)

I see.  Thanks for the clarification.


-- 
~Randy
