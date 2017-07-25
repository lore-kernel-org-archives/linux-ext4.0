From: Jens Axboe <axboe@kernel.dk>
Subject: Re: bfq/ext4 disk IO hangs forever on resume
Date: Tue, 25 Jul 2017 08:47:43 -0600
Message-ID: <6c2bd97a-455e-8078-9441-cb53a7f7fa60@kernel.dk>
References: <20170625230756.68b4de21.alex_y_xu@yahoo.ca>
 <20170725085128.GA20040@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-block@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725085128.GA20040@quack2.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/25/2017 02:51 AM, Jan Kara wrote:
> Hello,
> 
> On Sun 25-06-17 23:07:56, Alex Xu wrote:
>> I get hangs when resuming when using bfq-mq with ext4 on 4.12-rc6+
>> (currently a4fd8b3accf43d407472e34403d4b0a4df5c0e71).
>>
>> Steps to reproduce:
>> 1. boot computer
>> 2. systemctl suspend
>> 3. wait few seconds
>> 4. press power button
>> 5. type "ls" into console or SSH or do anything that does disk IO
>>
>> Expected results:
>> Command is executed.
>>
>> Actual results:
>> Command hangs.
>>
>> lockdep has no comments, but sysrq-d shows that i_mutex_dir_key and
>> jbd2_handle are held by multiple processes, leading me to suspect that
>> ext4 is at least partially involved. [0]
> 
> Can you still reproduce this?

Can you try with this patch added:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-linus&id=765e40b675a9566459ddcb8358ad16f3b8344bbe

-- 
Jens Axboe
