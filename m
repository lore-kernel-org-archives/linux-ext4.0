From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 3/5 resend] VFS: Fix s_umount thaw/write deadlock
Date: Wed, 7 Dec 2011 16:49:20 -0700
Message-ID: <20111207234919.GW4387@parisc-linux.org>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com> <1323118489-16326-4-git-send-email-kamal@canonical.com> <20111206113544.GA21589@infradead.org> <20111207231658.GQ4622@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111207231658.GQ4622@quack.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 08, 2011 at 12:16:58AM +0100, Jan Kara wrote:
> On Tue 06-12-11 06:35:44, Christoph Hellwig wrote:
> > We make sure to not dirty any new inodes after the first phase of the
> > freeze, so this should be a BUG_ON/WARN_ON.
>   This is not really true in presence of mmaped writes. To block mmaped
> writes on a frozen filesystem, we need some synchronization between
> page_mkwrite() and freezing code. Currently, to avoid any additional
> locking overhead, we set page dirty and *then* check for filesystem being
> frozen. Only this order can make sure either the page is written (and
> write-protected) or the frozen check triggers and we wait... (see the
> comment in block_page_mkwrite()). The nasty sideeffect of this is that
> there can be dirty pages & inodes on a frozen filesystem. We are blocked in
> the page fault of these pages so user cannot write any data to these pages
> but still they are marked dirty.

Can't we make the mmaps read-only during the freezing process?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
