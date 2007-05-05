From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Sat, 5 May 2007 11:58:45 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0705051156200.20079@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
 <20070504130241.c436eb43.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@clusterfs.com, clameter@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52088 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423122AbXEEI6r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2007 04:58:47 -0400
In-Reply-To: <20070504130241.c436eb43.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 4 May 2007, Andrew Morton wrote:
> I got 100% rejects against this because Christoph has already had
> his paws all over the slab constructor code everywhere.
> 
> Was going to fix it up but then decided that we ought to make changes
> like this to ext4 as well.  Ideally beforehand, but simultaneously is
> OK as long as it's simple enough.

I'll send you proper patches for them (and will convert other filesystems 
too).

On Fri, 4 May 2007, Andrew Morton wrote:
> btw, for a benchmark I'd suggest just a silly create-10000-files
> tight loop rather than something more complex like postmark.

Do you want me to redo the benchmarks or are you happy enough with the 
postmark numbers?

				Pekka
