From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 16:44:51 -0400
Message-ID: <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-3-git-send-email-lczerner@redhat.com>
	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
	 <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
	 <4BCF4C53.3010608@redhat.com>
	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@ifradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:36766 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0DUUow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 16:44:52 -0400
Received: by pxi17 with SMTP id 17so456811pxi.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 13:44:52 -0700 (PDT)
In-Reply-To: <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 21, 2010 at 3:22 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Ric Wheeler <rwheeler@redhat.com> writes:
>
>> On 04/21/2010 02:59 PM, Greg Freemyer wrote:
>>> On Tue, Apr 20, 2010 at 10:45 PM, Eric Sandeen<sandeen@redhat.com> =
=A0wrote:
>>>> Mark Lord wrote:
>>>>> On 20/04/10 05:21 PM, Greg Freemyer wrote:
>>>>>> Mark,
>>>>>>
>>>>>> This is the patch implementing the new discard logic.
>>>>> ..
>>>>>> Signed-off-by: Lukas Czerner<lczerner@redhat.com>
>>>>> ..
>>>>>>> +void ext4_trim_extent(struct super_block *sb, int start, int c=
ount,
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t group, struct ext4_b=
uddy *e4b)
>>>>>>> +{
>>>>>>> + =A0 =A0 =A0 ext4_fsblk_t discard_block;
>>>>>>> + =A0 =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(sb)->s_es=
;
>>>>>>> + =A0 =A0 =A0 struct ext4_free_extent ex;
>>>>>>> +
>>>>>>> + =A0 =A0 =A0 assert_spin_locked(ext4_group_lock_ptr(sb, group)=
);
>>>>>>> +
>>>>>>> + =A0 =A0 =A0 ex.fe_start =3D start;
>>>>>>> + =A0 =A0 =A0 ex.fe_group =3D group;
>>>>>>> + =A0 =A0 =A0 ex.fe_len =3D count;
>>>>>>> +
>>>>>>> + =A0 =A0 =A0 mb_mark_used(e4b,&ex);
>>>>>>> + =A0 =A0 =A0 ext4_unlock_group(sb, group);
>>>>>>> +
>>>>>>> + =A0 =A0 =A0 discard_block =3D (ext4_fsblk_t)group *
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_G=
ROUP(sb)
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + start
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + le32_to_cpu(es-=
>s_first_data_block);
>>>>>>> + =A0 =A0 =A0 trace_ext4_discard_blocks(sb,
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long lo=
ng)discard_block,
>>>>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count);
>>>>>>> + =A0 =A0 =A0 sb_issue_discard(sb, discard_block, count);
>>>>>>> +
>>>>>>> + =A0 =A0 =A0 ext4_lock_group(sb, group);
>>>>>>> + =A0 =A0 =A0 mb_free_blocks(NULL, e4b, start, ex.fe_len);
>>>>>>> +}
>>>>>>
>>>>>> Mark, unless I'm missing something, sb_issue_discard() above is =
going
>>>>>> to trigger a trim command for just the one range. =A0I thought t=
he
>>>>>> benchmarks you did showed that a collection of ranges needed to =
be
>>>>>> built, then a single trim command invoked that trimmed that grou=
p of
>>>>>> ranges.
>>>>> ..
>>>>>
>>>>> Mmm.. If that's what it is doing, then this patch set would be a
>>>>> complete disaster.
>>>>> It would take *hours* to do the initial TRIM.
>
> Except it doesn't. =A0Lukas did provide numbers in his original email=
=2E
>

Looking at the benchmarks (for the first time) at
http://people.redhat.com/jmoyer/discard/ext4_batched_discard/

I don't see anything that says how long the proposed trim ioctl takes
to complete on the full filesystem.

What they do show is that with the 3 test SSDs used for this
benchmark, the current released discard implementation is a net loss.
ie. You are better off running without the discards for all 3 vendors.
 (at least under the conditions tested.)

After the patch is applied and optimizing the discards to large free
extents only, it works out to same performance with or without the
discards.  ie. no net gain or loss.

That is extremely cool because one assumes that the non-discard case
would degrade over time, but that the discard case will not.

So that argues for the current proposed patch going in.

But quoting from the first email:

=3D=3D
The basic idea behind my discard support is to create an ioctl which
walks through all the free extents in each allocating group and discard
those extents. As an addition to improve its performance one can specif=
y
minimum free extent length, so ioctl will not bother with shorter exten=
ts.

This of course means, that with each invocation the ioctl must walk
through whole file system, checking and discarding free extents, which
is not very efficient. The best way to avoid this is to keep track of
deleted (freed) blocks. Then the ioctl have to trim just those free
extents which were recently freed.

In order to implement this I have added new bitmap into ext4_group_info
(bb_bitmap_deleted) which stores recently freed blocks. The ioctl then
walk through bb_bitmap_deleted, compare deleted extents with free
extents trim them and then removes it from the bb_bitmap_deleted.

But you may notice, that there is one problem. bb_bitmap_deleted does
not survive umount. To bypass the problem the first ioctl call have to
walk through whole file system trimming all free extents. But there is =
a
better solution to this problem. The bb_bitmap_deleted can be stored on
disk an can be restored in mount time along with other bitmaps, but I
think it is a quite big change and should be discussed further.
=3D=3D

The above seems to argue against the patch going in until the
mount/umount issues are addressed.

So in addition to this patch, Lukas is proposing a on disk change to
address the fact that calling trim upteen times at mount time is too
slow.

Per Mark's testing of last summer, an alternative solution is to use a
vectored trim approach that is far more efficient.

Mark's benchmarks showed this as doable in seconds which seems like a
reasonable amount of time for a mount time operation.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
