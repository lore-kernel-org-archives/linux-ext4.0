From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC/PATCH 0/3] Implement XFS's GOINGDOWN ioctl for ext4
Date: Fri, 3 Feb 2017 10:09:14 -0500
Message-ID: <20170203150914.vkahg2lyfi2ryk26@thunk.org>
References: <20170202225924.19301-1-tytso@mit.edu>
 <CAOQ4uxhQubTwdOtmXXsaW4hVjKt2yBhSFG92ie0QcO+HGD9ioQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhQubTwdOtmXXsaW4hVjKt2yBhSFG92ie0QcO+HGD9ioQ@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 03, 2017 at 09:05:01AM +0200, Amir Goldstein wrote:
> 
> I have a naive question about generic implementation:
> We already have mnt_want_write() hooks in generic vfs code,
> so it should be easy enough to set the shutdown bit on sb and return -EIO there.
> Wouldn't it be better to add mnt_want_read() hooks in vfs helpers
> instead of duplicating
> the fs specific hooks? I hear f2fs is yet another potential customer??

There are *portions* of shutdown functionality which could be done in
the generic VFS code.  The checks to have various system calls return
early, and to have writeback skipped for inodes belonging to that file
system, could be done in the generic code, sure.  But the code to
shutdown or abort the journal would always have to be fs specific, for
example.

						- Ted
