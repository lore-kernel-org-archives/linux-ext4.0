From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount
 options
Date: Wed, 26 Jan 2011 11:51:39 +0100
Message-ID: <20110126105139.GJ12520@htj.dyndns.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
 <20110126093632.GB12520@htj.dyndns.org>
 <20110126104734.GA23245@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110126104734.GA23245@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Wed, Jan 26, 2011 at 11:47:34AM +0100, Jan Kara wrote:
>   Ted should have a final word about this but I believe it's possible to
> deprecate the mount options. Maybe with some transition period where
> deprecation message is shown but the option actually still works. That
> being said I'm not sure what we should do when someone has a disk with two
> partitions and one partition is mounted with barriers and another one
> without them - sure, one has to think hard to find a sane use case for this
> (possibly if user does not care about data after a crash on one of the
> partitions, in which case he should probably use nojournal mode) but it
> should probably work.

The policy can be made per-bdev (which maps to per-partition), so I
don't think that's a big problem.

Thanks.

-- 
tejun
