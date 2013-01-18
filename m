From: Jan Kara <jack@suse.cz>
Subject: Re: Ext4 developers get-together at the Collab Summit
Date: Fri, 18 Jan 2013 18:14:57 +0100
Message-ID: <20130118171457.GA18458@quack.suse.cz>
References: <nsxzk0blt27.fsf@closure.thunk.org>
 <20130116120156.GF29162@quack.suse.cz>
 <20130118155345.GA22451@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab3ARRPA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 12:15:00 -0500
Content-Disposition: inline
In-Reply-To: <20130118155345.GA22451@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 18-01-13 10:53:45, Carlos Maiolino wrote:
> On Wed, Jan 16, 2013 at 01:01:56PM +0100, Jan Kara wrote:
> >   Hello Ted,
> > 
> > On Mon 14-01-13 09:48:00, Ted Tso wrote:
> > > 	The Linux Foundation's Collaboration Summit is April 15-17th,
> > > and the Linux Storage, File System, and MM Summit is April 18-19th in
> > > San Francisco (at the Parc 55 hotel).
> > > 
> > > 	I'd like to organize an ext4 developer's meeting during the
> > > Collab Summit sometime April 15-17th, since so many of us will hopefully
> > > be attending LSF.  (The CFP will hopefully be coming soon for LSF.)
> > > 
> > > 	If you're interested in attending, please reply to this thread,
> > > and include some suggested topics that you'd be interested in
> > > discussing.  Based on the number of topics and the number of people who
> > > are planning on attending, I'll know how much time we need to reserve
> > > and how big of a room to request.
> >   I'd be interested in attending the ext4 meeting this year. What I'd like
> > to do for the meeting is creating a "map" of ext4 mount options / features
> > where we'd see what mount options do we have, which options (or fs features)
> > work together and which don't. Then we can either convince ourselves the
> > situation with too many / too complex interactions isn't that bad or we can
> > come up with simplifications to work on.
> 
> I think that would be useful to extend this discussion to ext2/ext3 mount
> options inclusive and merge my suggested topic with this one to find a better
> approach of how to deal with all possible mount options existing in ext4 module
> for all extX filesystem family.
  I don't know but I don't have problems with the number of ext2/ext3
options and their combination work as expected. Furthermore even if we
found some possible simplifications, ext2 and ext3 are in
maintenance-mostly mode so some larger changes to features are really out
of question anyway. So I don't think it would be worth the time. But if you
have some particular ext2/3 mount options you have problem with, I'm happy
to listen.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
