From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Thu, 08 Mar 2012 12:01:50 -0500
Message-ID: <yq1linbf2m9.fsf@sermon.lab.mkp.net>
References: <20120305125029.GA5121@gmail.com> <20120307005130.GH3592@dastard>
	<A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
	<yq1k42xhulg.fsf@sermon.lab.mkp.net> <20120307121138.GK3592@dastard>
	<yq1vcmfhga2.fsf@sermon.lab.mkp.net> <20120308070720.GP3592@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Andreas Dilger <aedilger@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120308070720.GP3592@dastard> (Dave Chinner's message of "Thu,
	8 Mar 2012 18:07:20 +1100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

Dave> 2TB chunks, IIRC - the lower 32 bits of the 48bit LBA was intended
Dave> to be the relative offset into the region (RBA), with the upper 16
Dave> bits being the region number.

Correct.


>> However, that was shot down pretty hard.

Dave> That's unfortunate - it maps really well to how XFS uses
Dave> allocation groups.

The proposal met a lot of resistance. To the extent that the SMR folks
were asked to develop a new command set instead of using the standard
SCSI Block Commands.

I still think we can get most of what you want out of the static access
hints, however.


Dave> So the current proposal hides all the physical characteristics of
Dave> the devices from the file system and remaps the LBA internally
Dave> based on the IO hint? But that is the opposite direction to what
Dave> we've been taking over the past couple of years - we want more
Dave> visibility of device characteristics at the filesystem level so we
Dave> can optimise the filesystem better, not less.

The standards bodies are trying to avoid having to special-case handling
of shingled drives since they are only a transitional technology with a
short life expectancy.

We're getting close to the 8-year mark for 4K logical block size
transition and it hasn't happened yet. And at this stage it looks like
it might not happen at all (in the consumer space at least).

So I am not entirely convinced that SMR drives will still be relevant
when the standards have been ratified and the filesystems of the world
adapted to work with them.

-- 
Martin K. Petersen	Oracle Linux Engineering
