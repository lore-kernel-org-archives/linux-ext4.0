From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: still running into WARNING: CPU: at fs/ext4/inode.c:230
 ext4_evict_inode+0x4a6/0x4e0
Date: Wed, 16 Oct 2013 08:56:07 -0700
Message-ID: <1381938967.4324.0.camel@buesod1.americas.hpqcorp.net>
References: <1381888924.2371.5.camel@buesod1.americas.hpqcorp.net>
	 <20131016125004.GC14278@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131016125004.GC14278@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2013-10-16 at 14:50 +0200, Jan Kara wrote:
> On Tue 15-10-13 19:02:04, Davidlohr Bueso wrote:
> > Hello Jan,
> > 
> > Just wanted to let you know I hit this[1] again on Linus' latest. The
> > setup/workload is *identical* to the reported one a few months ago.
> > 
> > [1] https://lkml.org/lkml/2013/8/1/532
> > 
> > Here's the complete output, I hope it helps...
>   Thanks for the headup. Last time I wasn't able to reproduce this and
> eventually forgot about the problem. Can I send you a debug patch and you
> would run a kernel with it? Thanks.

Sure.
