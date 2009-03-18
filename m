From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Wed, 18 Mar 2009 14:11:11 -0400
Message-ID: <20090318181111.GP15989@mit.edu>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com> <49BE8C30.5030901@redhat.com> <1237225369.3964.4.camel@bobble.smo.corp.google.com> <49BE90E0.3090309@redhat.com> <1237225989.3964.9.camel@bobble.smo.corp.google.com> <1237392694.31964.2.camel@bobble.smo.corp.google.com> <49C11E85.3040300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank Mayhar <fmayhar@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531AbZCRSLU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 14:11:20 -0400
Content-Disposition: inline
In-Reply-To: <49C11E85.3040300@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 18, 2009 at 11:17:09AM -0500, Eric Sandeen wrote:
> 
> Good deal; I'll just trust that it's fixed, and maybe at some point I'll
> sort out how they're related ;)
> 

... and the patch just appeared in mainline and so should be in
2.6.29.   :-)

						- Ted
