From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 2/2] ext4: update donor file's ctime/mtime
Date: Wed, 14 Oct 2009 17:19:33 -0400
Message-ID: <87f94c370910141419g38b4b371sa1470107953cc47f@mail.gmail.com>
References: <4ACD9D04.40503@sx.jp.nec.com>
	 <EE52B431-D993-47A3-B914-5FE2ACE953B8@sun.com>
	 <4AD52E2E.80404@sx.jp.nec.com>
	 <A1BDA448-5948-4D2E-B456-5AF6F87149DF@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:36317 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbZJNVUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 17:20:09 -0400
Received: by iwn10 with SMTP id 10so139081iwn.4
        for <linux-ext4@vger.kernel.org>; Wed, 14 Oct 2009 14:19:33 -0700 (PDT)
In-Reply-To: <A1BDA448-5948-4D2E-B456-5AF6F87149DF@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 14, 2009 at 2:10 PM, Andreas Dilger <adilger@sun.com> wrote=
:
> On 13-Oct-09, at 18:49, Kazuya Mio wrote:
>>
>> 2009/10/10 2:20, Andreas Dilger wrote::
>>>
>>> On 8-Oct-09, at 02:04, Kazuya Mio wrote:
>>>
>>>> EXT4_IOC_MOVE_EXT changes donor file data, but doesn't update
>>>> ctime/mtime. =A0This patch fixes this problem.
>>>
>>> I would argue that just migrating the file data shouldn't update th=
e
>>> ctime/mtime. =A0Those are used to determine if the file has changed=
 in some
>>> way, usually for the purpose of backup. =A0Migrating the data does =
not change
>>> anything from user-space POV and shouldn't force a new backup of th=
e file.
>>
>> EXT4_IOC_MOVE_EXT always changes the original actual contents of don=
or
>> file
>> if orig file and donor file aren't the same. It may be that some of
>> user-space implementations hide such a changing. For example, e4defr=
ag
>> unlinks the donor file, and removes it by decreasing reference count=
 after
>> calling EXT4_IOC_MOVE_EXT. But from the ioctl point of view,
>> EXT4_IOC_MOVE_EXT doesn't know whether donor file will be removed or=
 not,
>> so I think we should update ctime/mtime.
>
> Maybe I am confused. =A0Is EXT4_IOC_MOVE_EXT used for file defragment=
ation?
> I thought the goal of this ioctl was to copy the data from the donor =
inode
> to the target inode (using a new allocation in the target inode), and=
 then
> once the whole donor file had been copied (defragmented) the target e=
xtents
> replace the entire donor file's extents?
>
> In this model it would be OK to change the mtime/ctime of the _target=
_ file,
> but when these extents move back to the donor file the mtime/ctime of=
 the
> donor
> file should not be changed, I think, so that it does not force a full
> backup.
>
> If the caller has done something to change the actual data in the don=
or file
> it can always use utimes() to update the ctime/mtime, but it is not p=
ossible
> for userspace to revert the ctime after it has changed.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

You have it backwards.

The target file is the fragmented file containing good data.  ie. It
is the target of the defragmentation process.

The donor file starts out as fallocated file with no valid data in it,
but the data blocks are less fragmented than the target hopefully.

The target file ends up using the data blocks provided by the donor,
but with the target files original data in them.

What the donor has at the end of the process, I don't know for sure.
I assume it is a zero length file that is in need of being deleted.
Having the donor's timestamps seems technically correct, but of little
real world consequence.  Or maybe there will eventually be a use case
that reuses the donor file for some purpose.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
