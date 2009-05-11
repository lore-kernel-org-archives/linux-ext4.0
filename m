From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 07:39:48 -0600
Message-ID: <20090511133947.GE8112@parisc-linux.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu> <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, J?rn Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 09:10:15AM -0400, Greg Freemyer wrote:
> That implies that the SSD folks are not treating erase blocks as a
> contiguous group of sectors.  For some reason, I thought their was
> only one mapping per erase block and within the erase block the
> sectors were contiguous..

I believe there is a mapping per LBA, not per erase block.  Of course,
different technologies will have different limitations here, but it
would be foolish to assume anything about SSDs at this point.

(For those who haven't heard my disclaimer before, the Intel SSD team
don't tell me anything fun about how the drives work internally).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
