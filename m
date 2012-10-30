From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 13:14:24 -0700
Message-ID: <20121030201424.GD19559@blackbox.djwong.org>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013524.GA19591@blackbox.djwong.org>
 <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
 <20121030154844.1898f068@notabene.brown>
 <yq1a9v4884i.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30006 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2J3UOb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2012 16:14:31 -0400
Content-Disposition: inline
In-Reply-To: <yq1a9v4884i.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 08:19:41AM -0400, Martin K. Petersen wrote:
> >>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> 
> Neil,
> 
> >> Might be nice to make the sysfs knob tweakable. Also, don't forget to
> >> add a suitable blurb to Documentation/ABI/.
> 
> Neil>  It isn't at all clear to me that having the sysfs knob
> Neil>  'tweakable' is a good idea.  From the md/raid5 perspective, I
> Neil>  would want to know for certain whether the pages in a give bio
> Neil>  are guaranteed not to change, or if they might.  I could set the
> Neil>  BDI_CAP_STABLE_WRITES and believe they will never change, or test
> Neil>  the BDI_CAP_STABLE_WRITES and let that tell me if they might
> Neil>  change or not.  But if the bit can be changed at any moment, then
> Neil>  it can never be trusted and so becomes worthless to me.
> 
> I was mostly interested in being able to turn it on for devices that
> haven't explicitly done so. I agree that turning it off can be
> problematic.

I'm ok with having a tunable that can turn it on, but atm I can't really think
of a convincing reason to let people turn it /off/.  If people yell loud enough
I'll add it, but I'd rather not have to distinguish between "on because user
set it on" vs "on because hw needs it".

It'd be nice if the presence BDI_CAP_STABLE_WRITES meant that all filesystems
would wait on page writes.  Hrm, guess I'll see about adding that to the patch
set.  Though ISTR that at least the vfat and ext2 maintainers weren't
interested the last time I asked.

--D
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
