From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: CRASH : RCU detected stall
Date: Tue, 13 Jun 2017 13:30:44 -0400
Message-ID: <20170613173044.sdibg23cfvpwwxud@thunk.org>
References: <CAKEzZ8wRAFxXOcgxzu2KkntvNz8QvGocWpH_xDbRxRg=7LgbPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
To: Ramin Farajpour Cami <ramin.blackhat@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKEzZ8wRAFxXOcgxzu2KkntvNz8QvGocWpH_xDbRxRg=7LgbPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 13, 2017 at 07:35:37PM +0430, Ramin Farajpour Cami wrote:
> Hi,
> 
> I've got the following error report while fuzzing the kernel with syzkaller
> version (4.12-rc5)
> 
> https://groups.google.com/forum/#!topic/syzkaller/4e8MkNnRFRQ

Can you reliably reproduce this failure?  If so, please give details.
Unfortunately this sort of RCU self-stall can be caused by any number
of things.

				- Ted
