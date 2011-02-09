From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] VFS: call synchronize_rcu after kill_sb.
Date: Tue, 8 Feb 2011 23:50:07 -0500
Message-ID: <20110209045007.GA29650@infradead.org>
References: <1296896481-3650-1-git-send-email-tm@tao.ma>
 <4D4FF040.9050707@panasas.com>
 <87hbceqxax.fsf@linux.vnet.ibm.com>
 <4D517C98.7060000@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	Tao Ma <tm@tao.ma>, Nick Piggin <npiggin@kernel.dk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1BIEuN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 23:50:13 -0500
Content-Disposition: inline
In-Reply-To: <4D517C98.7060000@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> +		/*
> +		 * We need to synchronize rcu here so that
> +		 * the delayed rcu inode free can be executed
> +		 * before we put_super.
> +		 * https://bugzilla.kernel.org/show_bug.cgi?id=27652
> +		 */

URLs in comments are not useful, descriptions of the issues in comments
should be complete enough to understand the issue.  I think the comment
without the url is enough, though.

