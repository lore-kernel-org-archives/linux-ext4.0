From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Wed, 5 Dec 2012 10:05:27 -0500
Message-ID: <20121205150527.GD18885@thunk.org>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com>
 <50BE007D.5080504@huawei.com>
 <50BE16EC.6060501@tao.ma>
 <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
 <50BF52F9.5080707@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qixuan wu <wuqixuan@gmail.com>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36926 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab2LEPFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Dec 2012 10:05:39 -0500
Content-Disposition: inline
In-Reply-To: <50BF52F9.5080707@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 05, 2012 at 09:58:17PM +0800, Tao Ma wrote:
> Are you sure the disk is good? I just checked the code in e2fsprogs, it
> seems that it will not complain if rec_len = 0, and the dir iteration
> just aborts.

Um, where are you seeing this?  It should be complaining that the
directory entry is corrupt if rec_len < 12.  I believe I see the
checks there, but I haven't tried creating some test file systems to
be sure.

						- Ted
