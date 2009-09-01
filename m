From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Tue, 1 Sep 2009 10:46:50 +0200
Message-ID: <20090901084650.GF9942@elf.ucw.cz>
References: <20090901005629.3932.qmail@science.horizon.com> <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Spelvin <linux@horizon.com>, david@lang.hm,
	linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37252 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZIAIqz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Sep 2009 04:46:55 -0400
Content-Disposition: inline
In-Reply-To: <4a2c5faeb04cab59af9ba6ab512c9916.squirrel@neil.brown.name>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 2009-09-01 18:36:22, NeilBrown wrote:
> On Tue, September 1, 2009 10:56 am, George Spelvin wrote:
> > The fact that the ZFS decelopers observed drives writing the data to the
> > wrong location emphasizes the importance of keeping the checksum with
> > the pointer.  An embedded checksum, no matter how good, can't tell you if
> > the data is stale; you need a way to distinguish versions in the pointer.
> 
> I would disagree with that.
> If the embedded checksum is a function of both the data and the address
> of the data (in whatever address space seems most appropriate) then it can
> still verify that the data found with the checksum is the data that was
> expected.
> And storing the checksum with the data (where it is practical) means
> index blocks can be more dense so on average fewer accesses to storage
> are needed.

Well, storing checksum with the pointer means that you catch dropped
writes, too.

Imagine the disk drive just fails to write block A. Adding checksum of
address will not catch that...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
