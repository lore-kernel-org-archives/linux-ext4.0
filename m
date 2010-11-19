From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 09:02:03 -0500
Message-ID: <20101119140203.GC10039@thunk.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org>
 <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven Whitehouse <swhiteho@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE68155.50705@teksavvy.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 19, 2010 at 08:53:25AM -0500, Mark Lord wrote:
> There is a very good reason why faster implementations may be *difficult*
> (if not impossible) in many cases:  DETERMINISTIC trim.  This requires
> that the drive guarantee the block ranges will return a constant known
> value after TRIM.  Which means they MUST write to flash during the trim.
> And any WRITE to flash means a potential ERASE operation may be needed.

Deterministic TRIM is an option.  It doesn't have to be implemented.
And as you even pointed out, there are ways of doing this
intelligently.  Whether "intelligently" and "drive firmware authors"
are two phrases that should be used in the same sentence is a concern
that I will grant, but that's why mount -o discard is not the default.

> Non-deterministic TRIM should also try to ensure that the original data
> is no longer there (for security reasons), so it may have the same issues.

Says who?  We've deleted files on hard drives for a long time without
scrubbing data blocks.  Why should a non-deterministic trim be any
different.  If the goal is a better performing SSD, and not security,
then non-deterministic trim should definitely _not_ ensure that the
original data is no longer accessible.

						- Ted
