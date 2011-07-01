From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 4/8] fs: kill i_alloc_sem
Date: Thu, 30 Jun 2011 19:58:53 -0700
Message-ID: <20110701025853.GB24254@noexit.corp.google.com>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202031.175620498@bombadil.infradead.org>
 <20110620213203.GB26204@noexit.corp.google.com>
 <20110620221857.GA3473@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110620221857.GA3473@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 20, 2011 at 06:18:57PM -0400, Christoph Hellwig wrote:
> On Mon, Jun 20, 2011 at 02:32:03PM -0700, Joel Becker wrote:
> > 	Are we guaranteed that all allocation changes are locked out by
> > i_dio_count>0?  I don't think we are.  The ocfs2 code very strongly
> > assumes the state of a file's allocation when it holds i_alloc_sem.  I
> > feel like we lose that here. 
> 
> You aren't, neither with the old i_alloc_sem code, nor with the 1:1
> replacement using i_dio_count.
> 
> Do a quick grep who gets i_alloc_sem exclusively (down_write): it's
> really just the truncate code, and it's cut & paste duplicates in ntfs
> and reiserfs.

	Sorry, I confused this with our ip_alloc_sem.  I was tired.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

			http://www.jlbec.org/
			jlbec@evilplan.org
