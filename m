From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Tue, 22 Jan 2008 23:40:52 +0000
Message-ID: <20080122234051.GP8075@agk.fab.redhat.com>
References: <87924.1242.qm@web32614.mail.mud.yahoo.com>
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
To: Martin Knoblauch <spamtrap@knobisoft.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYAVXmJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 18:42:09 -0500
Content-Disposition: inline
In-Reply-To: <87924.1242.qm@web32614.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 22, 2008 at 07:25:15AM -0800, Martin Knoblauch wrote:
>   [root@lpsdm52 ~]# dmsetup table
> VolGroup00-LogVol02: 0 350945280 linear 104:2 67109248
> VolGroup00-LogVol01: 0 8388608 linear 104:2 418054528
> VolGroup00-LogVol00: 0 67108864 linear 104:2 384

The IO should pass straight through simple linear targets like that without
needing to get broken up, so I wouldn't expect those patches to make any
difference in this particular case.

Alasdair
-- 
agk@redhat.com
