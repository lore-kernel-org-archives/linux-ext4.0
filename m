From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/10] jfs: Fix error handling in
	write_super_lockfs/unlockfs
Date: Wed, 24 Sep 2008 09:05:29 -0500
Message-ID: <1222265129.19388.12.camel@norville.austin.ibm.com>
References: <20080922195742t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080922195742t-sato@mail.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2008-09-22 at 19:57 +0900, Takashi Sato wrote:
> I've changed write_super_lockfs/unlockfs so that they always return
> 0 (success) to keep a current behavior.

Address Christoph's concerns, and you can add my ack.  The bits that
change the return code need to be a single patch.

> Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
> Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>


> -static void jfs_write_super_lockfs(struct super_block *sb)
> +static int jfs_write_super_lockfs(struct super_block *sb)
>  {
>  	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	struct jfs_log *log = sbi->log;
> @@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
>  		lmLogShutdown(log);
>  		updateSuper(sb, FM_CLEAN);
>  	}
> +	return 0;

Alright.  Nothing should fail here, and if it does, we're screwed
anyway.

> -static void jfs_unlockfs(struct super_block *sb)
> +static int jfs_unlockfs(struct super_block *sb)
>  {
>  	struct jfs_sb_info *sbi = JFS_SBI(sb);
>  	struct jfs_log *log = sbi->log;
> @@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
>  		else
>  			txResume(sb);
>  	}
> +	return 0;

jfs_unlockfs() could return non-zero in the case where lmLogInit()
fails.  I'm not sure what good that does though.  There isn't much the
caller can do when an unfreeze fails.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

