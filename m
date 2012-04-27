From: Miao Xie <miaoxie1984@gmail.com>
Subject: Re: [PATCH 1/4] vfs: introduce try_to_writeback_inodes_sb(_nr)
Date: Fri, 27 Apr 2012 16:06:00 +0800
Message-ID: <4F9A5368.5000904@gmail.com>
References: <4F98B9A7.8060209@gmail.com> <20120426031156.GY9541@dastard> <CAAW_DMg9VLEtV40=qAbT3WZ4tN+ejZxToFHO0AiqDmjvV=V4eA@mail.gmail.com> <20120426151159.GB25603@dhcp231-144.rdu.redhat.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Xie Miao <miaoxie1984@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56486 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2D0IGL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2012 04:06:11 -0400
In-Reply-To: <20120426151159.GB25603@dhcp231-144.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B404=E6=9C=8826=E6=97=A5 23:12, Josef Bacik =E5=86=
=99=E9=81=93:

> On Thu, Apr 26, 2012 at 03:55:52PM +0800, Xie Miao wrote:
>> On Thu, Apr 26, 2012 at 11:11 AM, Dave Chinner <david@fromorbit.com>=
 wrote:
>>>> writeback_inodes_sb(_nr) grabs s_umount lock when it want to start
>>>> writeback,
>>>> it may bring us deadlock problem when doing umount. So we introduc=
e new
>>>> functions -- try_to_writeback_inodes_sb(_nr) -- which use
>>>> down_read_trylock()
>>>> instead of down_read() to avoid that deadlock problem.
>>>>
>>>> This idea came from Christoph Hellwig.
>>>> Some code is from the patch of Kamal Mostafa.
>>>
>>> This just re-implements writeback_inodes_[nr]_sb_if_idle() with a
>>> trylock instead of a blocking lock.
>>>
>>> Just replace the blocking lock in writeback_inodes_[nr]_sb_if_idle(=
)
>>> with a trylock and use that.
>>
>> The change of these two functions is relative to three modules,  so =
I think
>> the patch set now is easy to be reviewed by the developers of each m=
odule.
>>
>=20
> I agree with David, there's no sense in making something completely s=
eperate,
> this function was introduced soley to kick off background writeout if=
 we could
> with no garuntees, if the other users suddenly don't like the behavio=
r they can
> creating something different for themselves.  Thanks,


OK, I'll make them together.

Thanks
Miao
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
