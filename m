From: Zach Brown <zab@zabbo.net>
Subject: Re: [RFC] f_pos in readdir() (was Re: [RFC][PATCH] vfs: always
 protect diretory file->fpos with inode mutex)
Date: Mon, 25 Feb 2013 10:25:16 -0800
Message-ID: <20130225182516.GI22221@lenny.home.zabbo.net>
References: <5122D3E0.6070800@huawei.com>
 <20130223173521.GP4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizefan@huawei.com>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
	Wuqixuan <wuqixuan@huawei.com>, gregkh@linuxfoundation.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130223173521.GP4503@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> As for ->readdir(), I'd like to resurrect an old proposal to change the ABI
> of that sucker.  Quoting the thread from 4 years ago:

I'd love to see the readdir() interface cleaned up, yes please.

> Comments?

Hmm.  Do we want to think about letting callers copy the name to
userspace in fragments?

I was looking at current readdir paths and saw that btrfs has an
annoying wrinkle that its directory entries might be in large blocks
that span disjoint pages.  So it copies them to a kmalloced()ed buffer
to pass to filldir().

Maybe it wouldn't be worth having to track incomplete entries in the
core, but it'd be nice to get rid of this copy in btrfs.

(btrfs could also be more clever and only do this dance when the name
really does span pages.. it's very rare. :/).

- z
