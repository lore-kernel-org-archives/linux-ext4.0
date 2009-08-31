From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
Date: Mon, 31 Aug 2009 13:04:48 +0200
Message-ID: <20090831105645.GD1353@ucw.cz>
References: <20090831005426.13607.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751898AbZHaLE6@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090831005426.13607.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> Actually, there is something the file system can do to make journaling
> safe on degraded RAIDs: make the (checksummed) journal blocks equal to
> the RAID stripe size.  Or, equivalently, pad out to the RAID stripe
> size each commit.
> 
> This sometimes leads to awkward block sizes, but while writing
> to any *one* stripe on a degraded RAID-5 endangers the others, you
> can write to *all* of them with the usual semantics.

Well, that would work... but you'd also have to journal data, with the
same block size. Not exactly fast, but at least safe...

> That's one thing I really like about ZFS: its policy of "don't trust
> the disks."  If nothing else, simply telling you "your disks f*ed up,
> and I caught them doing it", instead of the usual mysterious corruption
> detectec three months later, is tremendoudly useful information.

The more I learn about storage, the more I like idea of zfs. Given the
subtle issues between filesystem and raid layer, integrating them just
makes sense.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
