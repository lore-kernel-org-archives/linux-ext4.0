From: qixuan wu <wuqixuan@gmail.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Wed, 5 Dec 2012 23:46:03 +0800
Message-ID: <CAEjEV8A=VNY6tSwzJPG32WqO0yNzvgcv8QsqBYEy6KiX7WVgSA@mail.gmail.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
	<50BCE885.8010609@redhat.com>
	<50BE007D.5080504@huawei.com>
	<50BE16EC.6060501@tao.ma>
	<CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
	<50BF52F9.5080707@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizefan@huawei.com>, Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	wuqixuan@huawei.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <50BF52F9.5080707@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Tao,

On Wed, Dec 5, 2012 at 9:58 PM, Tao Ma <tm@tao.ma> wrote:
> Hi qixuan,
> On 12/05/2012 12:16 AM, qixuan wu wrote:
>> Hi Tao, all,
>>
>>     I guess it's a memory(or ext3/kenrel) issue. Beause in one
>> machine, after report this issue, the partition is made to readonly,
>> we use debugfs to "ls dir", and it's fine. It can list all files
>> without error. If the disk has issue, when we using ls command, it
>> will give error also. (The dir name is also using debugfs to get by
>> issue inode ID.)
> Are you sure the disk is good? I just checked the code in e2fsprogs, it
> seems that it will not complain if rec_len = 0, and the dir iteration
> just aborts. I guess the right way should be dd the corresponding block
> out, decode and read it in binary format. :(

    Good idea, will do it.

Thanks
wuqixuan

> Thanks
> Tao
