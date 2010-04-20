From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [RFC][PATCH 0/3] ext4: inode preferred block allocation
Date: Tue, 20 Apr 2010 17:40:41 +0900
Message-ID: <4BCD6889.2010308@sx.jp.nec.com>
References: <4BC57A1D.9080105@sx.jp.nec.com> <g2q87f94c371004150922qb636f468t9cf3b6cb8cfd7b03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org, ohsm-devel@lists.sourceforge.net,
	dmonakhov@openvz.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <g2q87f94c371004150922qb636f468t9cf3b6cb8cfd7b03@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2010/04/16 1:22, Greg Freemyer wrote:
> I have a basic understanding how these could be used by e4defrag to
> organize stable data blocks / extents, but is the goal to also allow a
> working set of dynamic files which allocate new data blocks routinely?
> 
> == details / example
> 
> Assume I know that files owned by a specific user (such as the apache
> daemon) need to be collocated to reduce seek times as pages are
> displayed.
> 
> After the fact, I can see the e4defrag moving all files with UID
> apached into a subset of block groups thus increasing locality and
> decreasing seeks.
> 
> But what if those files themselves are dynamically being created /
> extended and thus allocating new data blocks/extents on the fly.   The
> need in that situation would be more along the lines of defining a
> preferred block group range for all files with the same UID.  And all
> of those files would be provided exactly the same block range.

Even if we implement preferred block group range, the problem you said will
occur. Because we don't know how much data will be increased.
If you really want the function, you will be able to materialize your idea by
creating the persistent inode preallocation in struct ext4_sb_info.

I don't have a plan to develop the function of the inode preferred range at
present. This patch has a function enough to realize new feature of e4derag.
Moreover, Andreas said we should not create a second similar mechanism.
http://marc.info/?l=linux-ext4&m=124650093015617&w=4

Best Regards,
Kazuya Mio
