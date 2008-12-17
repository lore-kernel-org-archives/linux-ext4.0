From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Wed, 17 Dec 2008 01:00:51 -0500
Message-ID: <20081217060051.GK10590@mit.edu>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com> <1229362555.19828.2.camel@bobble.smo.corp.google.com> <20081216040011.GF11502@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46806 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbYLQGAx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Dec 2008 01:00:53 -0500
Content-Disposition: inline
In-Reply-To: <20081216040011.GF11502@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note, the patch allow-ext4-to-run-without-a-journal conflicted with a
large number of other patches in the patch queue.  I fixed it up as
best I could, and reviewed all of the changed patches, and I think
it's OK.  Please be cautious when first testing this, though.

     	  	    	     	  		- Ted
