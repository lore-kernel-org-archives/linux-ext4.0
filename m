From: tytso@mit.edu
Subject: Re: [PATCH] ext4: memory leakage in ext4_mb_init()
Date: Mon, 5 Apr 2010 08:42:23 -0400
Message-ID: <20100405124223.GN18524@thunk.org>
References: <87sk7nv4sp.fsf@linux.vnet.ibm.com>
 <x2vac8f92701003280113k2458fcb6mefe6c04875c9b3a3@mail.gmail.com>
 <20100403165340.GA17819@thunk.org>
 <j2tac8f92701004031805s9b09d04csc5adf5199dc9b9a7@mail.gmail.com>
 <20100404180845.GG18524@thunk.org>
 <v2oac8f92701004042053p1738ece4u299dcb481b2fc3f2@mail.gmail.com>
 <4BB966AE.1060207@redhat.com>
 <t2pac8f92701004042151x3b0c27e2h805778b7b3aeefba@mail.gmail.com>
 <4BB96E14.9010903@redhat.com>
 <o2tac8f92701004042208l99c70297mf9955beacacd96bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53352 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0DEMnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 08:43:17 -0400
Content-Disposition: inline
In-Reply-To: <o2tac8f92701004042208l99c70297mf9955beacacd96bf@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 05, 2010 at 01:08:58PM +0800, jing zhang wrote:
> 
> Before linux-2.6.32 is released, would you like tell me, how is ext4 tested?
> Is tough testing able to catch all bugs?

For one thing, we use the XFSQA (aka xfstests) test suite.  I usually
run the "quick" set of tests between each commit, and I run a much
longer "auto" test suite before submitting a set of patches to Linus.

For specific patches, we also like to be able to test it specifically.
So often we'll create a small filesystem image and then see what the
file system does with and without the patch.  For example, if we're
worried that a specific file system corruption will cause a BUG_ON,
we'll create a small file system, corrupt it using the debugfs tool,
and then demonstrate that without the patch, we get the BUG_ON.  With
the patch applied, the BUG_ON should go away.

So the patch-specific tests are there so we can make sure the patch
does what we think it should, and it fixes the problem it claims to
fix.  The XFSQA test suite is to there to make sure that we don't
accidentally introduce bugs while trying to improve the file system.

And of course, the final safeguard is patch review by others.  This is
where decent comments and making sure the code is maintainable is
critically important.  Since this takes other developer's time,
especially senior developers like Eric and myself's time, which is
rather valuable and hard to find, it's why patch submitters need
shoulder more of the work in terms of refining patches and
resubmitting new versions of the patches.

						- Ted

P.S.  Yes, Eric was absolutely correct.  I wanted to know how much
testing you had been doing on your patches before submitting them.  At
least few of your patches have caused me to wonder whether the patches
had gone through sufficient testing.
