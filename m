From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Subject: Re: ext4 ignoring rootfs default mount options
Date: Thu, 15 Mar 2018 14:35:27 -0400
Message-ID: <20180315183527.sruft4472fwwu6qk@csclub.uwaterloo.ca>
References: <20180306190315.puocf5bu3bfz6yct@csclub.uwaterloo.ca>
 <20180307040608.GA2462@thunk.org>
 <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
 <20180307160856.GD7507@thunk.org>
 <20180307191324.qtloesy4zdlkfnwv@csclub.uwaterloo.ca>
 <20180307225043.GA15217@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307225043.GA15217@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 05:50:43PM -0500, Theodore Y. Ts'o wrote:
> Yes, this is a shortcoming in tune2fs.  You can set extended mount
> options using debugfs:
> 
>     debugfs -w -R "set_super_value mount_opts foo,bar" /dev/sda1
> 
> ... but there ought to be some way to support some kind of quoting
> mechanism so that tune2fs can understand when a comma is part of an
> extended option value, as opposed to separating extended options.
> 
> Extended options haven't been used much, so it's not been something
> that has gotten a lot of polish.  Backing up for a bit, is there a
> reason why you need so many mount options when mounting the root file
> sytsem?  Specifically, why do you want to turn off dellayed allocation?

Completely don't trust it.  Also don't do much writing so no real benefit.
Having seen machines get killed by the watchdog come back with blank
chunks in log files is not acceptable.  Getting all user space software
fixed to actually sync properly in all the right places takes forever.

Now for my home machine (especially my mythtv box) it is absoletely on
and a great thing to have.

-- 
Len Sorensen
