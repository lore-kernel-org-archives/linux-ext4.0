From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Tue, 22 Jan 2008 14:39:33 +0000
Message-ID: <20080122143933.GA11111@agk.fab.redhat.com>
References: <alpine.LFD.1.00.0801180931250.2957@woody.linux-foundation.org> <903015.63912.qm@web32611.mail.mud.yahoo.com>
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
Received: from mx1.redhat.com ([66.187.233.31]:37540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYAVOlJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 09:41:09 -0500
Content-Disposition: inline
In-Reply-To: <903015.63912.qm@web32611.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2008 at 11:01:11AM -0800, Martin Knoblauch wrote:
>  At least, rc1-rc5 have shown that the CCISS system can do well. Now
> the question is which part of the system does not cope well with the
> larger IO sizes? Is it the CCISS controller, LVM or both. I am open to
> suggestions on how to debug that. 

What is your LVM device configuration?
  E.g. 'dmsetup table' and 'dmsetup info -c' output.
Some configurations lead to large IOs getting split up on the way through
device-mapper.

See if these patches make any difference:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/

    dm-md-merge_bvec_fn-with-separate-bdev-and-sector.patch
    dm-introduce-merge_bvec_fn.patch
    dm-linear-add-merge.patch
    dm-table-remove-merge_bvec-sector-restriction.patch
 
Alasdair
-- 
agk@redhat.com
