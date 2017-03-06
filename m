From: Avi Kivity <avi@scylladb.com>
Subject: Re: [PATCH 0/8 v2] Non-blocking AIO
Date: Mon, 6 Mar 2017 10:40:36 +0200
Message-ID: <f1df9ffe-6803-41b3-3ec0-cd96ae32b995@scylladb.com>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <347d19cb-dbb8-1d4f-dfb5-d1dd820dd65d@scylladb.com>
 <20170306082546.GA14932@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, jack@suse.com,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170306082546.GA14932@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/06/2017 10:25 AM, Jan Kara wrote:
> On Sun 05-03-17 16:56:21, Avi Kivity wrote:
>>> The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
>>> any of these conditions are met. This way userspace can push most
>>> of the write()s to the kernel to the best of its ability to complete
>>> and if it returns -EAGAIN, can defer it to another thread.
>>>
>> Is it not possible to push the iocb to a workqueue?  This will allow
>> existing userspace to work with the new functionality, unchanged. Any
>> userspace implementation would have to do the same thing, so it's not like
>> we're saving anything by pushing it there.
> That is not easy because until IO is fully submitted, you need some parts
> of the context of the process which submits the IO (e.g. memory mappings,
> but possibly also other credentials). So you would need to somehow transfer
> this information to the workqueue.
>


It's at least possible to pass the mm_struct to the workqueue, and I 
imagine other process attributes.  But I appreciate the difficulty.

It would be quite annoying to have to keep a large number of worker 
threads active, just in case aio is not working.  Modern NVMes have 
fairly deep queues, and at the worst case, you'll need one thread for 
each I/O to keep everything busy.
