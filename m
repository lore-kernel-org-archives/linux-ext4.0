From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Wed, 21 Apr 2010 16:52:55 -0400
Message-ID: <k2p87f94c371004211352h34ddd0c4ve7cb1f1747c0e9f8@mail.gmail.com>
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
	Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:39489 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab0DUUw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Apr 2010 16:52:57 -0400
Received: by pzk16 with SMTP id 16so3975993pzk.22
        for <linux-ext4@vger.kernel.org>; Wed, 21 Apr 2010 13:52:57 -0700 (PDT)
In-Reply-To: <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

correcting Christoph's email address - no other edits/comments

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
>>>>> Lukas ?
>>>>
>>>> I'm confused; do we have an interface to send a trim command for m=
ultiple ranges?
>>>>
>>>> I didn't think so ... =A0Lukas' patch is finding free ranges (abov=
e a size threshold)
>>>> to discard; it's not doing it a block at a time, if that's the con=
cern.
>>>>
>>>> -Eric
>>>
>>> Eric,
>>>
>>> I don't know what kernel APIs have been created to support discard,
>>> but the ATA8 draft spec. allows for specifying multiple ranges in o=
ne
>>> trim command.
>
> Well, sb_issue_discard is what ext4 is using, and that takes a single
> range. =A0I don't know if anyone has looked into adding a vectored AP=
I.
>
>>
>> Greg,
>>
>> We have full support for this in the "discard" support at the file
>> system layer for several file systems.
>
> Actually, we don't support what Greg is talking about, to my knowledg=
e.
>
>> The block layer effectively muxes the "discard" into the right targe=
t
>> device command. TRIM for ATA, WRITE_SAME (with unmap) or UNMAP for
>> SCSI...
>>
>> If your favourite fs supports this, you can enable this feature with
>> "-o
>> discard" for fine grained discards,
>
> Thanks, it's worth pointing out that TRIM is not the only backend to =
the
> discard API. =A0However, even if we do implement a vectored API, we c=
an
> translate that to dumber commands if a given spec doesn't support it.
>
> Getting back to the problem...
>
> From the file system, you want to discard discrete ranges of blocks.
> The API to support this can either take care of the data integrity
> guarantees by itself, or make the upper layer ensure that trim and wr=
ite
> do not pass each other. =A0The current implementation does the latter=
=2E =A0In
> order to do the former, there is the potential for a lot of overhead =
to
> be introduced into the block allocation layers for the file systems.
>
> So, given the above, it is up to the file system to send down the
> biggest discard requests it can in order to reduce the overhead of th=
e
> command. =A0If a vectored approach is made available, then that would=
 be
> even better. =A0Christoph, is this something that's on your radar?
>
> Cheers,
> Jeff
>



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
   http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets=
-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
