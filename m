From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Set file system to read-only by I/O error
 threshold
Date: Mon, 20 Jun 2011 16:41:50 +0200
Message-ID: <20110620144150.GE4810@quack.suse.cz>
References: <1308312516-14252-1-git-send-email-wangshaoyan.pt@taobao.com>
 <20110620133626.GC4810@quack.suse.cz>
 <BANLkTikLrLPLgj3ykmqcZ_+KVQi85vrWAPSJHGX_hOV3nNL0sg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Ted Tso <tytso@mit.edu>
To: Wang Shaoyan <stufever@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1FTOly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jun 2011 10:41:54 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikLrLPLgj3ykmqcZ_+KVQi85vrWAPSJHGX_hOV3nNL0sg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 20-06-11 22:12:48, Wang Shaoyan wrote:
> Thanks for your reply!
> 2011/6/20 Jan Kara <jack@suse.cz>:
>=20
> > =A0Hum, if I understand your problem right, you should just mount t=
he
> > filesystem with errors=3Dremount-ro and you will get the behavior y=
ou need.
> > Or what is insufficient on that solution? Your patch surely provide=
s more
> > flexibility but is that really needed?
> >
>=20
> 1.There are more than ten hard disks in each of our production
> machine, so it is not right for
> making the whole system panic, only based on one error in one harddis=
k.
> 2.There may be multiple tasks which access the same hard drive at the
> same time, so it is
> not ideal for changing the system to readonly, only based on one erro=
r
> in one task,
> while other task may be killed.
>=20
> That's why we have a relaxed restrictions, only when the error counte=
r
> is grower than our
> threshold, we change fs to readonly or panic.
> When a system has a dozen hard drives, each hard drive is running
> several tasks on time,
> this feature is a real demand.
  OK, but then your changelog is just misleading because your need for =
the
feature has nothing to do with different error behavior in ext4 nojourn=
al
mode as far as I understand. So please describe your real needs in the
changelog as you described them above...

That being said I'm not sure such policies like when to remount fs
read-only belong to the kernel. It would seem more appropriate to me to
somehow propagate information about all IO errors to user space and hav=
e
some monitoring daemon (be it Hadoop or Nagios or whatever people use)
handle remounting the filesystem and marking the disk as offline. But
this is just my opinion and I don't want to block this feature. It's mo=
re
a suggestion for other people...

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
