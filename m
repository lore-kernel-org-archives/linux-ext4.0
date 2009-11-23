From: tytso@mit.edu
Subject: Re: [PATCH 5/8] ext4: call ext4_forget() from ext4_free_blocks()
Date: Mon, 23 Nov 2009 15:28:56 -0500
Message-ID: <20091123202856.GF2183@thunk.org>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
 <1258942710-31930-6-git-send-email-tytso@mit.edu>
 <A70619A1-1E84-425A-956E-7C0DE156F046@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36076 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZKWU2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 15:28:53 -0500
Content-Disposition: inline
In-Reply-To: <A70619A1-1E84-425A-956E-7C0DE156F046@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 12:22:29PM -0700, Andreas Dilger wrote:
> >Also fix a bug in the extents migration code; it wasn't calling
> >ext4_forget() when releasing the indirect blocks during the
> >conversion.
> 
> Would this also solve Curt's problem, mentioned in "Bug in extent
> zeroout: blocks not marked as new" where bforget was not being
> called when the blocks are freed?

No, Curt was referring to the extents code which convert uninitialized
to initialized extents; the code I was referring to is the code which
migrates direct/indirect-mapped inodes to extent-mapped inodes.

						- Ted

