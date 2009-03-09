From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
	extent trees.
Date: Mon, 9 Mar 2009 13:34:59 -0400
Message-ID: <20090309173459.GB8840@mit.edu>
References: <49B18CAB.5020605@redhat.com> <20090309113619.GH5578@mit.edu> <20090309160135.GA30654@skywalker> <49B54014.1030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60810 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZCIRfI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 13:35:08 -0400
Content-Disposition: inline
In-Reply-To: <49B54014.1030805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 09, 2009 at 11:13:08AM -0500, Eric Sandeen wrote:
> >> deep-tree-2.img.gz contains an extent tree of depth 4....
> >>
> 
> I think this jives w/ what the reporter had, although in the e2image the
> problematic inode only had depth 3 (at the time)

I'm downloading and decompressing the e2image from the reporter right
now.  Have you tried mounting the e2image over the loop device with
and without the patch?  That should be able to demonstrate the
problem, and then prove that the patch fixes it.  I'll also dump out
the extent tree from the reporter and try to create a small test case
based on the inode in question.  (Inode #2621457, right?)

      	     	      		 		  - Ted
