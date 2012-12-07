From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: help about ext3 read-only issue on ext3(2.6.16.30)
Date: Fri, 7 Dec 2012 09:49:43 +0800
Message-ID: <CAGBYx2YozGWGmd+ysF_hThcVOxdXR3AN2tJJuukMmda3zqG1Uw@mail.gmail.com>
References: <CALOAHbDC8jguV7GeSuN01UWBk+74wVHho8Fe9HLan06FZSpw0g@mail.gmail.com>
 <50BCE885.8010609@redhat.com> <50BE007D.5080504@huawei.com>
 <50BE16EC.6060501@tao.ma> <CAEjEV8D7G3xaT_Y4KdH7eVA-bdexjEE5iKPFRQ=Psgfmmoe-+g@mail.gmail.com>
 <50BF52F9.5080707@tao.ma> <CAEjEV8A=VNY6tSwzJPG32WqO0yNzvgcv8QsqBYEy6KiX7WVgSA@mail.gmail.com>
 <CAGBYx2bw4D_MDzNGS-QO92tuJvTN2=j6f1u0Y3ReBM-mj33EOA@mail.gmail.com> <CAEjEV8A52CHDC9FD9SV+FuuScGe0mJAk69z8o6OHE8kF0bdz_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tao Ma <tm@tao.ma>, Li Zefan <lizefan@huawei.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	wuqixuan@huawei.com
To: qixuan wu <wuqixuan@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAEjEV8A52CHDC9FD9SV+FuuScGe0mJAk69z8o6OHE8kF0bdz_Q@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 7, 2012 at 12:26 AM, qixuan wu <wuqixuan@gmail.com> wrote:
> Our customer is usring default
> journal mode. Because journal is concern only if the system power off.
> If system is continously running and give readonly error, we thought
> it's nothing about journal.
nope.  changes on directory are journaled, I am not sure if journal
would corrupt the data in memory, if we test the journal and without
journal we can be sure if it has something to do with  journal.

'deleting on deleted entry ' means a file had been deleted, however it
is deleted again. That says a directory was corrupted or a disk error
happened.  The situation happened several times.

Yongqiang Yang.



--
Best Wishes
Yongqiang Yang
