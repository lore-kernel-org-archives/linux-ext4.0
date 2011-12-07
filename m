From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5 resend] VFS: Rename vfs_check_frozen() to
 vfs_block_until_thawed()
Date: Wed, 7 Dec 2011 23:46:12 +0100
Message-ID: <20111207224612.GP4622@quack.suse.cz>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
 <1323118489-16326-5-git-send-email-kamal@canonical.com>
 <20111206114025.GA4439@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kamal Mostafa <kamal@canonical.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111206114025.GA4439@infradead.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 06-12-11 06:40:25, Christoph Hellwig wrote:
> On Mon, Dec 05, 2011 at 12:54:48PM -0800, Kamal Mostafa wrote:
> > From: Valerie Aurora <val@vaaconsulting.com>
> > 
> > The name of vfs_check_frozen() tends to de-emphasize an important
> > fact: that it will block until the file system thaws to the specified
> > level.  Make bugs slightly less likely by renaming to
> > vfs_block_until_thawed().
> 
> I really hate that name.  The old one wasn't perfect either, but unless
> you have a really good new one I'm strongly in favour of not repainting
> the bikeshed.
  Maybe vfs_wait_frozen()?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
