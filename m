From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 13:58:57 -0500
Message-ID: <4856B7F1.60301@redhat.com>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616150533.GB3279@atrey.karlin.mff.cuni.cz> <20080616185524.GR3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYFPTAM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jun 2008 15:00:12 -0400
In-Reply-To: <20080616185524.GR3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jun 16, 2008  17:05 +0200, Jan Kara wrote:
>>   First, I'd like to see some short comment on what semantics
>> delalloc,data=ordered is going to have. At least I can imagine at least
>> two sensible approaches:
>>   1) All we guarantee is that user is not going to see uninitialized data.
>> We send writes to disk (and allocate blocks) whenever it fits our needs
>> (usually when pdflush finds them).
>>   2) We guarantee that when transaction commits, your data is on disk -
>> i.e., we allocate actual blocks on transaction commit.
>>
>>   Both these possibilities have their pros and cons. Most importantly,
>> 1) gives better disk layout while 2) gives higher consistency
>> guarantees. Note that with 1), it can under some circumstances happen,
>> that after a crash you see block 1 and 3 of your 3-block-write on disk,
>> while block 2 is still a hole. 1) is easy to implement (you mostly did
>> it below), 2) is harder. I think there should be broader consensus on
>> what the semantics should be (changed subject to catch more attention ;).
> 
> IMHO, the semantic should be (1) and not (2).  Applications don't understand
> "when the transaction commits" so it doesn't provide any useful guarantee
> to userspace, and if they actually need the data on disk (e.g. MTA) then
> they need to call fsync to ensure this.
> 
> While I agree it is theoretically possible to have the "hole in data
> where there shouldn't be one" scenario, in real life these blocks would be
> allocated together by delalloc+mballoc and this situation should not happen.

I'm not sure that's true; filling in holes is not that uncommon.

But, I'm not sure that it actually leads to a problem, as the metadata
gets "created" for the hole-fill-in only when the block actually gets
allocated right?

-Eric

