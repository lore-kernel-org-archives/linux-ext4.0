From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] fs-writeback: Add helper function to start	writeback
  if idle
Date: Fri, 18 Dec 2009 09:29:57 -0600
Message-ID: <4B2B9FF5.4030102@redhat.com>
References: <4B22D029.5090304@redhat.com> <20091218114427.GQ4489@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091218114427.GQ4489@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe wrote:
> On Fri, Dec 11 2009, Eric Sandeen wrote:
>> ext4, at least, would like to start pushing on writeback if it starts
>> to get close to ENOSPC when reserving worst-case blocks for delalloc
>> writes.  Writing out delalloc data will convert those worst-case
>> predictions into usually smaller actual usage, freeing up space
>> before we hit ENOSPC based on this speculation.
>>
>> Thanks to Jens for the suggestion for the helper function,
>> & the naming help.
>>
>> I've made the helper return status on whether writeback was
>> started even though I don't plan to use it in the ext4 patch;
>> it seems like it would be potentially useful to test this
>> in some cases.
> 
> Eric, how do you want to merge these? I can easily take this first one
> through any branch, but I suppose the ext4 one should go through the
> proper ext4 channels.

Doesn't matter to me really; maybe it'd be simpler if it all went
though the ext4 tree so that there aren't any ordering problems?

-Eric
