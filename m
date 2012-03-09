From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] Don't do page stablization if
 !CONFIG_BLKDEV_INTEGRITY
Date: Fri, 9 Mar 2012 11:20:05 -0500
Message-ID: <20120309162005.GA18489@thunk.org>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
 <4F57F523.3020703@redhat.com>
 <4F581BF6.8000305@zabbo.net>
 <20120308155419.GB6777@thunk.org>
 <20120308180951.GB29510@shiny>
 <4F59148A.4070001@panasas.com>
 <20120308212412.GC11861@thunk.org>
 <20120308213808.GK29510@shiny>
 <20120308214148.GD11861@thunk.org>
 <20120309010207.GM29510@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Zach Brown <zab@zabbo.net>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43772 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab2CIQUS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 11:20:18 -0500
Content-Disposition: inline
In-Reply-To: <20120309010207.GM29510@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 08, 2012 at 08:02:07PM -0500, Chris Mason wrote:
> > Right before submission to the bio layer?  Or right before the device
> > driver sends the request to the host bus adapter?  I was thinking of
> > the latter....
> 
> blktrace can probably give us numbers for how big that wait is, but
> hopefully it is very small.  If it is too big, you can always bump
> nr_requests.

Not necessarily; things can get stalled for quite a while due to
ionice or io rate throttling.  There's quite a lot that can happen
after submit_bio, at the cfq layer, for example.

						- Ted
