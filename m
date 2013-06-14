From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: ext4 extent status tree LRU locking
Date: Fri, 14 Jun 2013 08:57:44 -0700
Message-ID: <51BB3D78.2070907@intel.com>
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130614140940.GA20401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 06/14/2013 07:09 AM, Zheng Liu wrote:
> -	INIT_LIST_HEAD(&scanned);
> -
>  	spin_lock(&sbi->s_es_lru_lock);
> +	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
>  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {

How long can this list get?  I have the feeling this might get a bit
painful, especially on a NUMA machine.

But, it definitely eliminates the spinlock contention that I was seeing.
 The top ext4 function in my profiles is way down under 1% of CPU time
now.  Thanks for the quick response, and please let me know if you need
any further testing.
