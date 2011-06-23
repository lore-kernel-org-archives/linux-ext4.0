From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Thu, 23 Jun 2011 06:36:54 -0400
Message-ID: <20110623103654.GA5171@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110621235425.GA24067@quack.suse.cz>
 <20110622142235.GN32133@thunk.org>
 <20110622181342.GC26160@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110622181342.GC26160@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 22, 2011 at 08:13:42PM +0200, Jan Kara wrote:
>   No problem. Just we have to somehow coordinate with Christoph... Either
> he can avoid touching ext4 and merge his patch set after you merge my patch
> or he can take my patch instead of his ext4 change. Since my patch touches
> only ext4_page_mkwrite() there's not a high risk of collision. The latter
> would seem easier for both of you to me but I don't really care.

For now I'll just take your repost into the next version of my series.
If you guys have any better idea for sorting out the merge issues I'm
happy to reshuffle it again.

