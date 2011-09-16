From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Fri, 16 Sep 2011 19:35:49 +0800
Message-ID: <CAGBYx2ZZzftLcbkTXJY6nYed4eSRhXNC6oPzm7rfLiSt0YGMxQ@mail.gmail.com>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
	<CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
	<20110915175755.GK15782@thunk.org>
	<CAOQ4uxgXzNrrsAiii9iUetiiz-RdK+SixoRiPfGEp7zTPsLCGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>,
	linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48531 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1IPLfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 07:35:50 -0400
Received: by yie30 with SMTP id 30so2821061yie.19
        for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 04:35:50 -0700 (PDT)
In-Reply-To: <CAOQ4uxgXzNrrsAiii9iUetiiz-RdK+SixoRiPfGEp7zTPsLCGQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 2:52 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Thu, Sep 15, 2011 at 8:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Thu, Sep 15, 2011 at 07:01:47PM +0300, Amir Goldstein wrote:
>>> > + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMP=
AT_EXCLUDE_BITMAP,
>>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },
>>>
>>> The feature name should read "exclude_bitmap".
>>> This is a COMPAT feature which should be set by default on every mk=
fs.ext4.
>>> The "has_snapshot" (or "snapshots") feature is a RO_COMPAT feature,=
 which
>>> can be turned on and off, depending on whether you want to enable o=
r
>>> disable snapshots.
>>
>> Yeah, I was trying to use a name which would be a bit more descripti=
ve
>> than "exclude_bitmap", but I agree that will get very confusing with
>> the "has_snapshot" feature name.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>
>
> maybe we can simply call it snapshot_bitmap, if it pleases everyone ;=
-)
active_snapshot_bitmap will be clearer.:-)
>
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
