From: Jan Kara <jack@suse.cz>
Subject: Re: Performance of ext4
Date: Mon, 16 Jun 2008 19:54:08 +0200
Message-ID: <20080616175408.GF3279@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de> <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de> <18513.345.553912.449710@frecb006361.adech.frec.bull.fr> <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYFPRyK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 13:54:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, 12 Jun 2008, Holger Kiehl wrote:
> 
> >On Thu, 12 Jun 2008, Aneesh Kumar K.V wrote:
> >
> >>On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
> >>>This time there is no OOPS and system is still up running without any
> >>>problem (except any process wanting to write something to this filesystem
> >>>gets stuck forever).
> >>>
> >>>What can I do to help find the problem? The system is still up with all 
> >>>those
> >>>process hanging in D-state.
> >>>
> >>
> >>if you can login to the system get the dmesg output after
> >>
> >>echo t > /proc/sysrq-trigger
> >>
> >Unfortunately I have not set CONFIG_MAGIC_SYSRQ. Tomorrow I will try to
> >reproduce this with a kernel that has CONFIG_MAGIC_SYSRQ set.
> >
> After recompiling, rebooting and run afdbench first I got an OOPS and the
> system hanged up solid. The only thing I was able to catch is this:
> 
>   RIP [<ffffffff803019f9>] jbd2_journal_release_jbd_inode+0xcb/0x100
>   RSP <ffff8101fe259c18>
> 
> This was copied by hand. And this I cut 'cut and past' from my terminal:
> 
> kernel: Code: c3 e8 31 ce f3 ff 41 fe 04 24 e8 fe 3f 16 00 4c 89 fe 48 89 
> df e8 5f cd f3 ff eb 82 48 83 7d 00 00 74 27 48 8b 55 10 48 8b 45 18 <48> 
> 89 42 08 48 89 10 48 c7 45 18 00 02 20 00 48 c7 45 10 00 01
  Aneesh found cause of this oops I think... Aneesh, would you send the
fix to Holger? Thanks.

> So I rebooted run bonnie and then afdbench and I get the same problem as
> yesterday. All process trying to write something to this filesystem hang
> in D-state. But now I was able to do the echo t > /proc/sysrq-trigger.
> Here the dmesg output:
  Sadly, the output seems to be truncated (mainly, the kjournald process
is missing, which is probably the root cause of the hang). So could you
have a look whether /var/log/messages doesn't contain the dump of all
processes? And if no, then could you do "echo w >/proc/sysrq-trigger"
please? That will dump only blocked processes which should fit in the log
buffer. You can also increase log buffer size in kernel config but that
shouldn't be needed. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
