Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10897C10F0E
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:11:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5EBC21479
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 16:11:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ELfYDLCE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389618AbfDRQLr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 12:11:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57906 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388775AbfDRQLq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 12:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oS7KgJXOC9kOF+iDz/8huWGUUglCJRqvLpTJU2MsyVU=; b=ELfYDLCEyb/KICbhZANNZhLB+
        8QPRi4lVsBs+AR19o09ExyFn0h7kEZJKobvAcc96332PlpAgOqsh1/5i4Wn5227S3HqA4sXekmvGD
        ZHGc7BpxCZsUoyHLS7L6YeFczgy94u+haNlnLIUQTZlKptRdGlXAV1ASO2I4WZTCejqA0oOFQgctn
        btz1A+QfyKZdhL8iz9OpItjtU8UJaR4bjdVErdYQ4zXgxzO9MPnSx7lwmp+NK0r03vyrYK5LDqjic
        wwuRWD6d57VhJWKjF3Za+e2X+Q2IGkQwjpwkB0qB5UO8VdhKzABjlhEyJiqe5Xe0F011EuooZ3K2U
        PcvUGXKyQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hH9cG-0001gW-Gd; Thu, 18 Apr 2019 16:10:24 +0000
Date:   Thu, 18 Apr 2019 09:10:24 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     viro@zeniv.linux.org.uk, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
        linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] vfs, coda: Fix the lack of locking in FID
 replacement inode rehashing
Message-ID: <20190418161024.GG7751@bombadil.infradead.org>
References: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
 <155559636704.21702.4538723150377303298.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155559636704.21702.4538723150377303298.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 18, 2019 at 03:06:07PM +0100, David Howells wrote:
> Fix this by moving the core part of the code to fs/inode.c and providing it
> with a set() function akin to iget5().  We can then take the inode cache
> lock whilst performing the move.

> @@ -123,6 +132,8 @@ void coda_replace_fid(struct inode *inode, struct CodaFid *oldfid,
>  	
>  	BUG_ON(!coda_fideq(&cii->c_fid, oldfid));
>  
> +	rehash_inode(inode, hash, coda_reset_inode, newfid);
> +	
>  	/* replace fid and rehash inode */
>  	/* XXX we probably need to hold some lock here! */
>  	remove_inode_hash(inode);

Don't you also need to delete the remove_inode_hash() and
__insert_inode_hash() calls?

