From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM ATTEND] Persistent Memory
Date: Mon, 30 Dec 2013 22:04:04 +0100
Message-ID: <20131230210404.GB5457@quack.suse.cz>
References: <1387907056.2487.18.camel@vverma7-desk1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab3L3VEH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Dec 2013 16:04:07 -0500
Content-Disposition: inline
In-Reply-To: <1387907056.2487.18.camel@vverma7-desk1.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Added some relevant lists to CC (please don't forget about this).

On Tue 24-12-13 17:44:35, Verma, Vishal L wrote:
> I would like to attend LSF/MM 2014 - I am especially interested in
> discussions around persistent memory. I have been studying EXT4 and
> researching on what we'd have to do to best enable it for
> byte-addressable persistent memory.
  Do you have some concrete suggestions or observations regarding this?
Because discussing abstract ideas without actually trying something out
beforehand doesn't usually result in a useful discussion...
 
> I am relatively new in the Linux kernel world, and my previous
> experience has been with device driver work - I wrote a SCSI SG_IO
> translation layer for the NVMe driver. I also contributed to PMFS -
> https://github.com/linux-pmfs/pmfs which was our go-to route for
> enabling PM in the kernel before we decided EXT4 would be a better
> choice.
  I would be interested what were your reasons for the decision. Can you
elaborate a bit (that's just my personal curiosity)?

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
