From: Theodore Tso <tytso@mit.edu>
Subject: Re: next-20090310: ext4 hangs
Date: Tue, 10 Mar 2009 08:46:58 -0400
Message-ID: <20090310124658.GE8840@mit.edu>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754558AbZCJMrV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 10, 2009 at 03:17:51PM +0300, Alexander Beregalov wrote:
> Hi
> 
> It is similar to http://lkml.org/lkml/2009/2/6/304,
> http://bugzilla.kernel.org/show_bug.cgi?id=12579
> 
> I run dbench on ext4 on loop on ext3 on sparc.
> The kernel is 2.6.29-rc7-next-20090310
> e2fsprogs -1.41.4

Thanks for reporting this; does it show up on stock 2.6.29-rc7?  And
any chance you can enable LOCKDEP?  Finally, how many CPU's do you
have on your machine?

Thanks again,

						- Ted
