From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ordered mode rewrite for jbd2/ext4
Date: Wed, 4 Jun 2008 22:33:54 -0400
Message-ID: <20080605023354.GB10488@mit.edu>
References: <20080604154435.GE16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53045 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752752AbYFECeO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2008 22:34:14 -0400
Content-Disposition: inline
In-Reply-To: <20080604154435.GE16572@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 04, 2008 at 05:44:35PM +0200, Jan Kara wrote:
>   Hi,
> 
>   So I've split and ported ordered mode rewrite for ext4+jbd2.
> The core of the rewrite are two patches

I've integrated your patches into the unstable portion of the patch
queue; I have not had a chance to review them yet, but this way they
can start getting tested.

						- Ted
