From: Johann Lombardi <johann.lombardi@bull.net>
Subject: Re: [RFC] [PATCH 1/1] Nanosecond timestamps
Date: Wed, 7 Feb 2007 21:50:28 +0100
Message-ID: <20070207205028.GA13836@lombardij>
References: <1170427790.6464.6.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60616 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422730AbXBGUtx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Feb 2007 15:49:53 -0500
In-Reply-To: <1170427790.6464.6.camel@garfield>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 02, 2007 at 08:19:50PM +0530, Kalpak Shah wrote:
> +#define EXT3_INODE_SET_XTIME(xtime, extra_xtime, inode, raw_inode) \
> +do { \
> +       (raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec); \
> + \
> +       if (offsetof(typeof(*raw_inode), extra_xtime) - \
> +           offsetof(typeof(*raw_inode), i_extra_isize) + \
> +           sizeof((raw_inode)->extra_xtime) <= \
> +               le16_to_cpu((raw_inode)->i_extra_isize)) \
                               ^^^^^^^^^^^^^^^^^^^^^^^^^
> +               (raw_inode)->extra_xtime = \

With 128-byte inodes, raw_inode->i_extra_isize is beyond the inode limit
and the above will corrupt the filesystem.
IMO, i_extra_isize from ext3_inode_info should be used instead of
raw_inode->i_extra_isize.

> +#define EXT3_INODE_GET_XTIME(xtime, extra_xtime, inode, raw_inode) \
> +do { \
> +       (inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime); \
> + \
> +       if (offsetof(typeof(*raw_inode), extra_xtime) - \
> +           offsetof(typeof(*raw_inode), i_extra_isize) + \
> +           sizeof((raw_inode)->extra_xtime) <= \
> +           le16_to_cpu((raw_inode)->i_extra_isize)) { \
                           ^^^^^^^^^^^^^^^^^^^^^^^^^
ditto

Cheers,
Johann
