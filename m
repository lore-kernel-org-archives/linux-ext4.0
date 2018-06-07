From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Thu, 7 Jun 2018 22:19:06 +0900
Message-ID: <927ef9f9-4f4d-185e-b86f-10bd18fa92d4@i-love.sakura.ne.jp>
References: <25708e84-6f35-04c3-a2e4-6854f0ed9e78@I-love.SAKURA.ne.jp>
 <dc9862c7-ec16-8b11-04e4-422b435d41ef@kernel.dk>
 <201806050027.w550RfJl010157@www262.sakura.ne.jp>
 <20180605004128.GA28826@ming.t460p>
 <CACVXFVNcJ+tC6RUT+JUA3iw+STB+q4P_u+AvoOSrt04zEw8TZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <Bart.VanAssche@wdc.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        alan.christopher.jenkins@gmail.com,
        syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        martin@lichtvoll.de, Hannes Reinecke <hare@suse.com>,
        syzkaller-bugs@googlegroups.com,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVNcJ+tC6RUT+JUA3iw+STB+q4P_u+AvoOSrt04zEw8TZA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018/06/07 12:29, Ming Lei wrote:
>> The vfs_fsync() isn't necessary in loop_update_dio() since both
>> generic_file_write_iter() and generic_file_read_iter() can handle
>> buffered io vs dio well.
>>
>> I will send one patch to remove the vfs_sync() later.
> 
> Hi Tetsuo,
> 
> The issue might be fixed by removing this vfs_sync(), but I'd like to
> understand the idea behind since vfs_sync() shouldn't have caused
> any IO to this loop queue.
> 
> I also tried to do the test via the following c syzbot, but can't reproduce
> it yet after running it for several hours.
> 
> https://syzkaller.appspot.com/x/repro.c?id=4727023951937536
> 
> Could you share us how you reproduce it?

I just reported that syzbot started hitting vfs_sync() case.
I haven't succeeded reproducing vfs_sync() case in my environment.

But in general, I modify "any reproducer provided by syzbot that loops
forever" to call exit() if open() etc. failed, for continuing the loop
unlikely helps after hitting "Too many open files" error.

   res = syscall(__NR_memfd_create, 0x200002c0, 0);
   if (res != -1)
     r[1] = res;
+  else
+    exit(1);

Thus, I restart the reproducer in a loop from shell
rather than keep running for hours.

   while :; do echo -n .; ./a.out; done
