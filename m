From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other generic file systems)
Date: Tue, 13 Jan 2015 14:50:59 -0700
Message-ID: <03D7D1CF-D733-44E1-9F88-D68878D447BF@dilger.ca>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com> <CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Adrian Palmer <adrian.palmer@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40727 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbbAMVvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2015 16:51:02 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so6072351pab.6
        for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2015 13:51:01 -0800 (PST)
In-Reply-To: <CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 13, 2015, at 1:32 PM, Adrian Palmer <adrian.palmer@seagate.com> wrote:
> This seemed to bounce on most of the lists to which it originally
> sent.  I'm resending..
> 
> I've uploaded an introductory design document at
> https://github.com/Seagate/SMR_FS-EXT4. I'll update regularly.  Please
> feel free to send questions my way.
> 
> It seems there are many sub topics requested related to SMR for this conference.

I'm replying to this on the linux-ext4 list since it is mostly of
interest to ext4 developers, and I'm not in control over who attends
the LSF/MM conference.  Also, there will be an ext4 developer meeting
during/adjacent to LSF/MM that you should probably attend.

I think one of the important design decisions that needs to be made
early on is whether it is possible to directly access some storage
that can be updated with small random writes (either a separate flash
LUN on the device, or a section of the disk that is formatted for 4kB
sectors without SMR write requirements).

That would allow writing metadata (superblock, bitmap, group descriptor,
inode table, journal, in decreasing order of importance) in random
order instead of imposing possibly painful read-modify-write or COW
semantics on the whole filesystem.

As for the journal, I think it would be possible to handle that in a
way that is very SMR friendly.  It is written in linear order, and if
mke2fs can size/align the journal file with SMR write regions then the
only thing that needs to happen is to size/align journal transactions
and the journal superblock with SMR write regions as well. 

I saw on your SMR_FS-EXT4 README that you are looking at 8KB sector size.
Please correct my poor understanding of SMR, but isn't 8KB a lot smaller
than what the actual erase block size (or chunks or whatever they are
named)?  I thought the erase blocks were on the order of MB in size?

Are you already aware of the "bigalloc" feature?  That may provide most
of what you need already.  It may be appropriate to default to e.g. 1MB
bigalloc size for SMR drives, so that it is clear to users that the
effective IO/allocation size is large for that filesystem.

> On Tue, Jan 6, 2015 at 4:29 PM, Adrian Palmer <adrian.palmer@seagate.com> wrote:
>> I agree wholeheartedly with Dr. Reinecke in discussing what is becoming my
>> favourite topic also. I support the need for generic filesystem support with
>> SMR and ZAC/ZBC drives.
>> 
>> Dr. Reinecke has already proposed a discussion on the ZAC/ZBC
>> implementation.  As a complementary topic, I want to discuss the generic
>> filesystem support for Host Aware (HA) / Host Managed (HM) drives.
>> 
>> We at Seagate are developing an SMR Friendly File System (SMRFFS) for this
>> very purpose.  Instead of a new filesystem with a long development time, we
>> are implementing it as an HA extension to EXT4 (and WILL be backwards
>> compatible with minimal code paths).  I'll be talking about the the on-disk
>> changes we need to consider as well as the needed kernel changes common to
>> all generic filesystems.  Later, we intend to evaluate the work for use in
>> other filesystems and kernel processes.
>> 
>> I'd like to host a discussion of SMRFFS and ZAC for consumer and cloud
>> systems at LSF/MM. I want to gather community consensus at LSF/MM of the
>> required technical kernel changes before this topic is presented at Vault.
>> 
>> Subtopics:
>> 
>> On-disk metadata structures and data algorithms
>> Explicit in-order write requirement and a look at the IO stack
>> New IOCTLs to call from the FS and the need to know about the underlying
>> disk -- no longer completely disk agnostic
>> 
>> 
>> Adrian Palmer
>> Firmware Engineer II
>> R&D Firmware
>> Seagate, Longmont Colorado
>> 720-684-1307
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





