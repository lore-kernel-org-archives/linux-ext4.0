Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED49C43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDC03206C1
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 15:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfDYPpa (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfDYPp3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 Apr 2019 11:45:29 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCBE01219B3;
        Thu, 25 Apr 2019 15:45:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EAC660C64;
        Thu, 25 Apr 2019 15:45:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190425151911.GR2217@ZenIV.linux.org.uk>
References: <20190425151911.GR2217@ZenIV.linux.org.uk> <155620449631.4720.8762546550728087460.stgit@warthog.procyon.org.uk> <155620453168.4720.4510967359017466912.stgit@warthog.procyon.org.uk>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vfs: Allow searching of the icache under RCU conditions [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8104.1556207127.1@warthog.procyon.org.uk>
Date:   Thu, 25 Apr 2019 16:45:27 +0100
Message-ID: <8105.1556207127@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 25 Apr 2019 15:45:29 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> wrote:

> Hmm...  Why do these stores to ->i_state need WRITE_ONCE, while an arseload
> of similar in fs/fs-writeback.c does not?

Because what matters in find_inode_rcu() are the I_WILL_FREE and I_FREEING
flags - and there's a gap during iput_final() where neither is set.

	if (!drop) {
		inode->i_state |= I_WILL_FREE;
		spin_unlock(&inode->i_lock);
		write_inode_now(inode, 1);
		spin_lock(&inode->i_lock);
		WARN_ON(inode->i_state & I_NEW);
		inode->i_state &= ~I_WILL_FREE;
 --->
	}

	inode->i_state |= I_FREEING;

It's normally covered by i_lock, but it's a problem if anyone looks at the
pair without taking i_lock.

Even flipping the order:

	if (!drop) {
		inode->i_state |= I_WILL_FREE;
		spin_unlock(&inode->i_lock);
		write_inode_now(inode, 1);
		spin_lock(&inode->i_lock);
		WARN_ON(inode->i_state & I_NEW);
		inode->i_state |= I_FREEING;
		inode->i_state &= ~I_WILL_FREE;
	} else {
		inode->i_state |= I_FREEING;
	}

isn't a guarantee of the order in which the compiler will do things AIUI.
Maybe I've been listening to Paul McKenney too much.  So the WRITE_ONCE()
should guarantee that both bits will change atomically.

Note that ocfs2_drop_inode() looks a tad suspicious:

	int ocfs2_drop_inode(struct inode *inode)
	{
		struct ocfs2_inode_info *oi = OCFS2_I(inode);

		trace_ocfs2_drop_inode((unsigned long long)oi->ip_blkno,
					inode->i_nlink, oi->ip_flags);

		assert_spin_locked(&inode->i_lock);
		inode->i_state |= I_WILL_FREE;
		spin_unlock(&inode->i_lock);
		write_inode_now(inode, 1);
		spin_lock(&inode->i_lock);
		WARN_ON(inode->i_state & I_NEW);
		inode->i_state &= ~I_WILL_FREE;

		return 1;
	}

David
