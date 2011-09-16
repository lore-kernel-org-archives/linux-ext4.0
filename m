From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Fri, 16 Sep 2011 09:52:43 +0300
Message-ID: <CAOQ4uxgXzNrrsAiii9iUetiiz-RdK+SixoRiPfGEp7zTPsLCGQ@mail.gmail.com>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
	<CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
	<20110915175755.GK15782@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1IPGwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 02:52:45 -0400
Received: by wwf22 with SMTP id 22so4661989wwf.1
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 23:52:43 -0700 (PDT)
In-Reply-To: <20110915175755.GK15782@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 8:57 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 15, 2011 at 07:01:47PM +0300, Amir Goldstein wrote:
>> > + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPA=
T_EXCLUDE_BITMAP,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },
>>
>> The feature name should read "exclude_bitmap".
>> This is a COMPAT feature which should be set by default on every mkf=
s.ext4.
>> The "has_snapshot" (or "snapshots") feature is a RO_COMPAT feature, =
which
>> can be turned on and off, depending on whether you want to enable or
>> disable snapshots.
>
> Yeah, I was trying to use a name which would be a bit more descriptiv=
e
> than "exclude_bitmap", but I agree that will get very confusing with
> the "has_snapshot" feature name.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>

maybe we can simply call it snapshot_bitmap, if it pleases everyone ;-)

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
