From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix header check in ext4_ext_search_right() for deep
 extent trees.
Date: Mon, 09 Mar 2009 12:51:54 -0500
Message-ID: <49B5573A.4060407@redhat.com>
References: <49B18CAB.5020605@redhat.com> <20090309113619.GH5578@mit.edu> <20090309160135.GA30654@skywalker> <49B54014.1030805@redhat.com> <20090309173459.GB8840@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	David Dindorp <ddi@dubex.dk>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42048 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbZCIRwD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 13:52:03 -0400
In-Reply-To: <20090309173459.GB8840@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Mar 09, 2009 at 11:13:08AM -0500, Eric Sandeen wrote:
>>>> deep-tree-2.img.gz contains an extent tree of depth 4....
>>>>
>> I think this jives w/ what the reporter had, although in the e2image the
>> problematic inode only had depth 3 (at the time)
> 
> I'm downloading and decompressing the e2image from the reporter right
> now.  Have you tried mounting the e2image over the loop device with
> and without the patch?  That should be able to demonstrate the
> problem, and then prove that the patch fixes it.  I'll also dump out
> the extent tree from the reporter and try to create a small test case
> based on the inode in question.  (Inode #2621457, right?)
> 
>       	     	      		 		  - Ted

I have mounted it but I'm not sure that's sufficient to trip the case.

A dump of the inode in question from the e2image is at:

http://bugzilla.kernel.org/attachment.cgi?id=20449&action=view

(slightly massaged from default output)

-Eric
