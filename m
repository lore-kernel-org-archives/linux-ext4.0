From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Fri, 14 Jun 2013 09:55:53 -0700
Message-ID: <51BB4B19.6040409@intel.com>
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com> <51BB3D78.2070907@intel.com> <20130614171116.GB21544@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130614171116.GB21544@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/14/2013 10:11 AM, Zheng Liu wrote:
> On Fri, Jun 14, 2013 at 08:57:44AM -0700, Dave Hansen wrote:
>> > On 06/14/2013 07:09 AM, Zheng Liu wrote:
>>> > > -	INIT_LIST_HEAD(&scanned);
>>> > > -
>>> > >  	spin_lock(&sbi->s_es_lru_lock);
>>> > > +	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
>>> > >  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
>> > 
>> > How long can this list get?  I have the feeling this might get a bit
>> > painful, especially on a NUMA machine.
> I guess that you worry about the time of sorting a lru list, right?

Yeah, just worried about the amount of time it takes to examine (and
possibly write to) every item on the list.
