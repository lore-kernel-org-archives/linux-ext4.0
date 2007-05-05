From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] ext3: remove inode constructor
Date: Sat, 5 May 2007 12:21:19 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0705051214110.20425@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705041311230.1455@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0705040907180.21436@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33579 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbXEEJVV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 May 2007 05:21:21 -0400
In-Reply-To: <Pine.LNX.4.64.0705040907180.21436@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 4 May 2007, Christoph Lameter wrote:
> Also could this be generalized to also apply to the generic inode 
> allocation in fs/inode.c?

I think we want to stick inode_init_ince() in alloc_inode() but we can't 
do that until all filesystems are converted over.

			Pekka
