From: Jan Kara <jack@suse.cz>
Subject: Re: external journal an data= option
Date: Thu, 24 Nov 2016 14:50:09 +0100
Message-ID: <20161124135009.GI24138@quack2.suse.cz>
References: <5330915.k0A4yo7VY8@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Wolfgang Walter <linux@stwm.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5330915.k0A4yo7VY8@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Mon 21-11-16 16:39:53, Wolfgang Walter wrote:
> while testing ext4 with an external journal I found the following problem with 
> longterm kernel 4.4.30:
> 
> I could mount the filesystem without specifying the option data=....
> 
> It seems that it is then mounted with data=ordered and indeed this is what
> 
> 	cat /proc/mounts
> 
> shows.

Yes, that is correct.

> But I could not change any option afterwards with -o remount. It always said 
> that data=ordered is not valid with an external journal.
> 
> If I mount with explicitly stating data=writeback or data=journal remount 
> works fine.
> 
> So It seems that ext4 does forbid (at least in 4.4.30) data=ordered as an 
> option but uses it implicitly as default mode even with an external journal.

Can you show the exact error message and the set of mount options you use?
I'm not aware we would refuse data=ordered mode due to external journal...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
