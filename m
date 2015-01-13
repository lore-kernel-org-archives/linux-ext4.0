From: Adrian Palmer <adrian.palmer@seagate.com>
Subject: Re: [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other generic
 file systems)
Date: Tue, 13 Jan 2015 16:26:37 -0700
Message-ID: <CAKdFiL6Y0O=WTgaOQB9jaOQyVwRdnsKFc8GmNFL38WP5t-dWcw@mail.gmail.com>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
	<CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
	<03D7D1CF-D733-44E1-9F88-D68878D447BF@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:43054 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbbAMX0i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Jan 2015 18:26:38 -0500
Received: from pps.filterd (m0075550.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id t0DNHX5j005739
	for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2015 18:26:38 -0500
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com [209.85.213.175])
	by mx0a-00003501.pphosted.com with ESMTP id 1rwcjh84ry-2
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2015 18:26:37 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so19759207igd.2
        for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2015 15:26:37 -0800 (PST)
In-Reply-To: <03D7D1CF-D733-44E1-9F88-D68878D447BF@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas;

Thanks.  I appear to have overlooked the ext4 list for some reason
(the most obvious list).

On Tue, Jan 13, 2015 at 2:50 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On Jan 13, 2015, at 1:32 PM, Adrian Palmer <adrian.palmer@seagate.com> wrote:
>> This seemed to bounce on most of the lists to which it originally
>> sent.  I'm resending..
>>
>> I've uploaded an introductory design document at
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_Seagate_SMR-5FFS-2DEXT4&d=AwIDAg&c=IGDlg0lD0b-nebmJJ0Kp8A&r=-UHpLrTYk1Bz8YZcfJ9jdbDSs-C2VebVNvEaL0IKzDU&m=XG8Mp9OYaVpO5TJCkUXiHE6ULZ7s7CxSF2yJDzUTcZ0&s=l5X2IwR9XqKRMeuqd2qt8iumrj43h1muKUohZ6yTflM&e= . I'll update regularly.  Please
>> feel free to send questions my way.
>>
>> It seems there are many sub topics requested related to SMR for this conference.
>
> I'm replying to this on the linux-ext4 list since it is mostly of
> interest to ext4 developers, and I'm not in control over who attends
> the LSF/MM conference.  Also, there will be an ext4 developer meeting
> during/adjacent to LSF/MM that you should probably attend.

Is this co-located, or part of LSF/MM?  I would be very willing to
attend if I can.

>
> I think one of the important design decisions that needs to be made
> early on is whether it is possible to directly access some storage
> that can be updated with small random writes (either a separate flash
> LUN on the device, or a section of the disk that is formatted for 4kB
> sectors without SMR write requirements).

This would be nice, but I looking more generally to what I call
'single disk' systems.  Several more complicated FSs use a separate
flash drive for this purpose, but ext4 expects 1 vdev, and thus only
one type of media (agnostic).  We have hybrid HDD that have flash on
them, but the lba space isn't separate, so the FS or the DM couldn't
very easily treat them as 2 devices.

Also, talk in the standards committee has resulted in the allowance of
zero or more zones to be conventional PMR formatted vs SMR.  The idea
is the first zone on the disk.  That doesn't help 1) because of the
GPT table there and 2) partitions can be anywhere on the disk.  This
is set at manufacture time, and is not a change that can be made in
the field.

>
> That would allow writing metadata (superblock, bitmap, group descriptor,
> inode table, journal, in decreasing order of importance) in random
> order instead of imposing possibly painful read-modify-write or COW
> semantics on the whole filesystem.

Yeah.  Big design point.  For backwards compatibility, 1) the
superblock must reside in known locations and 2) any location change
in metadata would (eventually) require the superblock to be written in
place.  As such the bitmaps are almost constantly updated, either
in-place, or pass the in-place update through the group descriptor to
the superblock.

To make data more linear, I'm coding the data bitmap to mirror the
Writepointer information from the disk.  That would make the update of
the data bitmap, while not trivial, but also much less important.  For
the metadata, I'm exploring the idea of putting a scratchpad in the
devicemapper to hold a zone worth of data to be compacted/rewritten in
place.  That will require some thought.  We should get to coding that
in a couple of weeks.

>
> As for the journal, I think it would be possible to handle that in a
> way that is very SMR friendly.  It is written in linear order, and if
> mke2fs can size/align the journal file with SMR write regions then the
> only thing that needs to happen is to size/align journal transactions
> and the journal superblock with SMR write regions as well.

