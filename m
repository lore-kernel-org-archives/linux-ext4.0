From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Thu, 6 Dec 2012 10:58:33 +0800
Message-ID: <CAGBYx2bw4D_MDzNGS-QO92tuJvTN2=j6f1u0Y3ReBM-mj33EOA@mail.gmail.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com>
 <50BE16EC.6060501@tao.ma> <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
 <50BF52F9.5080707@tao.ma> <CAEjEV8A=VNY6tSwzJPG32WqO0yNzvgcv8QsqBYEy6KiX7WVgSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tao Ma <tm@tao.ma>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	wuqixuan@huawei.com
To: qixuan wu <wuqixuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37895 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2LFC6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Dec 2012 21:58:55 -0500
In-Reply-To: <CAEjEV8A=VNY6tSwzJPG32WqO0yNzvgcv8QsqBYEy6KiX7WVgSA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi quxuan,

Could you have a test with ext3's journal disabled?   In our
production, I encountered several cases where deleting on a deleted
entry happened in ext2, however it doesn''t bother apps, so we didn't
dig the cause.

Yongqiang.

On Wed, Dec 5, 2012 at 11:46 PM, qixuan wu <wuqixuan@gmail.com> wrote:
> Hi Tao,
>
> On Wed, Dec 5, 2012 at 9:58 PM, Tao Ma <tm@tao.ma> wrote:
>> Hi qixuan,
>> On 12/05/2012 12:16 AM, qixuan wu wrote:
>>> Hi Tao, all,
>>>
>>>     I guess it's a memory(or ext3/kenrel) issue. Beause in one
>>> machine, after report this issue, the partition is made to readonly,
>>> we use debugfs to "ls dir", and it's fine. It can list all files
>>> without error. If the disk has issue, when we using ls command, it
>>> will give error also. (The dir name is also using debugfs to get by
>>> issue inode ID.)
>> Are you sure the disk is good? I just checked the code in e2fsprogs, it
>> seems that it will not complain if rec_len = 0, and the dir iteration
>> just aborts. I guess the right way should be dd the corresponding block
>> out, decode and read it in binary format. :(
>
>     Good idea, will do it.
>
> Thanks
> wuqixuan
>
>> Thanks
>> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Best Wishes
Yongqiang Yang
