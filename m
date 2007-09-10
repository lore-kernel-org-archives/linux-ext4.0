From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] mballoc patches
Date: Mon, 10 Sep 2007 09:35:30 -0500
Message-ID: <46E55632.6040804@redhat.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46C08902.7020709@linux.vnet.ibm.com> <46CB527B.5090300@redhat.com> <46E538C0.7090205@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbXIJOhf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Sep 2007 10:37:35 -0400
In-Reply-To: <46E538C0.7090205@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alex Tomas wrote:
> Eric Sandeen wrote:
>> +/*
>> + * default stripe size = 1MB
>> + */
>> +#define MB_DEFAULT_STRIPE              256
> 
> agree, though seems we'd better make it blocksize-insensitive

Well, for now this isn't even used at *all* so might as well just remove it.

>> +static int mb_find_extent(struct ext4_buddy *e3b, int order, int block,
>> +                               int needed, struct ext4_free_extent *ex)
>>
>> how many "what" are needed?
> 
> well, blocks :)

I figured, though bytes is a possibility.  :)  In general, being
explicit about units helps; xfs suffers a bit from byte/block/sector
confusion in the code, in some places.

>> Also there are a *lot* of BUGs and BUG_ONs added in this patch... are
>> none of these recoverable?
> 
> well, I'll review the code in this regard again, but most of them are not.
> not that I like kernel panics, but BUG_ON() are very helpful to maintain
> code, especially in long-term.

Ok, I just think there might be upstream pushback on these, at one point
at least they were trying to reduce the nr. of BUG calls in the code...

Thanks,
-Eric
