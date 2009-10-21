From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 15/41] whiteout: ext2 whiteout support
Date: Wed, 21 Oct 2009 15:17:38 -0600
Message-ID: <1983FB3A-C88F-4EF4-A2E1-8B18DF97F0AB@sun.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:44367 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbZJUVSN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Oct 2009 17:18:13 -0400
In-reply-to: <1256152779-10054-16-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-10-21, at 13:19, Valerie Aurora wrote:
> This patch adds whiteout support to EXT2. A whiteout is an empty  
> directory
> entry (inode == 0) with the file type set to EXT2_FT_WHT. Therefore it
> allocates space in directories. Due to being implemented as a  
> filetype it is
> necessary to have the EXT2_FEATURE_INCOMPAT_FILETYPE flag set.
>
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index 121720d..bd10826 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -189,6 +189,7 @@ struct ext2_group_desc
> +#define EXT2_OPAQUE_FL			0x00040000

Please check in the upstream e2fsprogs ext2_fs.h before defining new  
flag
values for ext2/3/4.  In this case, 0x40000 conflicts with  
EXT4_HUGE_FILE_FL,
which is of course bad.


> @@ -503,10 +504,12 @@ struct ext2_super_block {
> #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
> +#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020

This one doesn't conflict, probably due to luck, because 0x0040-0x0200  
are
already in use for other features.  I'm not sure if 0x0020 was  
reserved for
some other use, or just skipped to avoid potential conflicts.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

