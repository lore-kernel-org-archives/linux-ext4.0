From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Tue, 20 Apr 2010 22:26:11 -0400
Message-ID: <4BCE6243.5010209@teksavvy.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>	 <1271674527-2977-3-git-send-email-lczerner@redhat.com> <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:29146 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316Ab0DUC0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Apr 2010 22:26:15 -0400
In-Reply-To: <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20/04/10 05:21 PM, Greg Freemyer wrote:
> Mark,
>
> This is the patch implementing the new discard logic.
..
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
..
>> +void ext4_trim_extent(struct super_block *sb, int start, int count,
>> +               ext4_group_t group, struct ext4_buddy *e4b)
>> +{
>> +       ext4_fsblk_t discard_block;
>> +       struct ext4_super_block *es = EXT4_SB(sb)->s_es;
>> +       struct ext4_free_extent ex;
>> +
>> +       assert_spin_locked(ext4_group_lock_ptr(sb, group));
>> +
>> +       ex.fe_start = start;
>> +       ex.fe_group = group;
>> +       ex.fe_len = count;
>> +
>> +       mb_mark_used(e4b,&ex);
>> +       ext4_unlock_group(sb, group);
>> +
>> +       discard_block = (ext4_fsblk_t)group *
>> +                       EXT4_BLOCKS_PER_GROUP(sb)
>> +                       + start
>> +                       + le32_to_cpu(es->s_first_data_block);
>> +       trace_ext4_discard_blocks(sb,
>> +                       (unsigned long long)discard_block,
>> +                       count);
>> +       sb_issue_discard(sb, discard_block, count);
>> +
>> +       ext4_lock_group(sb, group);
>> +       mb_free_blocks(NULL, e4b, start, ex.fe_len);
>> +}
>
> Mark, unless I'm missing something, sb_issue_discard() above is going
> to trigger a trim command for just the one range.  I thought the
> benchmarks you did showed that a collection of ranges needed to be
> built, then a single trim command invoked that trimmed that group of
> ranges.
..

Mmm.. If that's what it is doing, then this patch set would be a complete disaster.
It would take *hours* to do the initial TRIM.

Lukas ?
