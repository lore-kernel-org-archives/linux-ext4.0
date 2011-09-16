From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Fri, 16 Sep 2011 20:00:52 +0800
Message-ID: <CAGBYx2Yzb=zt-Bay8iTzkFD6SJu+GW_qgw2+QXD-djnnqdq_uw@mail.gmail.com>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
	<CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
	<20110915175755.GK15782@thunk.org>
	<CAOQ4uxgXzNrrsAiii9iUetiiz-RdK+SixoRiPfGEp7zTPsLCGQ@mail.gmail.com>
	<CAGBYx2ZZzftLcbkTXJY6nYed4eSRhXNC6oPzm7rfLiSt0YGMxQ@mail.gmail.com>
	<CAOQ4uxgprEywkyeqAvQp9Cj=vs4RGDh35dLUyUuWThLdTccFWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:41109 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1IPMAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 08:00:53 -0400
Received: by qwi4 with SMTP id 4so1968066qwi.1
        for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 05:00:52 -0700 (PDT)
In-Reply-To: <CAOQ4uxgprEywkyeqAvQp9Cj=vs4RGDh35dLUyUuWThLdTccFWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 7:48 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Fri, Sep 16, 2011 at 2:35 PM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m> wrote:
>> On Fri, Sep 16, 2011 at 2:52 PM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
>>> On Thu, Sep 15, 2011 at 8:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>> On Thu, Sep 15, 2011 at 07:01:47PM +0300, Amir Goldstein wrote:
>>>>> > + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_CO=
MPAT_EXCLUDE_BITMAP,
>>>>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },
>>>>>
>>>>> The feature name should read "exclude_bitmap".
>>>>> This is a COMPAT feature which should be set by default on every =
mkfs.ext4.
>>>>> The "has_snapshot" (or "snapshots") feature is a RO_COMPAT featur=
e, which
>>>>> can be turned on and off, depending on whether you want to enable=
 or
>>>>> disable snapshots.
>>>>
>>>> Yeah, I was trying to use a name which would be a bit more descrip=
tive
>>>> than "exclude_bitmap", but I agree that will get very confusing wi=
th
>>>> the "has_snapshot" feature name.
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>>>
>>>
>>> maybe we can simply call it snapshot_bitmap, if it pleases everyone=
 ;-)
>> active_snapshot_bitmap will be clearer.:-)
>
> clearer to who?
To code reviewers, actually bits in exclude bitmap are set only if the
blocks are used by active/current snapshot inode.

Yongqiang.
> this name is printed by "tune2fs -l"
> potential readers of this output, who did not read the documentation
> first, are just as likely to know what
> "exclude_bitmap" means as when they read "resize_inode" or "flex_bg",
> but at least "snapshot_bitmap"
> will give them a clue.
>
> Amir.
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
