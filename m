From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] [RFC] vfs: add generic reserved space management
 interface
Date: Wed, 9 Dec 2009 12:08:36 +0100
Message-ID: <20091209110836.GE4863@quack.suse.de>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com,
	jack@suse.cz, cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 09-12-09 05:11:24, Dmitry Monakhov wrote:
> Add new field "i_rsv_blocks" to generic inode. This value is
> managed similar to i_blocks, i_bytes fileds (protected by i_lock).
> This generic interface will be used by generic quota code similar
> to i_blocks.
  I guess some people won't like bloating the VFS inode. It personally
makes my "quota" life easier but not that many filesystems need this
(currently I'm aware of only ext4) so their complaints are reasonable...
  If we would eventually decide to go this way, I'd account reserved
space in bytes - quota is really accounted in bytes (as some filesystems
need this).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
