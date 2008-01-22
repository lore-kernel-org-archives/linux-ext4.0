From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Tue, 22 Jan 2008 07:25:15 -0800 (PST)
Message-ID: <87924.1242.qm@web32614.mail.mud.yahoo.com>
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
Received: from web32614.mail.mud.yahoo.com ([68.142.207.241]:43983 "HELO
	web32614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751403AbYAVPZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jan 2008 10:25:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

----- Original Message ----
> From: Alasdair G Kergon <agk@redhat.com>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Mel Gorman <mel@csn.ul.ie>; Fengguang Wu <wfg@mail.ustc.edu.cn>; Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; James.Bottomley@steeleye.com; Jens Axboe <jens.axboe@oracle.com>; Milan Broz <mbroz@redhat.com>; Neil Brown <neilb@suse.de>
> Sent: Tuesday, January 22, 2008 3:39:33 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On Fri, Jan 18, 2008 at 11:01:11AM -0800, Martin Knoblauch wrote:
> >  At least, rc1-rc5 have shown that the CCISS system can do well. Now
> > the question is which part of the system does not cope well with the
> > larger IO sizes? Is it the CCISS controller, LVM or both. I am
> open
> 
 to
> > suggestions on how to debug that. 
> 
> What is your LVM device configuration?
>   E.g. 'dmsetup table' and 'dmsetup info -c' output.
> Some configurations lead to large IOs getting split up on the
> way
> 
 through
> device-mapper.
>
Hi Alastair,

 here is the output, the filesystem in question is on LogVol02:

  [root@lpsdm52 ~]# dmsetup table
VolGroup00-LogVol02: 0 350945280 linear 104:2 67109248
VolGroup00-LogVol01: 0 8388608 linear 104:2 418054528
VolGroup00-LogVol00: 0 67108864 linear 104:2 384
[root@lpsdm52 ~]# dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
VolGroup00-LogVol02 253   1 L--w    1    1      0 LVM-IV4PeE8cdxA3piC1qk79GY9PE9OC4OgmOZ4OzOgGQIdF3qDx6fJmlZukXXLIy39R
VolGroup00-LogVol01 253   2 L--w    1    1      0 LVM-IV4PeE8cdxA3piC1qk79GY9PE9OC4Ogmfn2CcAd2Fh7i48twe8PZc2XK5bSOe1Fq
VolGroup00-LogVol00 253   0 L--w    1    1      0 LVM-IV4PeE8cdxA3piC1qk79GY9PE9OC4OgmfYjxQKFP3zw2fGsezJN7ypSrfmP7oSvE

> See if these patches make any difference:
> 
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
> 
>     dm-md-merge_bvec_fn-with-separate-bdev-and-sector.patch
>     dm-introduce-merge_bvec_fn.patch
>     dm-linear-add-merge.patch
>     dm-table-remove-merge_bvec-sector-restriction.patch
>  

 thanks for the suggestion. Are they supposed to apply to mainline?

Cheers
Martin
