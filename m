From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: minix/ext2 + rd problem
Date: Wed, 15 Oct 2008 13:22:54 -0600
Message-ID: <20081015192254.GL15064@parisc-linux.org>
References: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu> <20081015041644.GA24613@wotan.suse.de> <alpine.DEB.1.10.0810150943350.3259@krichy.tvnetwork.hu> <20081015140523.GA30641@wotan.suse.de> <alpine.DEB.1.10.0810151609230.21953@krichy.tvnetwork.hu> <20081015143425.GA2316@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Kojedzinszky <krichy@tvnetwork.hu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081015143425.GA2316@wotan.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 15, 2008 at 04:34:25PM +0200, Nick Piggin wrote:
> You can flush and invalidate the blockdev with the --flushbufs argument
> to blockdev command. However you can't use this with ramdisk devices:
> someone thought it would be a good idea to save on precious ioctl space
> and implemented totally different semantics on that device with the
> same ioctl (it throws away the underlying data as well as the cache).

What happens if we declare that a bug and fix it (and add a new ioctl to
actually throw away the data ... oh, wait, we have one, it's BLKDISCARD)?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
