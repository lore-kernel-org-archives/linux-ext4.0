From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Journal Checksum - rebased to 2.6.22-rc5
Date: Fri, 22 Jun 2007 11:05:06 -0500
Message-ID: <1182528306.10740.7.camel@kleikamp.austin.ibm.com>
References: <1182504986.3788.18.camel@dhcp7.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33544 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbXFVQHx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 12:07:53 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5MG6Ho7025838
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:06:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5MG59VP529402
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:05:09 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5MG58wW022385
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:05:08 -0400
In-Reply-To: <1182504986.3788.18.camel@dhcp7.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-22 at 15:06 +0530, Girish Shilamkar wrote:
> --- linux-2.6.22-rc5.orig/fs/jbd2/journal.c
> +++ linux-2.6.22-rc5/fs/jbd2/journal.c
> @@ -1272,6 +1272,33 @@ int jbd2_journal_set_features (journal_t
>         return 1;
>  }
> 
> +/**
> + * int jbd2_journal_clear_features () - Clear a given journal feature
> in the superblock
> + * @journal: Journal to act on.
> + * @compat: bitmask of compatible features
> + * @ro: bitmask of features that force read-only mount
> + * @incompat: bitmask of incompatible features
> + *
> + * Clear a given journal feature as present on the
> + * superblock.  Returns true if the requested features could be
> reset.
> + *
> + */
> +int jbd2_journal_clear_features (journal_t *journal, unsigned long
> compat,
> +                         unsigned long ro, unsigned long incompat)
> +{
> +       journal_superblock_t *sb;
> +
> +       jbd_debug(1, "Clear features 0x%lx/0x%lx/0x%lx\n",
> +                 compat, ro, incompat);
> +
> +       sb = journal->j_superblock;
> +
> +       sb->s_feature_compat    &= ~cpu_to_be32(compat);
> +       sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
> +       sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
> +
> +       return 1;
> +} 

This needs an EXPORT_SYMBOL(jbd2_journal_clear_features).  Otherwise,
ext4 can't be built as a module.
-- 
David Kleikamp
IBM Linux Technology Center
