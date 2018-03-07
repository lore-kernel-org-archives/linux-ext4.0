From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: Re: ext4 ignoring rootfs default mount options
Date: Wed, 7 Mar 2018 14:23:43 -0800
Message-ID: <20180307222343.GA4353@L-66Y>
References: <20180306190315.puocf5bu3bfz6yct@csclub.uwaterloo.ca>
 <20180307040608.GA2462@thunk.org>
 <20180307151427.i6vbeq6kqo55cdgs@csclub.uwaterloo.ca>
 <20180307160856.GD7507@thunk.org>
 <20180307191324.qtloesy4zdlkfnwv@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180307191324.qtloesy4zdlkfnwv@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2018 at 02:13:24PM -0500, Lennart Sorensen wrote:

> Trying to use tune2fs -E mount_opts to set some default options, and
> can't figure out how to enter two options at once.

Lennart,

I noticed this a while back, too. I don't believe you can currently. As a
workaround, you can use debugfs:

    debugfs -w -R 'set_super_value mount_opts opt1,opt2,opt3' <dev>

Note that when printing superblock info, the e2fsprogs tools call the bit-based
default mount options "Default mount options" and the string-based default mount
options "Mount options".

Tyson
