From: Bill McGonigle <bill@bfccomputing.com>
Subject: Re: [PATCH] ext3: allow specifying external journal by pathname mount
 option
Date: Thu, 01 Aug 2013 02:51:11 -0400
Message-ID: <51FA055F.90000@bfccomputing.com>
References: <51F94938.1040303@bfccomputing.com> <51F96964.4000608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from borlaug.bfccomputing.com ([173.9.115.12]:55739 "EHLO
	borlaug.bfccomputing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3HAGvc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Aug 2013 02:51:32 -0400
In-Reply-To: <51F96964.4000608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/31/2013 03:45 PM, Eric Sandeen wrote:
 > well, kernelspace can't use libblkid.

ah, right.  But userspace could, and with your patch, basically do the 
same thing and mount using the UUID number stored in the superblock 
using the 'by-uuid' path.  Sweet.

 > I'll send the ext4 version in a minute if you want to try it.

that would be super - I'd be happy to test it soon.

-Bill

-- 
Bill McGonigle, Owner
BFC Computing, LLC
http://bfccomputing.com/
Telephone: +1.855.SW.LIBRE
Email, IM, VOIP: bill@bfccomputing.com
VCard: http://bfccomputing.com/vcard/bill.vcf
Social networks: bill_mcgonigle/bill.mcgonigle
