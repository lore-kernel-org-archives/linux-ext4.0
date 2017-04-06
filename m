From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Thu, 6 Apr 2017 12:26:16 -0400
Message-ID: <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170405023526.GS22845@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
> 
> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
> after umount/mount cycle, then changed back to original result after
> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)

I haven't had time to look at this, but I'm not sure this test is a
reasonable one on the face of it.

A file system may choose to optimize a file's extent tree for whatever
reason it wants, whenever it wants, including on an unmount --- and
that would not be an invalid thing to do.  So to have an xfstests that
causes a test failure if a file system were to, say, do some cleanup
at mount or unmount time, or when the file is next opened, to merge
adjacent extents together (and hence change what is returned by
FIEMAP) might be strange, or even weird --- but is this any of user
space's business?  Or anything we want to enforce as wrong wrong wrong
by xfstests?

		       		   	   - Ted
					   
