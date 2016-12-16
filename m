From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: Big I/O requests are split into small ones due to unaligned ext4
 partition boundary?
Date: Fri, 16 Dec 2016 13:42:15 +0800
Message-ID: <CACVXFVOHMq6EOQV_tKAObiJZ+948vwZor5G6W8-TNE5EfZM7Yw@mail.gmail.com>
References: <MWHPR03MB26692343C35CE591E277A816BF9D0@MWHPR03MB2669.namprd03.prod.outlook.com>
 <CACVXFVMfuqT6ZoCECaCyhiM1hosZzAjpgv1kibbpqizxKT2f3w@mail.gmail.com> <MWHPR03MB2669356D00948A188BB50BCEBF9D0@MWHPR03MB2669.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Hu <Chou.Hu@microsoft.com>,
        Thomas Shao <huishao@microsoft.com>,
        Matthew Wilcox <matthew@wil.cx>,
        Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <MWHPR03MB2669356D00948A188BB50BCEBF9D0@MWHPR03MB2669.namprd03.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 15, 2016 at 9:53 PM, Dexuan Cui <decui@microsoft.com> wrote:
>> From: Ming Lei [mailto:tom.leiming@gmail.com]
>> Sent: Thursday, December 15, 2016 20:43
>>
>> On Thu, Dec 15, 2016 at 7:47 PM, Dexuan Cui <decui@microsoft.com> wrote:
>> > Hi, when I run "mkfs.ext4 /dev/sdc2" in a Linux virtual machine on Hyper-V,
>> > where a disk IOPS=500 limit is applied by me [0],  the command takes much
>> > more time, if the ext4 partition boundary is not properly aligned:
>> >
>> > Example 1 [1]: it takes ~7 minutes with average wMB/s = 0.3   (slow)
>> > Example 2 [2]: it takes ~3.5 minutes with average wMB/s = 0.6 (slow)
>> > Example 3 [3]: it takes ~0.5 minute with average wMB/s = 4 (expected)
>> >
>> > strace shows the mkfs.ext3 program calls seek()/write() a lot and most of
>> > the writes use 32KB buffers (this should be big enough), and the program
>> > only invokes fsync() once, after it issues all the writes -- the fsync() takes
>> >>99% of the time.
>> >
>> > By logging SCSI commands, the SCSI Write(10) command is used here for the
>> > userspace 32KB write:
>> > in example 1, *each* command writes 1 or 2 sectors only (1 sector = 512
>> bytes);
>> > in example 2, *each* command writes 2 or 4 sectors only;
>> > in example 3, each command writes 1024 sectors.
>> >
>> > It looks the kernel block I/O layer can somehow split big user-space buffers
>> > into really small write requests (1, 2, and 4 sectors)?
>> > This looks really strange to me.
>> >
>> > Note: in my test, this strange issue happens to 4.4 and the mainline 4.9 kernels,
>> > but the stable 3.18.45 kernel doesn't have the issue, i.e. all the 3 above test
>> > examples can finish in ~0.5 minute.
>> >
>> > Any comment?
>>
>> I remember that we discussed this kind of issue, please see the discussion[1]
>> and check if the patch[2] can fix your issue.
>>
>> [1] http://marc.info/?t=145805525500002&r=1&w=2
>> [2] http://marc.info/?l=linux-kernel&m=145934325429152&w=2
>>
>> Ming
>
> Thank you very much, Ming! The patch can fix my issue!
> It looks your patch was not merged into the upstream somehow.
> Would you please submit the patch again?

Yeah, will do, and thanks for your test!



Thanks,
Ming Lei
