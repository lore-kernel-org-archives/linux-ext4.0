From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 14:00:56 +0200
Message-ID: <4CEBACF8.6070206@panasas.com>
References: <20101123100239.GA4232@amd> <4CEB96D7.80105@panasas.com> <20101123105432.GA4483@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:54477 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KWMBD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Nov 2010 07:01:03 -0500
In-Reply-To: <20101123105432.GA4483@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/2010 12:54 PM, Nick Piggin wrote:
> On Tue, Nov 23, 2010 at 12:26:31PM +0200, Boaz Harrosh wrote:
>>>   *
>>>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>>>   * Returns 1 if writeback was started, 0 if not.
>>> + *
>>> + * Even if 1 is returned, writeback may not be started if memory allocation
>>> + * fails. This function makes no guarantees about anything.
>>>   */
>>>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>>>  {
>>>  	if (!writeback_in_progress(sb->s_bdi)) {
>>> -		down_read(&sb->s_umount);
>>> -		writeback_inodes_sb(sb);
>>> -		up_read(&sb->s_umount);
>>> +		bdi_start_writeback(sb->s_bdi, get_nr_dirty_pages());
>>>  		return 1;
>>> -	} else
>>> -		return 0;
>>> +	}
>>> +	return 0;
>>>  }
>>>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>>>  
>>> @@ -1172,17 +1173,18 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
>>>   *
>>>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>>>   * Returns 1 if writeback was started, 0 if not.
>>> + *
>>> + * Even if 1 is returned, writeback may not be started if memory allocation
>>> + * fails. This function makes no guarantees about anything.
>>>   */
>>>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>>>  				   unsigned long nr)
>>>  {
>>>  	if (!writeback_in_progress(sb->s_bdi)) {
>>> -		down_read(&sb->s_umount);
>>> -		writeback_inodes_sb_nr(sb, nr);
>>> -		up_read(&sb->s_umount);
>>> +		bdi_start_writeback(sb->s_bdi, nr);
>>>  		return 1;
>>> -	} else
>>> -		return 0;
>>> +	}
>>> +	return 0;
>>>  }
>>>  EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>>>  
>>
>> static inline int writeback_inodes_sb_if_idle(struct super_block *sb)
>> {
>> 	return writeback_inodes_sb_nr_if_idle(sb, get_nr_dirty_pages());
>> }
>>
>> In writeback.h, No?
> 
> I didn't care enough to move it :P I don't know if it matters.
> 

Than please just open code it in ext4 and completely remove it.
One stupid function is enough don't you think?

> 
>> But it has a single user so please just kill it.
>>
>> Also writeback_inodes_sb_nr_if_idle() has a single user. Combined with above,
>> two users. Why not open code it in the two sites. It should be much
>> clearer to understand what the magic is all about?
> 
> The filesystem shouldn't be aware of the details (the "magic") of how to
> kick writeback, so I think the abstraction is right as is.
> 

bdi_start_writeback() looks like a very clear abstraction to me but
if you have plans for it than sure, I'm convinced.

> Thanks,
> Nick
> 

Thanks
Boaz
