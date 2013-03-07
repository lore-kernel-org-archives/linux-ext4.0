From: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] mke2fs: restore verbose message for BLKDISCARD
Date: Thu, 07 Mar 2013 12:47:09 -0700
Message-ID: <5138EEBD.5000705@wwwdotorg.org>
References: <1362515118-30344-1-git-send-email-swarren@wwwdotorg.org> <alpine.LFD.2.00.1303060753500.24359@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, Chris Ball <cjb@laptop.org>,
	linux-ext4@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:48081 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab3CGTrN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 14:47:13 -0500
In-Reply-To: <alpine.LFD.2.00.1303060753500.24359@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/06/2013 12:13 AM, Luk=E1=9A Czerner wrote:
> On Tue, 5 Mar 2013, Stephen Warren wrote:
>=20
>> Date: Tue,  5 Mar 2013 13:25:18 -0700
>> From: Stephen Warren <swarren@wwwdotorg.org>
>> To: Theodore Ts'o <tytso@mit.edu>
>> Cc: Chris Ball <cjb@laptop.org>, linux-ext4@vger.kernel.org,
>>     Stephen Warren <swarren@nvidia.com>
>> Subject: [PATCH] mke2fs: restore verbose message for BLKDISCARD
>>
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> mke2fs on a large slow eMMC device may appear to hang while executin=
g
>> ioctl(BLKDISCARD). CTRL-C and CTRL-\ don't appear to respond, or res=
pond
>> extremely slowly. -v doesn't give any hints what's happening. Only s=
trace
>> is a clue. Make -v print some clues to make it easier to track down =
the
>> apparent hang.
>>
>> This change re-uses the original messages that were implemented as p=
art
>> of 5827d24 "mke2fs support for BLKDISCARD" in order to easily re-use=
 the
>> translations of that message. Note that this patch prints the first
>> message before executing the IOCTL, so the user is told what's going=
 on
>> before the long wait.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>=20
> Note that you've added the message only around the first 4k discard
> which is only used to test whether the device actually support the
> discard... which is not very useful and it can not even know whether
> the whole device discard will succeed/fail so it is misleading.

Oops. I certainly should looked at the code better.

> Moreover there actually is a message saying that we're "Discarding
> device blocks" and it even shows the progress. The step in which
> we're doing the discard (and update the progress) is given by
> DISCARD_STEP_MB =3D 2048MB. And all that in non verbose mode as well.

That said, it's that very first call to io_channel_discard() that is
hanging then; I don't see the existing message at all. With my change, =
I
do see the new message that I added. (So, no stdio flushing issue here)=
=2E

I will go investigate why this API is hanging. Sorry for the noise.

=2E..
> As mentioned we're doing 2GB discard steps so the problem really
> should not be on mkfs side. It is very much possible that the
> discard implementation on the eMMC is terribly slow (which does not
> surprise me). What is says about itself ?
>=20
> grep . /sys/block/sda/queue/discard_*

/sys/block/mmcblk1/queue/discard_granularity
0
/sys/block/mmcblk1/queue/discard_max_bytes
512
/sys/block/mmcblk1/queue/discard_zeroes_data
1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
