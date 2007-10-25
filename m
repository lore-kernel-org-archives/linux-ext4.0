From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 update
Date: Thu, 25 Oct 2007 16:31:13 -0700
Message-ID: <20071025163113.491a4461.akpm@linux-foundation.org>
References: <E1Ii0UI-0007TW-IM@closure.thunk.org>
	<alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790AbXJYXbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 19:31:48 -0400
In-Reply-To: <alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 17 Oct 2007 08:59:53 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 17 Oct 2007, Theodore Ts'o wrote:
> > 
> > Please pull from:
> > 
> >         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> This conflicts in nontrivial ways with
> 
> 	commit 7c9e69faa28027913ee059c285a5ea8382e24b5d
> 	Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 	Date:   Tue Oct 16 23:27:02 2007 -0700
> 
> 	    ext2/ext3/ext4: add block bitmap validation
> 
> which I just merged from -mm.

<catching up>

There shouldn't have been conflicts here - if there were I wouldn't have
sent those patches.  Unless there were things in the ext4 pull which
weren't present in the ext4 quilt tree which I included in 2.6.23-mm1?
