From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 27/28] ext4: xattr inode deduplication
Date: Thu, 6 Jul 2017 00:19:04 -0400
Message-ID: <20170706041904.6fw4gc37ml6fr366@thunk.org>
References: <6E41DA31-A524-4E0E-BD0B-5C994399BBC6@dilger.ca>
 <20170620090721.12480-1-tahsin@google.com>
 <20170704183919.vpk7xuikjdh6s5gu@thunk.org>
 <CAAeU0aPrnLq78vD05bJD9eRU0Vw+OaRz2Tuy_sa=ybdaKWkNow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51884 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750968AbdGFETK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Jul 2017 00:19:10 -0400
Content-Disposition: inline
In-Reply-To: <CAAeU0aPrnLq78vD05bJD9eRU0Vw+OaRz2Tuy_sa=ybdaKWkNow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 05, 2017 at 10:30:17AM -0700, Tahsin Erdogan wrote:
> >          * 5) group descriptor for new xattr block
> > +        * 6) block bitmap update for old xattr block
> > +        * 7) group descriptor for new old block
> 
> s/new old block/old block/

Thanks, I've fixed that up in my tree.

	     	   	      - Ted
