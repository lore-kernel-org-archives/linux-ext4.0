From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 14/41] whiteout: Split of ext2_append_link() from ext2_add_link()
Date: Mon, 30 Nov 2009 01:32:08 -0500
Message-ID: <200911300632.nAU6W8gd022170@agora.fsl.cs.sunysb.edu>
References: <1256152779-10054-15-git-send-email-vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Whitcroft <apw@canonical.com>,
	Scott James Remnant <scott@canonical.com>,
	Sandu Popa Marius <sandupopamarius@gmail.com>,
	Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>,
	Arnd Bergmann <arnd@arndb.de>,
	Vladimir Dronnikov <dronnikov@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:12 PDT."
             <1256152779-10054-15-git-send-email-vaurora@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In message <1256152779-10054-15-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> The ext2_append_link() is later used to find or append a directory
> entry to whiteout.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> ---
>  fs/ext2/dir.c |   70 ++++++++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 50 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 6cde970..cb8ceff 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -472,9 +472,10 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
>  }
>  
>  /*
> - *	Parent is locked.
> + * Find or append a given dentry to the parent directory
>   */
> -int ext2_add_link (struct dentry *dentry, struct inode *inode)
> +static ext2_dirent * ext2_append_entry(struct dentry * dentry,
> +				       struct page ** page)

I thought checkpatch didn't want to see spaces after a '*', so
"struct foo * ptr" should become "struct foo *ptr".

I also think that "struct page **page" should be renamed to "struct page
**ppage" or "struct page **pages", to avoid confusion with many other
functions which pass a "struct page *" pointer to a variable named "page".

Erez.
