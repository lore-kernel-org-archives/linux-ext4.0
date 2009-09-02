From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e4defrag: fallocate donor file only once
Date: Wed, 02 Sep 2009 16:24:04 -0600
Message-ID: <20090902222404.GY4197@webber.adilger.int>
References: <1251905704-10078-1-git-send-email-bergwolf@gmail.com>
 <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Peng Tao <bergwolf@gmail.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57492 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZIBWXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 18:23:53 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n82MNtgD025163
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 15:23:55 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPD007007B0PX00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 02 Sep 2009 15:23:55 -0700 (PDT)
In-reply-to: <87f94c370909021509u7d07a6e5ia210cfd8b8db70e0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 02, 2009  18:09 -0400, Greg Freemyer wrote:
> On Wed, Sep 2, 2009 at 11:35 AM, Peng Tao<bergwolf@gmail.com> wrote:
> > If we allocate the donor file once for all, it will have a better chance
> > to be continuous.
> >
> > Signed-off-by: "Peng Tao" <bergwolf@gmail.com>
> 
> Seems like an improvement, but I'm not seeing any special handling for
> sparse files.  (Not before or after this patch.)
> 
> Seems like there should be an outer loop that identifies contiguous
> data block sets in a sparse file and defrags them individually as
> opposed to trying to defrag the entire file at once.
> 
> My impression is that with a large sparse file, e4defrag currently
> (with or without this patch) would fallocate a full non-sparse donor
> set of blocks the full size of the original file, then swap in just
> the truly allocated blocks?
> 
> If so, that is not very optimum.

And of course FIEMAP can be used to easily determine if the file is sparse.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

