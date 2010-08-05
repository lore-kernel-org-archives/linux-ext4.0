From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
 are no dirty pages.
Date: Thu, 5 Aug 2010 12:45:04 -0400
Message-ID: <20100805164504.GI2901@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <1273002566.3755.10.camel@mingming-laptop>
 <20100629205102.GM15515@tux1.beaverton.ibm.com>
 <20100805164008.GH2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Darrick J. Wong" <djwong@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kern
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47504 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0HEQpH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Aug 2010 12:45:07 -0400
Content-Disposition: inline
In-Reply-To: <20100805164008.GH2901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

P.S.  If it wasn't clear, I'm still in favor of trying to coordinate
barriers across the whole file system, since that is much more likely
to help use cases that arise in real life.

   	    	       	     	     - Ted
