From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] ubifs: Maintain a parent pointer
Date: Tue, 23 May 2017 01:37:58 -0700
Message-ID: <20170523083758.GB4107@infradead.org>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
 <1495398051-4604-5-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mtd@lists.infradead.org, david@sigma-star.at,
        dedekind1@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, akpm@linux-foundation.org,
        linux-ext4@vger.kernel.org, bfields@redhat.com,
        marcus.folkesson@gmail.com, hyc.lee@gmail.com,
        rockdotlee@gmail.com, leon.pollak@gmail.com
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495398051-4604-5-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 21, 2017 at 10:20:49PM +0200, Richard Weinberger wrote:
> The new feature UBIFS_FLG_PARENTPOINTER allows looking
> up the parent. Usually the Linux VFS walks down the filesystem
> and no parent pointers are needed. But when a filesystem
> is exportable via NFS such a lookup is needed.
> We can use a padding field in struct ubifs_ino_node to
> maintain a pointer to the parent inode.

Note that nfsd/exportfs will only do this for directories, and beacause
we hardlinks for other objects that is an important distinction.

I think the ubifs code should make sure to only maintain the parent
pointers for directories, otherwise confusion and abuses will happen.
