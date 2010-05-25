From: tytso@mit.edu
Subject: Re: [PATCH 5/8] tracing: Convert more ext4 events to DEFINE_EVENT
Date: Tue, 25 May 2010 10:57:56 -0400
Message-ID: <20100525145756.GJ5556@thunk.org>
References: <4BFA3728.3000701@cn.fujitsu.com>
 <4BFA37A4.1050208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BFA37A4.1050208@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 24, 2010 at 04:24:04PM +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS, and save ~2.7K:
> 
>    text    data     bss     dec     hex filename
>  274441    7200     260  281901   44d2d fs/ext4/ext4.o.orig
>  271881    7040     256  279177   44289 fs/ext4/ext4.o
> 
> 4 events are converted:
> 
>   ext4__mb_new_pa: ext4_mb_new_inode_pa, ext4_mb_new_group_pa
>   ext4__mballoc:   ext4_mballoc_discard, ext4_mballoc_free
> 
> No change in functionality.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, added to the ext4 tree.

					- Ted
