From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 15/41] whiteout: ext2 whiteout support
Date: Mon, 30 Nov 2009 02:45:40 -0500
Message-ID: <200911300745.nAU7jecR022659@agora.fsl.cs.sunysb.edu>
References: <1256152779-10054-16-git-send-email-vaurora@redhat.com>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754063AbZK3HqO@vger.kernel.org>
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:13 PDT."
             <1256152779-10054-16-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In message <1256152779-10054-16-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> This patch adds whiteout support to EXT2. A whiteout is an empty directory
> entry (inode == 0) with the file type set to EXT2_FT_WHT. Therefore it
> allocates space in directories. Due to being implemented as a filetype it is
> necessary to have the EXT2_FEATURE_INCOMPAT_FILETYPE flag set.
> 
> XXX - Whiteouts could be implemented as special symbolic links
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> Cc: Theodore Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> ---
>  fs/ext2/dir.c           |   96 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/ext2/ext2.h          |    3 +
>  fs/ext2/inode.c         |   11 ++++-
>  fs/ext2/namei.c         |   65 ++++++++++++++++++++++++++++++-
>  fs/ext2/super.c         |    7 +++
>  include/linux/ext2_fs.h |    4 ++
>  6 files changed, 176 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index cb8ceff..d4628c0 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -219,7 +219,7 @@ static inline int ext2_match (int len, const char * const name,
>  {
>  	if (len != de->name_len)
>  		return 0;
> -	if (!de->inode)
> +	if (!de->inode && (de->file_type != EXT2_FT_WHT))

The extra parens around (de->file_type != EXT2_FT_WHT) don't hurt but are
unnecessary.  Ditto in a couple of other places in this patch.

Erez.
