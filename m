From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Journal guided RAID resync
Date: Wed, 9 Mar 2011 11:27:28 +0200
Message-ID: <AANLkTimZW1fBK7wAny0zXboVG6eoJpZ+ZAUvOwdbomP0@mail.gmail.com>
References: <AANLkTik72=3h4T=MNnaqLFdfYHraYp8T=eaNyijFiY9f@mail.gmail.com>
	<D0E540E7-B1D0-4C89-BD0C-262915EE8A28@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D0E540E7-B1D0-4C89-BD0C-262915EE8A28@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 8, 2011 at 10:28 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> [I've removed LSF-PC from the CC list, since I believe the attendee/t=
opic selection is long past]

I think topics for discussion are always welcome (there is no sealed
agenda for LSF)

>
> One reason that we didn't use this patch is that it is essentially th=
e opposite of "ordered" mode when it comes to data reliability. It requ=
ires that the journal be updated with the blocks to be modified _before=
_ the data blocks are written.
>
> This means that stale data may be exposed to userspace in case of a c=
rash, unless a two-phase commit is done where the declare blocks are co=
mmitted to one transaction, and only after that the data blocks are wri=
tten.

I wouldn't go as far as calling it 2 separate transactions, but
certainly, a three-phase commit is possible:
1. write declared and metadata blocks descriptors
--- barrier/flush disk cache ---
2. write data blocks to disk and metadata blocks to journal
--- barrier/flush disk cache ---
3. write commit record
--- barrier/flush disk cache ---

The journal recovery will guide RAID to re-sync the blocks in the
"current" (uncommitted) transaction.

>
> =A0The other option is a WAFL mode where writes are done into RAID st=
ripe-aligned free space so that parity loss is not harmful to existing =
data. This is not unreasonable with mballoc for new blocks, but not nec=
essarily overwrites. It may tie in with snapshots nicely, since it has =
the same COW requirements.

Now this is too crazy even in my standards ;-)

>
> Cheers, Andreas
>
> On 2011-03-08, at 8:35, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> Hi All,
>>
>> I have picked up the old ext3/jbd patches a while ago and
>> was trying to figure out how difficult would it be to port them
>> to ext4/jbd2.
>>
>> The gain from these patches to anyone using software RAID
>> should be clear, see:
>> http://lwn.net/Articles/363490/
>>
>> What is not clear to me at this point is what are the
>> performance implications, if any, of withholding "declared" data
>> writeback until journal commit.
>>
>> I also did not get to estimating the effort involved in the porting
>> to ext4/jbd2. The absence of ext3/jbd "dirty data" buffers list is
>> going to be one of the issues to deal with.
>>
>> Does anyone out there have interest in pushing this forward?
>>
>> Amir.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsde=
vel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
