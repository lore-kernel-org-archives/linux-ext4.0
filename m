From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2 v2] e2fsck: Discard only unused parts of inode table
Date: Thu, 01 Mar 2012 11:35:59 -0600
Message-ID: <4F4FB37F.60405@redhat.com>
References: <1330014566-2020-1-git-send-email-lczerner@redhat.com> <4F4D0159.1090409@sandeen.net> <alpine.LFD.2.00.1202290812530.4926@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, psusi@ubuntu.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2CAR4M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 12:56:12 -0500
In-Reply-To: <alpine.LFD.2.00.1202290812530.4926@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/29/12 1:22 AM, Lukas Czerner wrote:
> On Tue, 28 Feb 2012, Eric Sandeen wrote:

...

>>> +			/*
>>> +			 * If the last inode is free, we can discard it as well.
>>> +			 */
>>> +			if (inodes >= first_free)
>>> +				e2fsck_discard_inodes(ctx, group, first_free,
>>> +						      inodes - first_free + 1);
>>
>> This is unrelated to the changelog
>>
>>>  			/*
>>>  			 * If discard zeroes data and the group inode table
>>>  			 * was not zeroed yet, set itable as zeroed
>>>  			 */
>>>  			if ((ctx->options & E2F_OPT_DISCARD) &&
>>> -			    (io_channel_discard_zeroes_data(fs->io)) &&
>>> +			    !(ctx->options & E2F_OPT_NO) &&
>>
>> This is unrelated as well...
> 
> So do you want me to separate those unrelated changes to a separate
> patch ? Those are pretty small changes..

They are, but they are completely separate fixes, and not described in the changelog.

Ideally I'd say they should be a separate testable commit, but at least it
should be mentioned in the changelog (and patch summary).

Sorry, compound commits with unrelated changes are my pet peeve; they make bisecting
harder, and make it harder to find fixes when looking back over git history.

-Eric

>>
>> Rather than continuing to check _OPT_NO here and in e2fsck_discard_blocks(), it
>> might be better (in a separate patch) ;) to simply turn off OPT_DISCARD right
>> after options processing if -n was specified, and not worry about it down here.
> 
> Makes sense, I can change it.
> 
> Thanks!
> -Lukas
> 
>>
>>> +			    io_channel_discard_zeroes_data(fs->io) &&
>>>  			    !(ext2fs_bg_flags_test(fs, group,
>>> -						  EXT2_BG_INODE_ZEROED))) {
>>> +						   EXT2_BG_INODE_ZEROED))) {
>>>  				ext2fs_bg_flags_set(fs, group,
>>>  						    EXT2_BG_INODE_ZEROED);
>>>  				ext2fs_group_desc_csum_set(fs, group);
>>>  			}
>>>  
>>> +			first_free = fs->super->s_inodes_per_group + 1;
>>> +			free_array[group] = group_free;
>>> +			dir_array[group] = dirs_count;
>>>  			group ++;
>>>  			inodes = 0;
>>>  			skip_group = 0;
>>
>>
> 

