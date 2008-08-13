From: Christian Hesse <mail@eworm.de>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Wed, 13 Aug 2008 23:07:06 +0200
Message-ID: <200808132307.07437.mail@eworm.de>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de> <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kolab.mylinuxtime.de ([212.112.242.22]:50789 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYHMVHJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 17:07:09 -0400
In-Reply-To: <20080813210408.GC6142@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wednesday 13 August 2008, Theodore Tso wrote:
> On Wed, Aug 13, 2008 at 10:55:07PM +0200, Christian Hesse wrote:
> > > Can you reproduce the bug?
> >
> > I can. ;)
>
> Great!  I haven't been able to reproduce it myself, but I was using a
> very quick test case on small toy filesystem.  My ext4 root filesystem
> is 100% extent based files --- and this bug is only happening on
> old-style files with indirect-block-style inodes.  And I'm trying to
> get things done before leaving for a family reunion on Friday, so I
> just don't have the time to set up a reproducer.
>
> Can you verify whether or not my patch fixes things for you?

Please look at the bottom of my last two mails... That was with your patch 
applied.
-- 
Regards,
Chris
