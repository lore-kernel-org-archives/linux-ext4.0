From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] xstat: Add a pair of system calls to make extended file stats available [ver #4]
Date: Fri, 02 Jul 2010 15:35:55 +0100
Message-ID: <991.1278081355@redhat.com>
References: <20100702110346.GB11732@laptop> <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab0GBOgD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 10:36:03 -0400
In-Reply-To: <20100702110346.GB11732@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nick Piggin <npiggin@suse.de> wrote:

> > Add a pair of system calls to make extended file stats available,
> > including file creation time, inode version and data version where
> > available through the underlying filesystem.
> 
> Can you describe the expected atomicity requirements for the requests,
> please?

As for stat(), lstat() and fstat().

David
