From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Sat, 15 Jun 2013 01:11:16 +0800
Message-ID: <20130614171116.GB21544@gmail.com>
References: <51B7B128.60909@intel.com>
 <20130614140940.GA20401@gmail.com>
 <51BB3D78.2070907@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51BB3D78.2070907@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 14, 2013 at 08:57:44AM -0700, Dave Hansen wrote:
> On 06/14/2013 07:09 AM, Zheng Liu wrote:
> > -	INIT_LIST_HEAD(&scanned);
> > -
> >  	spin_lock(&sbi->s_es_lru_lock);
> > +	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
> >  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> 
> How long can this list get?  I have the feeling this might get a bit
> painful, especially on a NUMA machine.

I guess that you worry about the time of sorting a lru list, right?
Ted and I also worry about this, especially when shrinker is called()
very frequently.  Ted has presented a solution.  I will give it a try.

> 
> But, it definitely eliminates the spinlock contention that I was seeing.
>  The top ext4 function in my profiles is way down under 1% of CPU time
> now.  Thanks for the quick response, and please let me know if you need
> any further testing.

Thanks for your help.  As I said above, I will try to improve this patch
later.  My server's numa has been turned off in BIOS and I haven't a
privilege to turn it on.  So that would be great if you could help me to
do some further testing.

Thanks in advance,
                                                - Zheng
