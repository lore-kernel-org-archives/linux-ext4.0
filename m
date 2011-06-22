From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Wed, 22 Jun 2011 05:39:31 -0400
Message-ID: <20110622093930.GA21269@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110621235425.GA24067@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hirofumi@mail.parknet.co.jp, mfasheh@suse.com, jlbec@evilplan.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110621235425.GA24067@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 22, 2011 at 01:54:25AM +0200, Jan Kara wrote:
>   ext4 abuse should be gone when Ted merges my rewrite of
> ext4_page_mkwrite()... Ted, what happened to that patch. Should I resend
> it?

So how should we coordinate merging the two? 

