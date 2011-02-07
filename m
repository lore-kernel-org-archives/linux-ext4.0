From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Mon, 07 Feb 2011 09:21:47 -0800
Message-ID: <1297099307.3207.56.camel@mingming-laptop>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com>
	 <AANLkTi=YxSpgm9vYHBKdASpLOaY_U3=ggsE8yTg_G0Bc@mail.gmail.com>
	 <20110204131739.GC4104@quack.suse.cz>  <4D4C3154.3020502@gmail.com>
	 <1296839873.3025.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <ricwheeler@gmail.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Michael Rubin <mrubin@google.com>,
	lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37910 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1BGRV6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 12:21:58 -0500
In-Reply-To: <1296839873.3025.39.camel@mulgrave.site>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-02-04 at 11:17 -0600, James Bottomley wrote:
> On Fri, 2011-02-04 at 12:03 -0500, Ric Wheeler wrote:
> > On 02/04/2011 08:17 AM, Jan Kara wrote:
> > > On Thu 03-02-11 11:32:01, Michael Rubin wrote:
> > >> On Thu, Feb 3, 2011 at 7:08 AM, Eric Sandeen<sandeen@redhat.com>  wrote:
> > >>> If we can have a real plan for moving in this direction though, I'd
> > >>> support it.  I'm just not sure how we get enough real testing under
> > >>> our belts to be comfortable with dropping ext[23], especially as
> > >>> most distros now default to ext4 anyway.
> > >> Eric what sort of testing are you looking for?
> > > I believe Ted wrote a good summary of what combinations of options would
> > > need to be tested on a regular basis to get at least some confidence that
> > > the switch could work.
> > >
> > >> I admit I like having ext2 around for comparisons in bug situations.
> > >> It really helps to isolate the problem area. How painful is the
> > >> upkeep?
> > > Well, for me it's a couple of hours per week on average I'd say. Plus
> > > there is some work other people do when changing some VFS/MM interfaces
> > > influencing all the filesystems.
> > >
> > > The time I spend is enough to keep ext3 in a good shape I believe but I
> > > have a feeling that ext2 is slowly bitrotting. Sometime when I look at
> > > ext2 code I see stuff we simply do differently these days and that's just
> > > a step away from the code getting broken... It would not be too much work
> > > to clean things up and maintain but it's a work with no clear gain (if you
> > > do the thankless job of maintaining old code, you should at least have
> > > users who appreciate that ;) so naturally no one does it.
> > >
> > > 								Honza
> > 
> > I would definitely be interesting in figuring out if and when we can drop one or 
> > both of ext2 and ext3. The number of actively supported file systems to test for 
> > correctness and performance is getting to be a challenge.
> 
> ext2 yes ... I think there's no way we can drop ext3: it's still a
> current default filesystem for most distributions.  Now, if we discuss
> dropping ext2 and working out an end of life plan for ext3 (for the
> feature removals schedule) so we don't eventually get into the same
> position with it as we are with ext2, then this sounds like a plan.
> 

I second this. Clearly we see ext2 is sunsetting, especially given ext4
has no journal mode already. For ext3, it still widely used by many
users, though we have a way to migrate ext3 to ext4 there but still it
require quit brainstorming to figure out what need to improve in ext4 to
handle ext3 filesystem files more smoothly. Having a plan discussion
sounds interesting to me.

Mingming

> > Great topic, might require beer though to be done right :)
> 
> I'm invoking the anti-discrimination statutes here on behalf of those of
> us who don't like beer.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


