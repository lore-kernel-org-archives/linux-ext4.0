From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Journal credits debugging (Was: Re: Bug#615998: ...)
Date: Wed, 29 Jun 2011 01:27:40 -0600
Message-ID: <37DE6F9F-E43F-4EB8-9A1D-6CDB59F90134@dilger.ca>
References: <BANLkTi=xXtnsBECOdSsC4_1bgnCrwsMb6g@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jan Kara <jack@suse.cz>,
	"Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>,
	"Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Sean Ryle <seanbo@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:24216 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1F2H1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 03:27:43 -0400
In-Reply-To: <BANLkTi=xXtnsBECOdSsC4_1bgnCrwsMb6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-29, at 1:10 AM, Amir Goldstein wrote:
> I would like to suggest an approach that may help us track down these
> sort of bugs more easily.
> 
> Add a new class_id argument to ext4_handle_dirty_metadata() and collect
> statistics of used credits per class_id.
> 
> There are only so many types of journaled objects:
> SUPER, GDT, BB, IB, ITB, IND, EXT, DATA, XATTR, QUOT...
> So it shouldn't be a problem to save the statistics per handle.
> 
> If you look at struct jbd2_journal_handle, you will find a bunch of h_cow_XXX
> fields intended as COW debugging counters.
> We may as well turn these fields into a generic counters array, which can
> be used by either COW debugging or credits debugging code.
> 
> This should be simple enough to implement and should provide
> a more detailed report when buffer credits have run out.
> 
> However, if we are going to modify all call sites of
> ext4_handle_dirty_metadata(), it would be wise to also add an object_id
> (or a better name) argument that will provide the group no. or inode no.
> or quota type, or any other id relevant for classification.
> 
> We can use this information, along with where, line, handle, ino,
> block_nr, buffer_credits and create a stable trace point in
> __ext4_handle_dirty_metadata().

One of the things I like about the ZFS/DMU transaction API is that instead
of the caller having to "just know" how many credits are needed to modify
the filesystem, the caller specifies the inodes/directories that will be
modified, and if new inodes are allocated in a "declaration" step before
starting the transaction.  This allows the internal code to account for the
metadata will be modified, and avoids the knowledge of journal credits for
different update types all over the code.

Cheers, Andreas





