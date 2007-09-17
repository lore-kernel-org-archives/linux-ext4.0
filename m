From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] ensure do_split leaves enough free space in both
 blocks
Date: Mon, 17 Sep 2007 07:17:47 -0500
Message-ID: <46EE706B.6020606@redhat.com>
References: <46ECA71C.9020100@redhat.com> <20070917054817.GG2990@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	hooanon05@yahoo.co.jp
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXIQMRv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2007 08:17:51 -0400
In-Reply-To: <20070917054817.GG2990@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:

>> @@ -141,6 +141,7 @@ struct dx_map_entry
>>  {
>>  	u32 hash;
>>  	u32 offs;
>> +	u32 size;
>>  };
> 
> Hmm, there was something about the size of the dx_map_entry, because
> it is actually built at the end of the target block, that we don't
> want to make it too large.

Yep, that crossed my mind...

> Now, I'm not sure if adding an extra 32-bit field per entry would make
> it too large or not, since I haven't looked at that code in ages.  The
> critical factor is whether max_entries = blocksize / min_rec_len would
> consume more than the worst-case amount of space in the target block.
> 
> So, because thinking is hard, you might consider just changing the above
> code to use "u16 offs; u16 size;" since we know those are big enough
> variables, and won't increase the size of the map...

That sounds like a good plan.  The other possibility is, we don't *have*
to store size in the map, with offset we can always get to the size, too.

>> +	for (i = count-1; i >= 0; i--) {
>> +		/* is more than half of this entry in last half of the block? */
>> +		if (size + map[i].size/2 > blocksize/2)
>> +			break;
>> +		size += map[i].size;
>> +		move++;
>> +	}
>> +	/* map index at which we will split */
>> +	split = count - move;
> 
> The rest of this looks fine - I think the "1/2 of median entry" decision
> is the right one as we discussed.

Yes, I forgot to mention that I had discussed this with you a bit
already.  :)  After drawing a few pictures, this seems like the right
way to go.

-Eric
