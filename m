From: Tao Ma <tm@tao.ma>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 06 Dec 2012 09:54:30 +0800
Message-ID: <50BFFAD6.60400@tao.ma>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com> <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com> <50BE16EC.6060501@tao.ma> <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com> <50BF52F9.5080707@tao.ma> <20121205150527.GD18885@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: qixuan wu <wuqixuan@gmail.com>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55317 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932072Ab2LFByf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 20:54:35 -0500
In-Reply-To: <20121205150527.GD18885@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/05/2012 11:05 PM, Theodore Ts'o wrote:
> On Wed, Dec 05, 2012 at 09:58:17PM +0800, Tao Ma wrote:
>> Are you sure the disk is good? I just checked the code in e2fsprogs, it
>> seems that it will not complain if rec_len = 0, and the dir iteration
>> just aborts.
> 
> Um, where are you seeing this?  It should be complaining that the
> directory entry is corrupt if rec_len < 12.  I believe I see the
> checks there, but I haven't tried creating some test file systems to
> be sure.
Oh, sorry my fault. Yes, I see a final com_err in the end of do_list_dir
in debugfs. So we should complain about the dir corruption.

Thanks
Tao
