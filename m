From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Wed, 14 May 2008 12:56:42 +0200
Message-ID: <200805141256.43272.agruen@suse.de>
References: <4827B878.50903@oracle.com> <20080512170254.f79fe869.akpm@linux-foundation.org> <4828FD68.40608@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
To: Tiger Yang <tiger.yang@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4828FD68.40608@oracle.com>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 13 May 2008 04:31:04 Tiger Yang wrote:
> Hi, Andrew
>
> This situation only happens we format ext3/4 with inode size more than
> 128 and we have put xattr entries both in ibody and block.
> The consequences about this bug is we will lost the xattr block which
> pointed by i_file_acl with all xattr entires in it. We will alloc a new
> xattr block and put that large value entry in it. The old xattr block
> will become orphan block.

The patch looks good, and it obviously fixes the described problem. Thanks!

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>


Could it please be added to -stable?

Andreas
