From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Fri, 27 Jul 2007 11:34:19 -0400
Message-ID: <20070727153419.GA13515@thunk.org>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org> <46A8895A.5000308@linux.vnet.ibm.com> <20070726161325.GB12895@thunk.org> <46A95F93.3020001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39514 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761302AbXG0Peb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2007 11:34:31 -0400
Content-Disposition: inline
In-Reply-To: <46A95F93.3020001@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2007 at 08:29:31AM +0530, Aneesh Kumar K.V wrote:
> What are the issues you see with PATCH 1 and PATCH 2 which implement 
> Undo I/O Manager and undoe2fs other than it is not hooked into any of
> the existing tools. I will try to add it to mke2fs as you suggested. But
> should that prevent it from going in ?

The main issue is that it's not used by an in-tree caller.  If you can
add it to mke2fs, that would be great; otherwise, it's something
that's on my todo list so we can merge the undo manager.  The other
possibility is that I might use this as justification for creating a
"pu" (proposed update) branch which has the property that patches on
the pu branch can get removed or modified at any time, and the "pu"
branch can get rewound or rebased at any time.

See the section of text starting at line #68 (and going on to line
#160) in the following git's maintainer notes for a much more
comprehensive description of "maint", "master", "next", and "pu",
which is the direction in which I plan to take the e2fsprogs git tree:

http://git.kernel.org/?p=git/git.git;a=blob;f=MaintNotes;h=8bf0352adf2b4ac775d6100ad937600ecb5be5f2;hb=962753f75390f5c5ea23a2d1e6996f6027003478

But yes, the main reason why I haven't merged the undo manager is
because we don't have an in-tree user of that interface.  We don't
even have test cases in the tree, either (also on my todo list, but
feel free to beat me to it).

						- Ted
