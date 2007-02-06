From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Mon, 5 Feb 2007 23:09:16 -0500
Message-ID: <20070206040916.GF11018@thunk.org>
References: <1170427180.6086.17.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>, sct@redhat.com
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46358 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965312AbXBFFxi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Feb 2007 00:53:38 -0500
Content-Disposition: inline
In-Reply-To: <1170427180.6086.17.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 02, 2007 at 08:09:40PM +0530, Kalpak Shah wrote:
> Hi,
> 
> This patch is a spinoff of the old nanosecond patches. It includes some
> cleanups and addition of a creation timestamp. The
> EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> s_{min, want}_extra_isize fields in struct ext3_super_block. 

Thanks for sending it.  I haven't had a chance to go over it in detail
yet, but one quick comment; the patch looks like it got line-wrapped
by your mail agent (looks like you're using Evolution 2.0).  Could you
send it as a text/plain attachment, or otherwise fix your mailer to
not wrap your patches?  

It might be nice if the patch had a way of adjusting the granularity
by masking off bits of the nanoseconds field, so we can benchmark how
much overhead constantly updating the ctime field is going to cost us.  

Regards,

						- Ted
