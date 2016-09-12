From: norton <norton.zhu@huawei.com>
Subject: Re: [PATCH]:ext4 these lines are too long while reading
Date: Mon, 12 Sep 2016 09:35:44 +0800
Message-ID: <57D60670.9060306@huawei.com>
References: <57D281D1.6020208@huawei.com>
 <20160909134731.qw3pmidbprxjrtpg@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160909134731.qw3pmidbprxjrtpg@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, Theodore
Thanks for your suggest, I looks better now.:)

On 2016/9/9 21:47, Theodore Ts'o wrote:
> On Fri, Sep 09, 2016 at 05:33:05PM +0800, norton wrote:
>> Hi, all
>>
>> I'm a freshman in ext4 file system and I'm reading its source code now.
>> This patch did nothing but make it looks better.(
>> some lines are too long in vim :( ).
> 
> We don't take line-remapping patches.  It used to be the case that
> checkpatch would complain if lines were too long, and then it started
> complaining if the lines were wrapped.  I don't like checkpatch,
> because it causes unnecessary patch churn.  :-(
> 
> May I suggest instead that you take a look at reconfiguring vim?
> 
> http://stackoverflow.com/questions/467739/how-do-you-get-vim-to-display-wrapped-lines-without-inserting-newlines
> 
> 					- Ted
> 
> .
> 

