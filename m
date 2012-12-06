From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 6 Dec 2012 23:48:20 +0800
Message-ID: <CAEjEV8Cfy2OzEvFH1c60qFMm7r5a19uqCCfhjhCR2FS-zrG24w@mail.gmail.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
	<50BCE885.8010609@redhat.com>
	<50BE007D.5080504@huawei.com>
	<50BE16EC.6060501@tao.ma>
	<CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
	<50BF52F9.5080707@tao.ma>
	<20121205150527.GD18885@thunk.org>
	<50BFFAD6.60400@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:43093 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423972Ab2LFPsW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Dec 2012 10:48:22 -0500
In-Reply-To: <50BFFAD6.60400@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Tao,

On Thu, Dec 6, 2012 at 9:54 AM, Tao Ma <tm@tao.ma> wrote:
> On 12/05/2012 11:05 PM, Theodore Ts'o wrote:
>> On Wed, Dec 05, 2012 at 09:58:17PM +0800, Tao Ma wrote:
>>> Are you sure the disk is good? I just checked the code in e2fsprogs, it
>>> seems that it will not complain if rec_len = 0, and the dir iteration
>>> just aborts.
>>
>> Um, where are you seeing this?  It should be complaining that the
>> directory entry is corrupt if rec_len < 12.  I believe I see the
>> checks there, but I haven't tried creating some test file systems to
>> be sure.
> Oh, sorry my fault. Yes, I see a final com_err in the end of do_list_dir
> in debugfs. So we should complain about the dir corruption.

I have already also checked the raw binary of the dir block in the
disk and the data is correct. So disk no issue, only data in mem is
corrupted.

> Thanks
> Tao
