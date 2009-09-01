From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Data integrity built into the storage stack
Date: Tue, 1 Sep 2009 14:44:04 +0200
Message-ID: <20090901124403.GC1371@ucw.cz>
References: <87f94c370908291423ub92922ft2cceab9e34ac6207@mail.gmail.com> <yq1hbvntf62.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1hbvntf62.fsf@sermon.lab.mkp.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> I do agree that we do have to be more prepared for collateral damage
> scenarios.  As we discussed at LS we have 4KB drives coming out that can
> invalidate previously acknowledged I/Os if it gets a subsequent write
> failure on a sector.  And there's also the issue of fractured writes

Hmmm, future will be interesting.

'ext3 expects disks to behave like disks from 1995' (alarming).

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
