From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
Date: Thu, 26 Aug 2010 11:53:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1008250830430.2123@be10.lrz>
References: <eVJmW-3Lf-15@gated-at.bofh.it> <eVJmW-3Lf-19@gated-at.bofh.it> <fdNs6-5F1-7@gated-at.bofh.it> <fdVfY-pv-23@gated-at.bofh.it> <fe6Ep-cD-13@gated-at.bofh.it> <fiCPo-73x-17@gated-at.bofh.it> <fiMc1-6ip-7@gated-at.bofh.it> <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
 <20100824172108.GA28718@shell>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: 7eggert@gmx.de, David Woodhouse <dwmw2@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz,
	agruen@suse.de, viro@zeniv.linux.org.uk, jblunck@suse.de,
	hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100824172108.GA28718@shell>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Aug 2010, Valerie Aurora wrote:
> On Thu, Aug 19, 2010 at 01:24:07AM +0200, Bodo Eggert wrote:
>> Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, 17 Aug 2010, Valerie Aurora wrote:

>>> get_unlinked_inode() is a great idea.  But I feel that individual
>>> inodes for each fallthrough is excessive.  It'll make the first
>>> readdir() really really expensive and wastes a lot of disk and memory
>>> for no good reason.
>>>
>>> Not sure how to fix the hard link limits problem though...
>>
>> Do a hardlink if you can create a hard link, otherwise use a fresh inode
>> and use that for the next hardlink(s).
>
> Bleah!  Then you have a code path that is only tested when you hit
> LINK_MAX.  Sounds like a recipe for bugs for me.

You'll also hit it while creating the first whiteout, maybe on creating 
the first whiteout since mounting, and on filesystems not supporting 
hardlinks (are there some that support attributes but not hardlinks?).
Maybe it will be possible to create immutable whiteout inodes, too.
