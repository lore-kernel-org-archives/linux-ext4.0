From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_update_reserve_space warning fix not in stable
Date: Thu, 8 Jan 2015 08:48:56 +0100
Message-ID: <20150108074856.GA14705@quack.suse.cz>
References: <54AD772B.2050003@akamai.com>
 <20150107192105.GE2802@quack.suse.cz>
 <54AD8DDA.6090902@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbbAHHtC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Jan 2015 02:49:02 -0500
Content-Disposition: inline
In-Reply-To: <54AD8DDA.6090902@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 07-01-15 13:49:46, Josh Hunt wrote:
> On 01/07/2015 01:21 PM, Jan Kara wrote:
> >On Wed 07-01-15 12:12:59, Josh Hunt wrote:
> >>We are hitting the following warning in the field pretty frequently
> >>on the latest 3.10 stable kernel:
> >>[11708.763067] WARNING: at fs/ext4/inode.c:363
> >>ext4_da_update_reserve_space+0x261/0x280 [ext4]()
> >>
> >>The issue was resolved via "ext4: fix warning in
> >>ext4_da_update_reserve_space()" (7d7345322d60ed), but the fix was
> >>not submitted as a stable update for 3.10. I was wondering if
> >>there's a reason why this was not done, or if it was just
> >>overlooked?
> >>
> >>The patch appears to have a dependency on "quota: provide interface
> >>for readding allocated space into reserved space" (1c8924eb106c1ac),
> >>so I think both would need to be submitted if you feel it's
> >>possible.
> >   Since the problem is relatively harmless, I think we didn't bother
> >porting it to 3.10. Feel free to port those two patches to 3.10 and submit
> >them to stable@vger.kernel.org.
> 
> Thanks for the reply Jan.
> 
> I've ported them locally to 3.10 and they seem to apply cleanly
> as-is. I can submit the request to stable as long as you believe
> there's no harm in doing so, or any other dependency which may be
> required. My testing of a patched 3.10 with the two above patches
> shows the warning no longer triggers as you report in your commit
> log.
  I'm not aware of any reason why these patches shouldn't be in 3.10 stable
so just go ahead. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
