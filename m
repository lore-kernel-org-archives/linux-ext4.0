From: torn5 <torn5@shiftmail.org>
Subject: Re: [PATCH 3/3] ext4: Deprecate barrier= and nobarrier mount options
Date: Wed, 26 Jan 2011 14:29:54 +0100
Message-ID: <4D4021D2.2000407@shiftmail.org>
References: <20110126071200.GE32261@tux1.beaverton.ibm.com>
 <20110126072329.GK27190@tux1.beaverton.ibm.com>
 <20110126093632.GB12520@htj.dyndns.org> <20110126104734.GA23245@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj@kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
	tytso@mit.edu, shli@kernel.org, neilb@suse.de,
	adilger.kernel@dilger.ca, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
	josef@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110126104734.GA23245@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/26/2011 11:47 AM, Jan Kara wrote:
>   Hello,
>
> On Wed 26-01-11 10:36:32, Tejun Heo wrote:
>   Ted should have a final word about this but I believe it's possible to
> deprecate the mount options. Maybe with some transition period where
> deprecation message is shown but the option actually still works.

+1 for this from a user.

I'd like to see this moved to blockdev sysfs in the long term.

During the transition period there could be both the old barrier mount
option (with a deprecated warning upon use) and the sysfs knobs.

Flush and FUA would be delivered to disk only if both the barriers are
enabled in the mount options (which is also the default) and the sysfs
are at "noignore" value. Alternatively, the barrier mount option could
affect the sysfs knobs values upon mount. Eventually the barrier mount
option would be removed becoming always-on, leaving only the sysfs knobs.
