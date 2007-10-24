From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 16:59:35 -0600
Message-ID: <20071024225935.GI26078@webber.adilger.int>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F7F41.6080800@redhat.com> <20071024210639.GC26078@webber.adilger.int> <471FB5F8.1090805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:59743 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXJXW7h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 18:59:37 -0400
Content-Disposition: inline
In-Reply-To: <471FB5F8.1090805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 24, 2007  16:15 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > It is useful to be able to mount w/o extents/delalloc/mballoc for perf
> > testing and functional testing of the block-mapped file path in ext4.
> > Also, some users might want the ability to use features of ext4 w/o
> > the incompatibility of extents.
> 
> Right, I understand the reason for noextents, nodelalloc, nomballoc.
> Above, I ask what is the point of having the *defaults* (extents,
> delalloc, mballoc) as mount options?

Partly for symmetry, and also to be able to override any "no*" options
that might have been specified previously (e.g. in some script that the
user doesn't directly control, but can pass additional options to).

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
