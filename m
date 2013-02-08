From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: Re: GRUB and the risk of block list corruption in extX
Date: Fri, 08 Feb 2013 11:15:22 +0100
Message-ID: <5114D03A.6000700@ts.fujitsu.com>
References: <51137F76.8070705@ts.fujitsu.com> <20130207205335.GA28084@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:54277 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070Ab3BHKPY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2013 05:15:24 -0500
In-Reply-To: <20130207205335.GA28084@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/07/2013 09:53 PM, Theodore Ts'o wrote:

>>   "/sbin/grub-setup: warn: Embedding is not possible. GRUB can only be
>>   installed in this setup by using blocklists. However, blocklists are
>>   UNRELIABLE and their use is discouraged."
> 
> This only happens if grub2 can't install itself in the space between
> the MBR and the beginning of the first partition.  So in practice,
> most people won't see this unless they install the root partition on
> the whole disk, or perhaps for disks with GUUID partition tables.

It happens when you try to install the boot loader directly in the start
sector of the root or boot partition. That's an option that many Linux
distributions have been offering their users for multiboot support in
the past, and which some people find pracital for multiboot systems.

Thanks a lot,
Martin

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
