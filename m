From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 16:02:23 +0000
Message-ID: <1190736143.6433.13.camel@norville.austin.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1190728569.28492.3.camel@norville.austin.ibm.com>
	 <46F92D2B.60205@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com, cmm@us.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41782 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbXIYQC1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 12:02:27 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8PG2RkH010203
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 12:02:27 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PG2Qbx565618
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 12:02:26 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PG2Q65029330
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 12:02:26 -0400
In-Reply-To: <46F92D2B.60205@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-25 at 21:15 +0530, Aneesh Kumar K.V wrote:
> 
> Dave Kleikamp wrote:
> > On Tue, 2007-09-25 at 14:33 +0530, Aneesh Kumar K.V wrote:
> >> ext4 file system layout contain different split members
> >> like bg_block_bitmap  and bg_block_bitmap_hi. Introduce
> >> data type le32_t and le16_t to be used as the type of
> >> these split members. This prevents these members frome
> >> being accessed directly. Accesing them directly gives
> >> a compiler warning. This helps in catching some BUGS
> >> due to direct partial access of these split fields.
> > 
> > Ugh.  I don't like this typedef at all. It just makes the data type more
> > confusing.
> 
> 
> Confusing enough to make people look at them more carefully.
> 
> 
> 
> > 
> > Why not just change the name of bg_block_bitmap to something like
> > bg_block_bitmap_lo or _bg_block_bitmap?  It should be clear from the
> > name that it shouldn't be used without careful consideration.
> > 
> 
> even if we rename the variables, I guess we would like to have helper functions
> for accessing these values. That would mean the code is finally going to look more
> or less the same except the typedef.

I see that as a good thing.  The typedef is the part I don't like.

> But the typedef actually save us from serious
> misuse of these variables.

You could just as easily write code that misuses bg_block_bitmap->value,
as you could bg_block_bitmap_lo.  I actually think using a name that
describes that it's only half-a-value is more clear.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center
