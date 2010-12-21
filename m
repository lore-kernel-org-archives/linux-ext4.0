From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Next3 on-disk format change request
Date: Tue, 21 Dec 2010 14:28:01 +0200
Message-ID: <AANLkTinGt6quy39d2urgkkZzE0igkjFvy7fdRstcrQeJ@mail.gmail.com>
References: <AANLkTikAoKpZNGvtyYscPLVH1HrW3xaCZ84sVc62UGD4@mail.gmail.com>
	<20100624003529.GF6843@thunk.org>
	<AANLkTil17qZWKJfFsV77yADzxOffB2w94GN0COQyR82n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37513 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0LUM2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Dec 2010 07:28:02 -0500
Received: by qwa26 with SMTP id 26so3915204qwa.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 04:28:01 -0800 (PST)
In-Reply-To: <AANLkTil17qZWKJfFsV77yADzxOffB2w94GN0COQyR82n@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 24, 2010 at 7:33 AM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Thu, Jun 24, 2010 at 3:35 AM, =A0<tytso@mit.edu> wrote:
>> On Tue, Jun 22, 2010 at 01:30:54PM +0300, Amir Goldstein wrote:
>>> My on-disk format change request is to re-assign a ro_compat featur=
e
>>> for IS_SNAPSHOT (currently in s_flags).
>>
>> OK, so in addition to:
>>
>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A0 0x0080
>>
>> You would also like:
>>
>> #define EXT4_FEATURE_RO_COMPAT_IS_SNAPSHOT =A0 =A0 =A00x0100
>>
>> which is a feature flag that the kernel will never support, since th=
is
>> is a hint that snapshot should only be mounted read-only, correct?
>>
>
> That is correct.
>

Hi Ted,

I am pinging you on this old request of mine... and modifying my
request slightly (to an incompatible feature).

I would like to have EXT4_FEATURE_INCOMPAT_IS_SNAPSHOT,
which will be set only inside snapshot images.

This is to say that Ext4 snapshots can only be mounted by Ext4 with
'snapshot mount' support.

One of the important applications of 'snapshot mount' incompatible
support is to deny read access
to snapshot files (or more generally excluded files) entires inside a s=
napshot.

This issue is currently handled by clearing all old snapshot inode
copies on snapshot take time.
It is a sub optimal solution, which was imposed by the design to mount
Next3 snapshot as Ext2
and it is not scalable to a large number of 'excluded' files.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
