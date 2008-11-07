From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Mark the buffer_heads as dirty and uptodate
	after prepare_write
Date: Fri, 7 Nov 2008 08:33:03 -0500
Message-ID: <20081107133303.GA9543@mit.edu>
References: <1226063563-16220-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, vallesroc@gmail.com,
	Solofo.Ramangalahy@bull.net, cryptooctoploid@gmail.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:50559 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYKGNdW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 08:33:22 -0500
Content-Disposition: inline
In-Reply-To: <1226063563-16220-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Per discussion on IRC, we've Aneesh and I have concluded that the V1
patch is correct, and in fact calling block_commit_write() when we
will be redirtying the page (a) can cause problems if one or more
buffer heads on the page is marked for delayed allocation and so
bh->block_nr is 0, and (b) wastes disk bandwidth since the page
contents will be potentially written out twice.

So we'll be going with the V1 version of the patch, and pushing it to
Linus ASAP.

						- Ted
