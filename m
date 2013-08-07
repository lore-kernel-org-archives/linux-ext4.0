From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING: CPU: 26 PID: 93793 at fs/ext4/inode.c:230
 ext4_evict_inode+0x4c9/0x500 [ext4]() still in 3.11-rc3
Date: Wed, 7 Aug 2013 17:33:34 +0200
Message-ID: <20130807153334.GC26516@quack.suse.cz>
References: <1375388059.2097.10.camel@buesod1.americas.hpqcorp.net>
 <20130801203320.GB31857@quack.suse.cz>
 <1375415926.2269.1.camel@buesod1.americas.hpqcorp.net>
 <20130807152050.GA26516@quack.suse.cz>
 <52026764.3090305@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Davidlohr Bueso <davidlohr@hp.com>,
	Theodore Ts'o <tytso@mit.edu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52026764.3090305@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 07-08-13 08:27:32, Guenter Roeck wrote:
> On 08/07/2013 08:20 AM, Jan Kara wrote:
> >On Thu 01-08-13 20:58:46, Davidlohr Bueso wrote:
> >>On Thu, 2013-08-01 at 22:33 +0200, Jan Kara wrote:
> >>>   Hi,
> >>>
> >>>On Thu 01-08-13 13:14:19, Davidlohr Bueso wrote:
> >>>>FYI I'm seeing loads of the following messages with Linus' latest
> >>>>3.11-rc3 (which includes 822dbba33458cd6ad)
> >>>   Thanks for notice. I see you are running reaim to trigger this. What
> >>>workload?
> >>
> >>After re-running the workloads one by one, I finally hit the issue again
> >>with 'dbase'. FWIW I'm using ramdisks + ext4.
> >   Hum, I'm not able to reproduce this with current Linus' kernel - commit
> >e4ef108fcde0b97ed38923ba1ea06c7a152bab9e - I've tried with ramdisk but no
> >luck. Are you using some special mount options?
> >
> I don't see this commit in the upstream kernel ?
  It is Linus's merge of Tejun's libata fix from Tuesday...

> I tried reproducing the problem on the same system I had seen 822dbba33458cd6ad on,
> with the same workload. It has now been running since last Friday, but I have
> not seen any problems.
  Ah, OK, so it may be fixed after all. If you happen to see it again,
please let me know. Thanks!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
