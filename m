From: Michael Halcrow <mhalcrow@google.com>
Subject: Re: [PATCH] ext4: reserve codepoints used by the ext4 encryption
 feature
Date: Mon, 26 Jan 2015 09:01:18 -0800
Message-ID: <20150126170118.GA5504@google.com>
References: <1422041781-14062-1-git-send-email-tytso@mit.edu>
 <20150123194125.GC9976@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	savagaon@google.com, muslukhovi@gmail.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:41945 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbbAZRBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jan 2015 12:01:20 -0500
Received: by mail-pa0-f74.google.com with SMTP id kx10so1626295pab.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jan 2015 09:01:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20150123194125.GC9976@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 23, 2015 at 11:41:25AM -0800, Darrick J. Wong wrote:
> On Fri, Jan 23, 2015 at 02:36:21PM -0500, Theodore Ts'o wrote:
> > +/* Encryption algorithms */
> > +#define EXT4_ENCRYPTION_MODE_INVALID		0
> > +#define EXT4_ENCRYPTION_MODE_AES_256_XTS	1
> > +#define EXT4_ENCRYPTION_MODE_AES_256_GCM	2
> > +#define EXT4_ENCRYPTION_MODE_AES_256_CBC	3
> > +
> >  /*
> >   * Structure of the super block
> >   */
> > @@ -1156,7 +1163,8 @@ struct ext4_super_block {
> >  	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
> >  	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
> >  	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
> > -	__le32	s_reserved[106];	/* Padding to the end of the block */
> > +	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
> 
> Does this imply that one can have up to 4 algorithms in use at once?

For now. But that may be more in the future. According to what's
in-plan, the data contents may be protected with XTS or
GCM. Encryption happens on a per-file basis, so several different
files may be encrypted with several different modes in the same
volume. The file names are protected with CBC.

It's possible that we may want to add an integrity-only mode down the
road, such as HMAC-SHA1. Or when the CAESAR competition yields some
promising modes, we may want to use one of them.
