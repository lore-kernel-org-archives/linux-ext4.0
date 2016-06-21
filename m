From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] ext4: underflow in alignment check
Date: Tue, 21 Jun 2016 16:06:44 +0300
Message-ID: <20160621130644.GO32247@mwanda>
References: <20160616070709.GC23129@mwanda>
 <20160620160204.GG6882@quack2.suse.cz>
 <20160620195325.GM32247@mwanda>
 <20160621074353.GB3750@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160621074353.GB3750@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 21, 2016 at 09:43:53AM +0200, Jan Kara wrote:
> On Mon 20-06-16 22:53:26, Dan Carpenter wrote:
> > On Mon, Jun 20, 2016 at 06:02:04PM +0200, Jan Kara wrote:
> > > On Thu 16-06-16 10:07:09, Dan Carpenter wrote:
> > > > My static checker complains that this can underflow if arg is negative
> > > > which is true.
> > > > 
> > > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > 
> > > How come? (1 << 30) fits even into 32-bit signed type. So where's the
> > > problem?
> > 
> > Bad changelog...  I was talking about a different issue.  I was casting
> > it to unsigned to take advantage of type promototion.  Assume we have:
> > 
> > int arg = 1 << 31;
> > 
> > (arg > (1 << 30)) // <-- this is false
> > (arg > (1U << 30)) // <-- this is true so there is no underflow.
> 
> I see, but match_int() - or more precisely match_number() returns -ERANGE
> when the number is > INT_MAX, subsequently we check whether the number is <
> 0 (Opt_inode_readahead_blks has flag MOPT_GTE0 set) and bail out if yes. So
> at the place you are modifying we are sure the number is in [0, INT_MAX].
> So the condition (arg > (1 << 30)) is pointless - just defensive
> programming in case we decide e.g. to upgrade the type of 'arg' to long - but
> not wrong...

Ah.  Smatch wasn't able to figure out that MOPT_GTE0 was set.

Thanks for reviewing this.

regards,
dan carpenter
