From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Regression in next with ext4 oops
Date: Wed, 05 Oct 2016 12:51:52 +0300
Message-ID: <8737kbp1hj.fsf@kamboji.qca.qualcomm.com>
References: <20161003233054.eltv3coiweht3ui4@atomide.com>
        <20161004090041.GE17515@quack2.suse.cz>
        <20161004140231.fyfrc6rs2lb6z63v@thunk.org>
        <20161004145915.GZ19539@ZenIV.linux.org.uk>
        <20161004191633.muirbg7mvb3ylhhl@atomide.com>
        <20161004192908.sl6iabbgkyyrdhes@atomide.com>
        <87fuobq4v1.fsf@kamboji.qca.qualcomm.com>
        <20161004203404.cxx767awxo7ti4v7@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161004203404.cxx767awxo7ti4v7@atomide.com> (Tony Lindgren's
        message of "Tue, 4 Oct 2016 13:34:04 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tony Lindgren <tony@atomide.com> writes:

> * Kalle Valo <kvalo@codeaurora.org> [161004 12:42]:
>> Tony Lindgren <tony@atomide.com> writes:
>> 
>> > And the patch below seems to fix the issue as the driver is now
>> > using devm_kzalloc. Will do some more testing and then will post
>> > a proper patch. The same issue might be there for SPI glue also.
>> 
>> This was already posted and you even acked it :)
>> 
>> wlcore: sdio: drop kfree for memory allocated with devm_kzalloc
>> 
>> https://patchwork.kernel.org/patch/9353985/
>
> Heh well now we know :) Can you please apply it as it fixes a memory
> corruption issue?

Yeah, I'll apply it to wireless-drivers.git soon.

> The SPI glue does not have this same issue.

Good to know, thanks for checking.

-- 
Kalle Valo
