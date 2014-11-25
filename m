From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Tue, 25 Nov 2014 16:14:33 -0500
Message-ID: <20141125211433.GB28449@thunk.org>
References: <87egu7k6ym.fsf@openvz.org>
 <1413552334-32240-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413552334-32240-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 17, 2014 at 05:25:34PM +0400, Dmitry Monakhov wrote:
> It is rediculus practice to scan inode block by block, this technique
> applicable only for old indirect files. This takes signifficant amount
> of time for really large files. Let's reuse ext4_fiemap which already
> traverse inode-tree in most optimal meaner.
> 
> TESTCASE:
> ftruncate64(fd, 0);
> ftruncate64(fd, 1ULL << 40);
> /* lseek will spin very long time */
> lseek64(fd, 0, SEEK_DATA);
> lseek64(fd, 0, SEEK_HOLE);
> 
> 
> Original report: https://lkml.org/lkml/2014/10/16/620
> 
> ##################################
> BTW: Why do we need i_mutex here?
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Note: this patch causes generic/285 to loop forever in inline-data
mode.  My guess is in the special case handling of inline data in
ext4_fiemap not playing well with this change, but I haven't had a
chance to look deeply into this yet.

					- Ted
