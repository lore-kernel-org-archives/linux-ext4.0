Return-Path: <SRS0=ZWG9=SU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D2FC10F14
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 15:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4A3A205F4
	for <linux-ext4@archiver.kernel.org>; Thu, 18 Apr 2019 15:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfDRPIn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:08:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36734 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388457AbfDRPIn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Apr 2019 11:08:43 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hH8eQ-0006DN-1x; Thu, 18 Apr 2019 15:08:34 +0000
Date:   Thu, 18 Apr 2019 16:08:34 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] ext4: Search for an inode to update under the
 RCU lock if we can
Message-ID: <20190418150833.GE2217@ZenIV.linux.org.uk>
References: <155559635133.21702.4737487773869377967.stgit@warthog.procyon.org.uk>
 <155559640398.21702.15109713276957584268.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155559640398.21702.15109713276957584268.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 18, 2019 at 03:06:44PM +0100, David Howells wrote:
> +	inode = find_inode_by_ino_rcu(sb, ino);
> +	if (!inode)
> +		return;
>  
>  	if ((inode->i_ino != ino) ||
>  	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
>  			       I_DIRTY_INODE)) ||
>  	    ((inode->i_state & I_DIRTY_TIME) == 0))

Umm...  The situation with memory barriers here needs to be documented,
IMO.  And I'm not sure if the thing is actually correct...
