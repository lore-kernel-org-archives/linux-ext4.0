From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Ext4 developers get-together at the Collab Summit
Date: Fri, 18 Jan 2013 10:53:45 -0500
Message-ID: <20130118155345.GA22451@localhost.localdomain>
References: <nsxzk0blt27.fsf@closure.thunk.org>
 <20130116120156.GF29162@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab3ARPyj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 10:54:39 -0500
Content-Disposition: inline
In-Reply-To: <20130116120156.GF29162@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed, Jan 16, 2013 at 01:01:56PM +0100, Jan Kara wrote:
>   Hello Ted,
> 
> On Mon 14-01-13 09:48:00, Ted Tso wrote:
> > 	The Linux Foundation's Collaboration Summit is April 15-17th,
> > and the Linux Storage, File System, and MM Summit is April 18-19th in
> > San Francisco (at the Parc 55 hotel).
> > 
> > 	I'd like to organize an ext4 developer's meeting during the
> > Collab Summit sometime April 15-17th, since so many of us will hopefully
> > be attending LSF.  (The CFP will hopefully be coming soon for LSF.)
> > 
> > 	If you're interested in attending, please reply to this thread,
> > and include some suggested topics that you'd be interested in
> > discussing.  Based on the number of topics and the number of people who
> > are planning on attending, I'll know how much time we need to reserve
> > and how big of a room to request.
>   I'd be interested in attending the ext4 meeting this year. What I'd like
> to do for the meeting is creating a "map" of ext4 mount options / features
> where we'd see what mount options do we have, which options (or fs features)
> work together and which don't. Then we can either convince ourselves the
> situation with too many / too complex interactions isn't that bad or we can
> come up with simplifications to work on.
> 
> 								Honza

I think that would be useful to extend this discussion to ext2/ext3 mount
options inclusive and merge my suggested topic with this one to find a better
approach of how to deal with all possible mount options existing in ext4 module
for all extX filesystem family.

Cheers,
-- 
Carlos
