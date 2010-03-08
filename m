From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: discard + LVM
Date: Mon, 08 Mar 2010 14:46:12 -0500
Message-ID: <yq1tysqa96j.fsf@sermon.lab.mkp.net>
References: <4B922929.5020006@zappa.cx> <4B933BD6.80100@redhat.com>
	<yq18wa4c9qn.fsf@sermon.lab.mkp.net>
	<170fa0d21003080854l1c7e8a76w277b1d1ce51da2e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Sundstrom <sunkan@zappa.cx>,
	linux-ext4@vger.kernel.org, dm-devel@redhat.com,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d21003080854l1c7e8a76w277b1d1ce51da2e@mail.gmail.com>
	(Mike Snitzer's message of "Mon, 8 Mar 2010 11:54:45 -0500")
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> We've been scoping the work associated with adding discard support
Mike> to DM (afaik MD would need comparable infrastructure, e.g.:
Mike> spliting discard requests).

Mike> There is a fair amount of complexity associated with this work.
Mike> Especially when you look to support discards for some of the more
Mike> advanced DM targets.  Discard support for the 'linear' target is
Mike> the relatively low hanging fruit.  The 'striped' target gets more
Mike> interesting (having to split the discard into multiple discards to
Mike> submit to the appropriate underlying devices in the striped
Mike> volume).

Mike> One thought was we might have a block layer hook along the lines
Mike> of the q->merge_bvec_fn (similar but hopefully less
Mike> problematic/controversial).  Christoph removed a hook that was
Mike> vaguely like this, but posed allocation problems, with linux-2.6
Mike> commit: c15227de132f

This is a work in progress and something that turned out to be much
harder than I anticipated.  Discard is not the only problem child here.
The other one is write same.  In both cases we'll have to split things
that cover an area bigger than the corresponding bio_vec payload.

At first I took the blk_pc splitting approach but it got really hairy
and had lots of special casing.  So what I'm working on right now is to
make write same and discard requests first class citizens so they can be
split and merged like regular write requests.  There are lots of
assumptions in our stack about things being either read or write so it's
a pretty invasive change.  But at this point it looks like it'll be
nicer than my first attempt.  Still plugging away at it though...

-- 
Martin K. Petersen	Oracle Linux Engineering
