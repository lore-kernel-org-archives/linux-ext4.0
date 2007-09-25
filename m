From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 21:15:47 +0530
Message-ID: <46F92D2B.60205@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1190728569.28492.3.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com, cmm@us.ibm.com
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48866 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbXIYPpx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 11:45:53 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PFjpQR014373
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 01:45:51 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PFnPEZ235346
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 01:49:25 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PFjpp8009419
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 01:45:51 +1000
In-Reply-To: <1190728569.28492.3.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Dave Kleikamp wrote:
> On Tue, 2007-09-25 at 14:33 +0530, Aneesh Kumar K.V wrote:
>> ext4 file system layout contain different split members
>> like bg_block_bitmap  and bg_block_bitmap_hi. Introduce
>> data type le32_t and le16_t to be used as the type of
>> these split members. This prevents these members frome
>> being accessed directly. Accesing them directly gives
>> a compiler warning. This helps in catching some BUGS
>> due to direct partial access of these split fields.
> 
> Ugh.  I don't like this typedef at all. It just makes the data type more
> confusing.


Confusing enough to make people look at them more carefully.



> 
> Why not just change the name of bg_block_bitmap to something like
> bg_block_bitmap_lo or _bg_block_bitmap?  It should be clear from the
> name that it shouldn't be used without careful consideration.
> 

even if we rename the variables, I guess we would like to have helper functions
for accessing these values. That would mean the code is finally going to look more
or less the same except the typedef. But the typedef actually save us from serious
misuse of these variables.


-aneesh