Agreed.  A circular buffer would be nice, but that's in ZACv2.  In the
meantime, I'm looking at using 2 zones as a buffer, freeing one while
using the other, both in forward only writes.  I remember T'so had a
proposal out for the journal.  We intend to rely on that when we get
to the journal (unfortunately, some time after LSF/MM)

>
> I saw on your SMR_FS-EXT4 README that you are looking at 8KB sector size.
> Please correct my poor understanding of SMR, but isn't 8KB a lot smaller
> than what the actual erase block size (or chunks or whatever they are
> named)?  I thought the erase blocks were on the order of MB in size?

SMR doesn't use erase blocks like Flash.  The idea is a zone, but I
admit it is similar.  They (currently) are 256MiB and nothing in the
standard requires this size -- it can change or even be irregular.
Current BG max size is 128MiB (4k).  An 8K cluster allows for a BG to
match a zone in size -- a new BG doesn't (can't) start in the middle
of a zone.  Also the BG/zone can be managed a single unit for purposes
of file collocation/defragmentation.  The ResetWritePointer command
acts like an eraser, zeroing out the BG (using the same code path as
discard and trim).  The difference is that the FS is now aware of the
state of the zone, using the information to make write decisions --
and is NOT media agnostic anymore.

>
> Are you already aware of the "bigalloc" feature?  That may provide most
> of what you need already.  It may be appropriate to default to e.g. 1MB
> bigalloc size for SMR drives, so that it is clear to users that the
> effective IO/allocation size is large for that filesystem.

We've looked at this, and found several problems.  The biggest is that
it is still experimental, along with it requires extents.  SMR HA and
HM don't like extents, as that requires a backward write.  We are
looking at a combination of code to scavenge from flex_bg and meta_bg
to create the large BG and move the metadata around on the disk.  We
are finding that the developer resources required on that path are
MUCH less - LSF/MM is only 2 months away.


Thanks again for the questions

Adrian

>
>> On Tue, Jan 6, 2015 at 4:29 PM, Adrian Palmer <adrian.palmer@seagate.com> wrote:
>>> I agree wholeheartedly with Dr. Reinecke in discussing what is becoming my
>>> favourite topic also. I support the need for generic filesystem support with
>>> SMR and ZAC/ZBC drives.
>>>
>>> Dr. Reinecke has already proposed a discussion on the ZAC/ZBC
>>> implementation.  As a complementary topic, I want to discuss the generic
>>> filesystem support for Host Aware (HA) / Host Managed (HM) drives.
>>>
>>> We at Seagate are developing an SMR Friendly File System (SMRFFS) for this
>>> very purpose.  Instead of a new filesystem with a long development time, we
>>> are implementing it as an HA extension to EXT4 (and WILL be backwards
>>> compatible with minimal code paths).  I'll be talking about the the on-disk
>>> changes we need to consider as well as the needed kernel changes common to
>>> all generic filesystems.  Later, we intend to evaluate the work for use in
>>> other filesystems and kernel processes.
>>>
>>> I'd like to host a discussion of SMRFFS and ZAC for consumer and cloud
>>> systems at LSF/MM. I want to gather community consensus at LSF/MM of the
>>> required technical kernel changes before this topic is presented at Vault.
>>>
>>> Subtopics:
>>>
>>> On-disk metadata structures and data algorithms
>>> Explicit in-order write requirement and a look at the IO stack
>>> New IOCTLs to call from the FS and the need to know about the underlying
>>> disk -- no longer completely disk agnostic
>>>
>>>
>>> Adrian Palmer
>>> Firmware Engineer II
>>> R&D Firmware
>>> Seagate, Longmont Colorado
>>> 720-684-1307
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=AwIDAg&c=IGDlg0lD0b-nebmJJ0Kp8A&r=-UHpLrTYk1Bz8YZcfJ9jdbDSs-C2VebVNvEaL0IKzDU&m=XG8Mp9OYaVpO5TJCkUXiHE6ULZ7s7CxSF2yJDzUTcZ0&s=2qssUWsRrBGSRntKGELIrxpaWCcpJsOfz8HBZaxvegM&e=
>
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=AwIDAg&c=IGDlg0lD0b-nebmJJ0Kp8A&r=-UHpLrTYk1Bz8YZcfJ9jdbDSs-C2VebVNvEaL0IKzDU&m=XG8Mp9OYaVpO5TJCkUXiHE6ULZ7s7CxSF2yJDzUTcZ0&s=2qssUWsRrBGSRntKGELIrxpaWCcpJsOfz8HBZaxvegM&e=
