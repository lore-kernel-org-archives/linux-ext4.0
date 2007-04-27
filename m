From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Date: Fri, 27 Apr 2007 13:12:35 -0700
Message-ID: <20070427201235.GA11170@gnuppy.monkey.org>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>,
	"Bill Huey (hui)" <billh@gnuppy.monkey.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757184AbXD0UNO@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 27, 2007 at 12:50:34PM -0700, Linus Torvalds wrote:
> Oh, well.. Journalling sucks.
> 
> I was actually _really_ hoping that somebody would come along and tell 
> everybody that this whole journal-logging is stupid, and that it's just 
> better to not ever re-write blocks on disk, but instead write to new 
> blocks with version numbers (and not re-use old blocks until new versions 
> are stable on disk).
> 
> There was even somebody who did something like that for a PhD thesis, I 
> forget the details (and it apparently died when the thesis was presumably 
> accepted ;).

That sounds a whole lot like NetApp's WAFL file system and is heavily patented.

bill
