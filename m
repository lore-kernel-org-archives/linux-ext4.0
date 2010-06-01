From: Christoph Hellwig <hch@lst.de>
Subject: Re: nobh mount option in ext3/4?
Date: Tue, 1 Jun 2010 11:10:41 +0200
Message-ID: <20100601091041.GA28762@lst.de>
References: <20100531124051.GA17262@lst.de> <20100531175557.GC5334@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100531175557.GC5334@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 31, 2010 at 07:55:58PM +0200, Jan Kara wrote:
>   IMHO nobh can go away from ext3/ext4.

I'll send patches.

>   I would be also in favor of
> removing all the nobh logic from VFS and ext2 but for ext2 it saves some
> low memory so some people might actually use it.

I agree that we should get rid of it entirely, but that's the next step.

