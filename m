From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2] ext4: avoid hang when mounting non-journal
 filesystems with orphan list
Date: Thu, 27 Dec 2012 15:19:14 +0800
Message-ID: <20121227071914.GB7573@gmail.com>
References: <1356590595-23144-1-git-send-email-tytso@mit.edu>
 <1356590595-23144-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1356590595-23144-2-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 27, 2012 at 01:43:15AM -0500, Theodore Ts'o wrote:
> When trying to mount a file system which does not contain a journal,
> but which does have a orphan list with an inode which needs to be
> truncated, the mount call with hang forever in ext4_orphan_cleanup()
> because ext4_orphan_del() will return immediately if no journal is
> present.
> 
> This can be trivially reproduced by trying to mount the file system
> found in tests/f_orphan_extents_inode/image.gz in the e2fsprogs
> sources.  If a malicious user were to put this on a USB stick, and
> mount it on a Linux desktop which automatically mounts newly inserted
> USB sticks, this could be considered a potential denial of service
> attack.  (Not a big deal in practice, but professional paranoids worry
> about such things, and have even been known to allocate CVE numbers
> on occasion.)
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                        - Zheng
