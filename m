From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Tue, 4 Dec 2012 15:45:08 -0500
Message-ID: <20121204204508.GG7790@thunk.org>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com>
 <50BE007D.5080504@huawei.com>
 <50BE16EC.6060501@tao.ma>
 <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: qixuan wu <wuqixuan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 05, 2012 at 12:16:50AM +0800, qixuan wu wrote:
> 
>     Is there the possibility: one thread(A) is read_dir(directly read
> from buffer head), and another thread(B) is creating item, and fill
> this buffer header at the same time. During create item, first modify
> the last item's rec_len(let it point to next item which initially is
> zero), then fill this added new item.

This should be handled by the VFS, which uses i_mutex to protect
directories before calling the filesystem-specific lookup, rename,
readdir, etc functions.

So absent some bug where we are missing taking i_mutex (a quick check
didn't show any obvious missing paths, although I didn't do an
exhaustive code audit), we should be OK.... if we had a bug here, I
would have expected that one of the fs stress tests that we run would
have shown them up pretty quickly.

Regards,

						- Ted
