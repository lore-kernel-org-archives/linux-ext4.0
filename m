From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Thu, 27 Aug 2009 00:19:02 -0500
Message-ID: <200908270019.04231.rob@landley.net>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20090826025849.GF32712@mit.edu>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 25 August 2009 21:58:49 Theodore Tso wrote:
> On Tue, Aug 25, 2009 at 09:15:00PM -0400, Ric Wheeler wrote:
> > I agree with the whole write up outside of the above - degraded RAID
> > does meet this requirement unless you have a second (or third, counting
> > the split write) failure during the rebuild.
>
> The argument is that if the degraded RAID array is running in this
> state for a long time, and the power fails while the software RAID is
> in the middle of writing out a stripe, such that the stripe isn't
> completely written out, we could lose all of the data in that stripe.
>
> In other words, a power failure in the middle of writing out a stripe
> in a degraded RAID array counts as a second failure.

Or panic, hang, the drive failed because the system is overheating because the 
air conditioner suddenly died and the server room is now an oven.  (Yup, 
worked at that company too.)

> To me, this isn't a particularly interesting or newsworthy point,
> since a competent system administrator

I'm a bit concerned by the argument that we don't need to document serious 
pitfalls because every Linux system has a sufficiently competent administrator 
they already know stuff that didn't even come up until the second or third day 
it was discussed on lkml.

"You're documenting it wrong" != "you shouldn't document it".

> who cares about his data and/or
> his hardware will (a) have a UPS,

I worked at a company that retested their UPSes a year after installing them 
and found that _none_ of them supplied more than 15 seconds charge, and when 
they dismantled them the batteries had physically bloated inside their little 
plastic cases.  (Same company as the dead air conditioner, possibly 
overheating was involved but the little _lights_ said everything was ok.)

That was by no means the first UPS I'd seen die, the suckers have a higher 
failure rate than hard drives in my experience.  This is a device where the 
batteries get constantly charged and almost never tested because if it _does_ 
fail you just rebooted your production server, so a lot of smaller companies 
think they have one but actually don't.

> , and (b) be running with a hot spare
> and/or will imediately replace a failed drive in a RAID array.

Here's hoping they shut the system down properly to install the new drive in 
the raid then, eh?  Not accidentally pull the plug before it's finished running 
the ~7 minutes of shutdown scripts in the last Red Hat Enterprise I messed 
with...

Does this situation apply during the rebuild?  I.E. once a hot spare has been 
supplied, is the copy to the new drive linear, or will it write dirty pages to 
the new drive out of order, even before the reconstruction's gotten that far, 
_and_ do so in an order that doesn't open this race window of the data being 
unable to be reconstructed?

If "degraded array" just means "don't have a replacement disk yet", then it 
sounds like what Pavel wants to document is "don't write to a degraded array 
at all, because power failures can cost you data due to write granularity 
being larger than filesystem block size".  (Which still comes as news to some 
of us, and you need a way to remount mount the degraded array read only until 
the sysadmin can fix it.)

But if "degraded array" means "hasn't finished rebuilding the new disk yet", 
that could easily be several hours' window and not writing to it is less of an 
option.

(I realize a competent system administrator would obviously already know this, 
but I don't.)

>        	    	       	       	 	      - Ted

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
