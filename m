From: Jan Kara <jack@suse.cz>
Subject: Re: Panic with ext4,nbd,qemu-img,block
Date: Thu, 25 Jan 2018 10:26:59 +0100
Message-ID: <20180125092659.wi2bj3gvv6ezmiuj@quack2.suse.cz>
References: <0555d0c0-1f42-e78f-28ab-6c7a00f0c020@windriver.com>
 <20180120234028.GB4451@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Hongzhi, Song" <hongzhi.song@windriver.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751429AbeAYJ1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Jan 2018 04:27:03 -0500
Content-Disposition: inline
In-Reply-To: <20180120234028.GB4451@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 20-01-18 18:40:28, Theodore Ts'o wrote:
> On Sat, Jan 20, 2018 at 04:41:00PM +0800, Hongzhi, Song wrote:
> > 
> > 329.11 EXT4-fs (nbd0): mounted filesystem with ordered data mode. Opts:
> > (null)
> > 329.12 block nbd0: Connection timed out
> > 329.13 block nbd0: shutting down sockets
> 
> That's your problem.  I'm guessing qemu-nbd is dying for some reason,
> which is causing the nbd device to fail (hence the "connection timed
> out").

All those filesystem errors are obviously his problem but:

329.45 ------------[ cut here ]------------
329.46 kernel BUG at /kernel-source//fs/buffer.c:3091!
329.47 invalid opcode: 0000 [#1] PREEMPT SMP
...

is a kernel problem. Hongzhi, can you please track down which line in
submit_bh_wbc() is line 3091 in your sources? I'd be interested in which
assertion actually failed. My best bets would be on
	BUG_ON(!buffer_mapped(bh));
but I'm not sure...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
