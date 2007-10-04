From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jbd/jbd2: JBD memory allocation cleanups
Date: Thu, 4 Oct 2007 07:52:04 +0100
Message-ID: <20071004065204.GA21481@infradead.org>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu> <1191477059-5357-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39167 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXJDGwJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2007 02:52:09 -0400
Content-Disposition: inline
In-Reply-To: <1191477059-5357-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 04, 2007 at 01:50:36AM -0400, Theodore Ts'o wrote:
> From: Mingming Cao <cmm@us.ibm.com>
> 
> JBD: Replace slab allocations with page cache allocations

It's page allocations, not page cache allocations.

> Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly

That sounds like it should be a different patch..
