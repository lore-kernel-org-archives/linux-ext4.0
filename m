From: Quentin Godfroy <godfroy@clipper.ens.fr>
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Date: Wed, 8 Oct 2008 02:02:27 +0200
Message-ID: <20081008000227.GA32052@goelette.ens.fr>
References: <20080930211854.GZ10831@mit.edu> <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu> <20081007221256.GF15929@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758728AbYJHAD0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081007221256.GF15929@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 07, 2008 at 06:12:56PM -0400, Theodore Tso wrote:
> On Mon, Oct 06, 2008 at 01:55:02PM -0400, Theodore Tso wrote:
> > Here are updates to the two patches I sent you.  The first fixes some
> > printk labels and requires that the debugging dump ioctl be triggered
> > by root; the second fixes the think-o that Eric pointed out earlier
> > this morning.
> 
> Hey Quentin, just wanted to check in and find out if the patches seem
> to be working for you.  They seem to solve the problem on my side; I
> can no longer reproduce the problem.  Is it working for you?

I rebooted, but as I didn't know exactly how to trigger the bug except than
by waiting a few days I was waiting to see.

Do you have an idea about how to trigger the bug?

Regards,
Quentin Godfroy
