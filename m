From: Manoj Joseph <manoj.joseph@gmail.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
Date: Sat, 28 Apr 2007 02:24:33 +0530
Message-ID: <46326309.3050104@gmail.com>
References: <1177660767.6567.41.camel@Homer.simpson.net> <20070427013350.d0d7ac38.akpm@linux-foundation.org> <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org> <20070427193130.GD5967@schatzie.adilger.int> <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Marat Buharov <marat.buharov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757162AbXD0Uzw@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704271246550.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 27 Apr 2007, Andreas Dilger wrote:
>> It's true that this is a "feature" of ext3 with data=ordered (the default),
>> but I suspect the same thing is now true in reiserfs too.
> 
> Oh, well.. Journalling sucks.

Go back to ext2? ;)

> I was actually _really_ hoping that somebody would come along and tell 
> everybody that this whole journal-logging is stupid, and that it's just 
> better to not ever re-write blocks on disk, but instead write to new 
> blocks with version numbers (and not re-use old blocks until new versions 
> are stable on disk).

Ah, "copy on write"! ZFS (Sun) and WAFL (NetApp) does this. Don't know 
about WAFL, but ZFS does logging too.

-Manoj

-- 
Manoj Joseph
http://kerneljunkie.blogspot.com/
