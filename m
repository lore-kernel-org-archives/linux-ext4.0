From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
 i_generation available by xattrs
Date: Mon, 28 Jun 2010 15:21:05 -0400
Message-ID: <20100628192105.GA23863@infradead.org>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
 <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com>
 <20100628164854.GA9979@samba1>
 <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra@samba.org>,
	David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0F1TVS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 15:21:18 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 28, 2010 at 12:04:09PM -0500, Steve French wrote:
> That sounds better but it hits the fs, vfs and libc
> and seems like libc is near impossible to get changes into.

If you do it properly it's not hard to get changes into libc.

Let's do it properly instead of adding hacks like that.  Synthetic
xattrs causes much more problems than they solve.

