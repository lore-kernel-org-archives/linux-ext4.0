From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 23 Jan 2008 03:12:39 -0800 (PST)
Message-ID: <739290.84170.qm@web32614.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	James.Bottomley@steeleye.com, Jens Axboe <jens.axboe@oracle.com>,
	Milan Broz <mbroz@redhat.com>, Neil Brown <neilb@suse.de>
To: Alasdair G Kergon <agk@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32614.mail.mud.yahoo.com ([68.142.207.241]:46879 "HELO
	web32614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972AbYAWLMk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Jan 2008 06:12:40 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Alasdair G Kergon <agk@redhat.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Mel Gorman <mel@csn.ul.ie>; Fengguang Wu <wfg@mail.ustc.edu.cn>; Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; James.Bottomley@steeleye.com; Jens Axboe <jens.axboe@oracle.com>; Milan Broz <mbroz@redhat.com>; Neil Brown <neilb@suse.de>
> Sent: Wednesday, January 23, 2008 12:40:52 AM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On Tue, Jan 22, 2008 at 07:25:15AM -0800, Martin Knoblauch wrote:
> >   [root@lpsdm52 ~]# dmsetup table
> > VolGroup00-LogVol02: 0 350945280 linear 104:2 67109248
> > VolGroup00-LogVol01: 0 8388608 linear 104:2 418054528
> > VolGroup00-LogVol00: 0 67108864 linear 104:2 384
> 
> The IO should pass straight through simple linear targets like
> that without needing to get broken up, so I wouldn't expect those patches to
> make any difference in this particular case.
> 

Alasdair,

 LVM/DM are off the hook :-) I converted one box to direct using partitions and the performance is the same disappointment as with LVM/DM. Thanks anyway for looking at my problem.

 I will move the discussion now to a new thread, targetting CCISS directly. 

Cheers
Martin
