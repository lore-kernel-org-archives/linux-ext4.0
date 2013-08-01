From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Thu, 01 Aug 2013 12:23:22 -0500
Message-ID: <51FA998A.8050305@redhat.com>
References: <51F94938.1040303@bfccomputing.com> <51F96964.4000608@redhat.com> <51FA055F.90000@bfccomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bill McGonigle <bill@bfccomputing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab3HARX1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 13:23:27 -0400
In-Reply-To: <51FA055F.90000@bfccomputing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/1/13 1:51 AM, Bill McGonigle wrote:
> On 07/31/2013 03:45 PM, Eric Sandeen wrote:
>> well, kernelspace can't use libblkid.
> 
> ah, right.  But userspace could, and with your patch, basically do
> the same thing and mount using the UUID number stored in the
> superblock using the 'by-uuid' path.  Sweet.

yeah.  Right now mount can't parse i.e. "journal_path=UUID=$UUID" type
options as it can do for the device specification, but if the /dev/disk/by-uuid
paths are set up by the time you mount the fs, that works too.

>> I'll send the ext4 version in a minute if you want to try it.
> 
> that would be super - I'd be happy to test it soon.

K, it's on the list now.  :)

-Eric

> -Bill
> 

