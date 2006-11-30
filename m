From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 1/3] change attribute for ext4: change attribute in the VFS
Date: Wed, 29 Nov 2006 22:32:30 -0800
Message-ID: <20061130063230.GG6429@schatzie.adilger.int>
References: <456DD754.3060803@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:4241 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1757831AbWK3Gcc
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 01:32:32 -0500
To: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
Content-Disposition: inline
In-Reply-To: <456DD754.3060803@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 29, 2006  19:54 +0100, Jean-Noel Cordenner wrote:
> This part of the patch concerns the change attribute in the VFS layer. The 
> definition of the change_attribute field in the inode and its update.
> 
> @@ -538,6 +540,7 @@
>         struct timespec         i_atime;
>         struct timespec         i_mtime;
>         struct timespec         i_ctime;
> +       unsigned long           i_change_attribute;
>         unsigned int            i_blkbits;
>         unsigned long           i_version;
>         blkcnt_t                i_blocks;

It isn't clear to me why the change attribute isn't just the same as the
i_version field?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
