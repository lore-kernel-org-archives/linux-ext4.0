From: Alex Tomas <alex@clusterfs.com>
Subject: Re: where is the ext4 git tree ?
Date: Fri, 26 Jan 2007 13:47:24 -0700
Message-ID: <20070126204724.GA14191@mail.clusterfs.com>
References: <1169805918.32648.14.camel@colyT43.site> <45BA24CB.5060501@us.ibm.com> <20070126165119.GC14759@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, coly <colyli@gmail.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50353 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbXAZUrY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Jan 2007 15:47:24 -0500
Content-Disposition: inline
In-Reply-To: <20070126165119.GC14759@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 26, 2007 at 11:51:19AM -0500, Theodore Tso wrote:
> The first patch series can be found here:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.20-rc5-ext4-1
> 
> I've included Alex's latest patches which he sent back in December,
> but I haven't gone back before that looking for patches from before.
> If you think there is a patch which should be included that hasn't
> been, please repost it to linux-ext4.  


I'd appreciate a lot review and discussion of mballoc's design.

the most serious change over the last version is preallocation. because
of specific workloads our customers like we have to support multiple
preallocations per inode.

a bit about structures ... every preallocated chunk is described with a
special structure. preallocated space is assigned to logical offset of
a file. the structure is on two lists:
  1) preallocations in a group
  2) preallocations in an inode

before searching blocks, mballoc loads on-disk bitmap and generates:
  1) in-core bitmap, which is copy of on-disk bitmap + all preallocated
     blocks in the group
  2) buddy, which is generated from in-core bitmap

once the both structures are initialized, mballoc finds suitable space
and creates preallocation descriptor, if preallocation is requested.
subsquent allocations find the descriptor via per-inode list using logical
offset as a key and mark block(s) used in on-disk bitmap.

thanks, Alex
