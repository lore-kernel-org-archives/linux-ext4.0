From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: always pre-allocate max depth for path
Date: Thu, 7 Jul 2016 12:39:00 -0400
Message-ID: <20160707163900.GC19871@thunk.org>
References: <55AFDADC-DF82-41FC-8C5C-A0E3D97EF51A@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Faccini, Bruno" <bruno.faccini@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58512 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcGGQjG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jul 2016 12:39:06 -0400
Content-Disposition: inline
In-Reply-To: <55AFDADC-DF82-41FC-8C5C-A0E3D97EF51A@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 23, 2016 at 11:52:29AM +0000, Faccini, Bruno wrote:
> From: Bruno Faccini <bruno.faccini@intel.com>
> 
> I have first found this way to fix holes in previous ext4 layers versions
> where an array of struct ext4_ext_path had been allocated with an arbitrary
> evaluated size and finally could overrun upon ext_depth() growth outside
> i_data_sem protection. But it seems it can still help with recent ext4
> version, to avoid re-allocation need and overhead when it can be allocated
> to max possible extent depth (ie, 5 presently) at first time and for a low
> cost regarding its memory foot-print, it should also avoid further invalid
> dereference by underlying callers sharing same ppath (with present
> inter-routines path re-use scheme), and also upon re-allocation error.
> 
> Signed-off-by: Bruno Faccini <bruno.faccini@intel.com>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Cc: linux-ext4@vger.kernel.org

Since this came up on the ext4 call, let me give a quick update about
my concerns about this patch.

The problem with the max possible extent depth assumption is that this
assumes non-pathological trees.  Unfortunately, at the moment we don't
dont ever shrink the extent tree as we delete entries from the tree,
and we aren't obeying the requirements of a formal B+ tree, which is
that all nodes (except for a trivial tree consiting of a single leaf
node at the root) must be at least half-full.  So while it is highly
unlikely, it is possible to create highly pathological trees that
could potentially be deeper than five deep.

They are extremely unlikely to happen in practice, granted, but if we
are relying on this to prevent array bound overflow attacks, a
malicious attacker could potentially be very happy to arrange such as
situation.

So at least in the short run, we may be better off finding all of the
places where we drop i_data_sem after we've allocated the struct path
array, and after we grab it again for writing, double check to see if
we need to reallocate it.  For performance reasons I'm happy always
allocating an extra array element or two to minimize the need to do
the reallocation, but for correctness's sake it would be good if we
could easily test the code path where we need to do a reallocation, as
well as demonstrate that we do the right thing if the reallocation
fails...

					- Ted
