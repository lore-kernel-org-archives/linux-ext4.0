From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] e2fsprogs: remove fragment support which will never be implemented [modified format]
Date: Fri, 10 Aug 2007 03:28:29 -0600
Message-ID: <20070810092829.GN6689@schatzie.adilger.int>
References: <46BBDD5C.6020600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55935 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934080AbXHJJ21 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 05:28:27 -0400
Content-Disposition: inline
In-Reply-To: <46BBDD5C.6020600@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 10, 2007  11:37 +0800, Coly Li wrote:
> - --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -558,8 +558,8 @@ struct problem_context {
> +/* Duplicate directory entry found */
> +#define PR_2_REPORT_DUP_DIRENT	0x02000D
> 
> - -/* i_frag should be zero */
> - -#define PR_2_FRAG_ZERO		0x020010
> +/* Non-unique filename found */
> +#define PR_2_NON_UNIQUE_FILE	0x020010
> 
> - -/* i_fsize should be zero */
> - -#define PR_2_FSIZE_ZERO		0x020011
> +/* i_blocks_hi should be zero */
> +#define PR_2_BLOCKS_HI_ZERO	0x020011

Please don't do this.  This makes other patches fail to apply, and I don't
think we need to have sequential error numbers?

>  		struct {
> - -			__u8	m_i_frag;	/* Fragment number */
> - -			__u8	m_i_fsize;	/* Fragment size */
> - -			__u16	m_pad1;
> - -			__u32	m_i_reserved2[2];
> +			__u32	m_i_reserved2[3];

It is a bad idea to declare on-disk fields "reserved[{num}]", because
if some code is ever using e.g. "reserved[0]" for something and then
one of the fields is "unreserved" then the other code will silently
continue to work, but it will be using some other field on disk...

That said, while we are removing junk you could also remove the "masix"
parts of the code, because I don't think they have been used for 10 years.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
