From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Sat, 5 May 2007 12:08:55 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0705051206500.20143@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
 <20070504130241.c436eb43.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705051156200.20079@sbz-30.cs.Helsinki.FI>
 <20070505020202.8edd0110.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@clusterfs.com, clameter@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54594 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXEEJI5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2007 05:08:57 -0400
In-Reply-To: <20070505020202.8edd0110.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 5 May 2007, Andrew Morton wrote:
> I doubt if this is measurable, really.  It'll be something like the
> difference between an L1 hit and an L2 hit in amongst all the other stuff
> we do on a per-inode basis.

The cache effects are probably not easily measurable but I was worried 
about CPU time. The slab constructors and destructors were originally 
designed to reduce CPU time spent on initializing objects. But I don't 
think that's relevant anymore on todays CPUs.

			Pekka
