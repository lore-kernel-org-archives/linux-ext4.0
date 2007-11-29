From: David Howells <dhowells@redhat.com>
Subject: Re: [patch 3/8] 64-bit i_version: afs fixes
Date: Thu, 29 Nov 2007 22:23:45 +0000
Message-ID: <21098.1196375025@redhat.com>
References: <200711292052.lATKqnvt006831@imap1.linux-foundation.org>
Cc: dhowells@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, jean-noel.cordenner@bull.net
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761354AbXK2WYw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 17:24:52 -0500
In-Reply-To: <200711292052.lATKqnvt006831@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

akpm@linux-foundation.org wrote:

> -	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%lu }",
> +	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%llu }",
>  	       fid.vnode,
>  	       fid.unique,
>  	       dentry->d_inode->i_ino,
> -	       dentry->d_inode->i_version);
> +	       (unsigned long long)dentry->d_inode->i_version);

Hmmm...  In AFS's case this is overkill...  The value contained in i_version
is going to be a 32-bit number because that's all the protocol supports.

David
