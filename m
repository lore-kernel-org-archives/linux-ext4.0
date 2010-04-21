From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 14:59:21 -0400
Message-ID: <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-2-git-send-email-lczerner@redhat.com>
	 <1271674527-2977-3-git-send-email-lczerner@redhat.com>
	 <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
	 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:59702 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0DUS7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 14:59:24 -0400
Received: by iwn8 with SMTP id 8so1197155iwn.16
        for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 11:59:21 -0700 (PDT)
In-Reply-To: <4BCE66C5.3060906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 20, 2010 at 10:45 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> Mark Lord wrote:
>> On 20/04/10 05:21 PM, Greg Freemyer wrote:
>>> Mark,
>>>
>>> This is the patch implementing the new discard logic.
>> ..
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ..
>>>> +void ext4_trim_extent(struct super_block *sb, int start, int coun=
t,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_group_t group, struct ext4_budd=
y *e4b)
>>>> +{
>>>> + =A0 =A0 =A0 ext4_fsblk_t discard_block;
>>>> + =A0 =A0 =A0 struct ext4_super_block *es =3D EXT4_SB(sb)->s_es;
>>>> + =A0 =A0 =A0 struct ext4_free_extent ex;
>>>> +
>>>> + =A0 =A0 =A0 assert_spin_locked(ext4_group_lock_ptr(sb, group));
>>>> +
>>>> + =A0 =A0 =A0 ex.fe_start =3D start;
>>>> + =A0 =A0 =A0 ex.fe_group =3D group;
>>>> + =A0 =A0 =A0 ex.fe_len =3D count;
>>>> +
>>>> + =A0 =A0 =A0 mb_mark_used(e4b,&ex);
>>>> + =A0 =A0 =A0 ext4_unlock_group(sb, group);
>>>> +
>>>> + =A0 =A0 =A0 discard_block =3D (ext4_fsblk_t)group *
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_BLOCKS_PER_GROU=
P(sb)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + start
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + le32_to_cpu(es->s_=
first_data_block);
>>>> + =A0 =A0 =A0 trace_ext4_discard_blocks(sb,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)=
discard_block,
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count);
>>>> + =A0 =A0 =A0 sb_issue_discard(sb, discard_block, count);
>>>> +
>>>> + =A0 =A0 =A0 ext4_lock_group(sb, group);
>>>> + =A0 =A0 =A0 mb_free_blocks(NULL, e4b, start, ex.fe_len);
>>>> +}
>>>
>>> Mark, unless I'm missing something, sb_issue_discard() above is goi=
ng
>>> to trigger a trim command for just the one range. =A0I thought the
>>> benchmarks you did showed that a collection of ranges needed to be
>>> built, then a single trim command invoked that trimmed that group o=
f
>>> ranges.
>> ..
>>
>> Mmm.. If that's what it is doing, then this patch set would be a
>> complete disaster.
>> It would take *hours* to do the initial TRIM.
>>
>> Lukas ?
>
> I'm confused; do we have an interface to send a trim command for mult=
iple ranges?
>
> I didn't think so ... =A0Lukas' patch is finding free ranges (above a=
 size threshold)
> to discard; it's not doing it a block at a time, if that's the concer=
n.
>
> -Eric

Eric,

I don't know what kernel APIs have been created to support discard,
but the ATA8 draft spec. allows for specifying multiple ranges in one
trim command.

See section 7.10.3.1 and .2 of the latest draft spec.

Both talk about multiple trim ranges per trim command (think thousands
of ranges per command).

Recent hdparm versions accept a trim command argument that causes
multiple ranges to be trimmed per command.

 --trim-sector-ranges        Tell SSD firmware to discard unneeded
data sectors: lba:count ..
 --trim-sector-ranges-stdin  Same as above, but reads lba:count pairs f=
rom stdin

As I understand it, this is critical from a performance perspective
for the SSDs Mark tested with.  ie. He found a single trim command
with 1000 ranges takes much less time than 1000 discrete trim
commands.

Per Mark's comment's in wiper.sh, a trim command can have a minimum of
128KB of associated range information, so it is thousands of ranges
that can be discarded in a single command

ie. hdparm can accept extremely large lists of ranges on stdin, but it
parses the list into discrete trim commands with thousands of ranges
per command.

A kernel implementation which is trying to implement after that fact
discards as this patch is doing, also needs to somehow craft trim
commands with a large payload of ranges if it is going to be
efficient.

If the block layer cannot do this yet, then in my opinion this type of
batched discarding needs to stay in user space as done with Mark's
wiper.sh script and enhanced hdparm until the block layer grows that
ability.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
