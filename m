From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch 0/5] Journal guided resync and support
Date: Tue, 24 Nov 2009 12:43:19 +0100
Message-ID: <20091124114319.GA1397@ucw.cz>
References: <20091119212241.283629302@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: scjody@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55233 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbZKXMCY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Nov 2009 07:02:24 -0500
Content-Disposition: inline
In-Reply-To: <20091119212241.283629302@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> This is an updated implementation of journal guided resync, intended to be
> suitable for production systems.  This feature addresses the problem with RAID
> arrays that take too long to resync - similar to the existing MD write-intent
> bitmap feature, we resync only the stripes that were undergoing writes at the
> time of the crash.  Unlike write-intent bitmaps, our testing shows very little
> performance degredation as a result of the feature - around 3-5% vs around 30%
> for bitmaps.

Good. Now when fs know about raid and wise versa... perhaps it is time
to journal surrounding data on stripe so that power fails do not
destroy data on degraded raid5?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
