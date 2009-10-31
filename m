From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Sat, 31 Oct 2009 20:54:28 +0530
Message-ID: <20091031152428.GA25548@skywalker.linux.vnet.ibm.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
 <20091016091558.GA10184@mit.edu>
 <20091027101534.GA27584@skywalker.linux.vnet.ibm.com>
 <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com>
 <4AEA0B71.5050805@redhat.com>
 <3D6E88E0-7271-4CEC-85DC-9E4416F030F5@sun.com>
 <20091031091528.GO18464@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Parag Warudkar <parag.lkml@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ex
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58139 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbZJaPZy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Oct 2009 11:25:54 -0400
Content-Disposition: inline
In-Reply-To: <20091031091528.GO18464@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 31, 2009 at 05:15:28AM -0400, Theodore Tso wrote:
> On Fri, Oct 30, 2009 at 01:56:27PM -0600, Andreas Dilger wrote:
> > I wonder if there are multiple problems involved here?  Eric, it seems
> > possible that your reproducer is exercising a similar, though unrelated
> > codepath.  
> 
> Note that Aneesh has pubished two patches which insert a call to
> ext4_discard_preallocations().  One is a patch which inserts it into
> fs/inode.c's truncate path (for direct/indirect-mapped inodes) and one
> which is patch which inserts it into fs/extents.c truncate path (for
> extent-mapped inodes).  As near as I can tell both patches are
> necessary, and it looks to me like they should be combined into a
> single patch, since commit 487caeef9 affects both truncate paths.
> Aneesh, do you concur?
> 

We need only the patch that drop prealloc space in ext4_truncate_restart_trans
ext4_ext_truncate_extend_restart calls ext4_truncate_restart_trans. So adding
the prealloc space dropping in ext4_truncate_restart_trans should handle both
direct/indirect-mapped inode and extent-mapped inodes.

-aneesh
