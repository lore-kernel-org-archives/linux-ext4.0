Return-Path: <SRS0=wlmB=SF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEEAC4360F
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 20:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BF7D214AF
	for <linux-ext4@archiver.kernel.org>; Wed,  3 Apr 2019 20:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554323815;
	bh=Iljr8qYLbE/Z4wI3N8qP1R/1VTfPA2d67crL/gJcouc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vnVYqHzJYMws0mOmyQniR9bbb5O4CnIs+pAtg+eKCG99GcuKuHukelN6WfJ6p75HU
	 4uuNydVYx3XJJAsu9Orz8v0UsZoMk/yRUPp2fbvDTyVVWsBCbpQIXBoRm+f1IEbYFC
	 sr699txn6q7qNX553Tc5zF3amqvpByIThd2QsDfw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfDCUgy (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 3 Apr 2019 16:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbfDCUgy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Apr 2019 16:36:54 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38C5F2082C;
        Wed,  3 Apr 2019 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554323813;
        bh=Iljr8qYLbE/Z4wI3N8qP1R/1VTfPA2d67crL/gJcouc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HEgTqnOgpxH+fIuff7IzRnDTwxrf4M1Pm8bDgCAgCPNM+qRy5MZyT+UD9ZpnLpU7X
         akevXAs6fD/uzgg6CFNIOOWAZMwtNegcllUWAgngFqKMTJkrGhaLZ++ldDrtAPE3bF
         I4uj+UwZi9tpQotr0vITgsJmcwbRcq4EBrFFDp9A=
Date:   Wed, 3 Apr 2019 13:36:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v4 07/17] fs/dcache.c: add shrink_dcache_inode()
Message-ID: <20190403203650.GA216239@gmail.com>
References: <20190402154600.32432-1-ebiggers@kernel.org>
 <20190402154600.32432-8-ebiggers@kernel.org>
 <20190403183411.GV2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403183411.GV2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 03, 2019 at 07:34:12PM +0100, Al Viro wrote:
> On Tue, Apr 02, 2019 at 08:45:50AM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > When a filesystem encryption key is removed, we need all files which had
> > been "unlocked" (had ->i_crypt_info set up) with it to appear "locked"
> > again.  This is most easily done by evicting the inodes.  This can
> > currently be done using 'echo 2 > /proc/sys/vm/drop_caches'; however,
> > that is overkill and not usable by non-root users.
> > 
> > To evict just the needed inodes we also need the ability to evict those
> > inodes' dentries, since an inode is pinned by its dentries.  Therefore,
> > add a function shrink_dcache_inode() which iterates through an inode's
> > dentries and evicts any unused ones as well as any unused descendants
> > (since there may be negative dentries pinning the inode's dentries).
> 
> Huh?
> 
> > + * Evict all unused aliases of the specified inode from the dcache.  This is
> > + * intended to be used when trying to evict a specific inode, since inodes are
> > + * pinned by their dentries.  We also have to descend to ->d_subdirs for each
> > + * alias, since aliases may be pinned by negative child dentries.
> > + */
> > +void shrink_dcache_inode(struct inode *inode)
> > +{
> > +	for (;;) {
> > +		struct select_data data;
> > +		struct dentry *dentry;
> > +
> > +		INIT_LIST_HEAD(&data.dispose);
> > +		data.start = NULL;
> > +		data.found = 0;
> > +
> > +		spin_lock(&inode->i_lock);
> > +		hlist_for_each_entry(dentry, &inode->i_dentry, d_u.d_alias)
> > +			d_walk(dentry, &data, select_collect);
> > +		spin_unlock(&inode->i_lock);
> > +
> > +		if (!data.found)
> > +			break;
> > +
> > +		shrink_dentry_list(&data.dispose);
> > +		cond_resched();
> 
> This is... odd.  What's wrong with
> 	if (S_ISDIR(inode->i_mode)) {
> 		dentry = d_find_any_alias(inode);
> 		if (dentry) {
> 			shrink_dcache_parent(dentry);
> 			dput(dentry);
> 		}
> 	}
> 	d_prune_aliases(inode);
> instead of that thing?

That works, as far as I can tell, so I'll do that instead.

I don't think I noticed that d_prune_aliases() existed when I wrote this.

Thanks for the suggestion!

- Eric
