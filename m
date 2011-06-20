From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] fs: kill i_alloc_sem
Date: Mon, 20 Jun 2011 18:18:57 -0400
Message-ID: <20110620221857.GA3473@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.175620498@bombadil.infradead.org>
 <20110620213203.GB26204@noexit.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hirofumi@ma
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110620213203.GB26204@noexit.corp.google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 20, 2011 at 02:32:03PM -0700, Joel Becker wrote:
> 	Are we guaranteed that all allocation changes are locked out by
> i_dio_count>0?  I don't think we are.  The ocfs2 code very strongly
> assumes the state of a file's allocation when it holds i_alloc_sem.  I
> feel like we lose that here. 

You aren't, neither with the old i_alloc_sem code, nor with the 1:1
replacement using i_dio_count.

Do a quick grep who gets i_alloc_sem exclusively (down_write): it's
really just the truncate code, and it's cut & paste duplicates in ntfs
and reiserfs.

