From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 2/3] i_version update for ext4: ext4 specific code
Date: Tue, 23 Jan 2007 11:48:14 -0700
Message-ID: <20070123184814.GG5236@schatzie.adilger.int>
References: <45B644C0.50503@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54780 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXAWSsQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2007 13:48:16 -0500
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Content-Disposition: inline
In-Reply-To: <45B644C0.50503@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jan 23, 2007  18:24 +0100, Cordenner jean noel wrote:
> @@ -336,7 +336,7 @@
>  #define i_size_high    i_dir_acl
> 
>  #if defined(__KERNEL__) || defined(__linux__)
> -#define i_reserved1    osd1.linux1.l_i_reserved1
> +#define ext4_i_version  osd1.linux1.l_i_version

This naming is inconsistent with other inode fields, what about
i_disk_version, like i_disk_size also used in the code?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
