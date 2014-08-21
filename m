From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock in
 non-movable area
Date: Thu, 21 Aug 2014 14:38:00 -0700
Message-ID: <20140821143800.8eef83c98bffbeb700830edf@linux-foundation.org>
References: <53EC4531.1000904@lge.com>
	<20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
	<20140816185208.GA1589@quack.suse.cz>
	<53F153B4.1060309@lge.com>
	<20140818032422.GD23084@thunk.org>
	<53F184B6.5080503@lge.com>
	<20140818121146.GD9603@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Gioh Kim <gioh.kim@lge.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?Q?=EC=9D=B4?= =?UTF-8?Q?=EA=B1=B4=ED=98=B8?=
	<gunho.lee@lge.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140818121146.GD9603@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 18 Aug 2014 14:11:46 +0200 Jan Kara <jack@suse.cz> wrote:

> > >Yes, but are you actually *using* the ext4 partitions for anything?
> > >If this is a realistic real world use case, file systems are used to
> > >store, well, files, and that means there will be inodes and dentry
> > >cache entries that will also be allocated.  Does your test scenario
> > >reflect real world usage?
> > 
> > Yes. I'm working for LG Electronics.
> > My test platform is currently selling item in the market.
> > And also I test my patch when my platform is working as if real user uses it.
>   Great, this is exactly what I was looking for. So if it really makes
> your usecase work I don't have objections to your solution (after you
> change what Andrew suggested).

Yup.  This sort os real-world usage information is terribly important
and the more you can tell us the better.  It helps us all to allocate
our time to the places where it is most needed...
