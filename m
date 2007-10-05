From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd/jbd2: JBD memory allocation cleanups
Date: Fri, 05 Oct 2007 15:33:23 -0700
Message-ID: <1191623603.3861.20.camel@localhost.localdomain>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
	 <1191477059-5357-2-git-send-email-tytso@mit.edu>
	 <20071004065204.GA21481@infradead.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38994 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761412AbXJEWdr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 18:33:47 -0400
In-Reply-To: <20071004065204.GA21481@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-10-04 at 07:52 +0100, Christoph Hellwig wrote:
> On Thu, Oct 04, 2007 at 01:50:36AM -0400, Theodore Ts'o wrote:
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > JBD: Replace slab allocations with page cache allocations
> 
> It's page allocations, not page cache allocations.
> 
> > Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly
> 
> That sounds like it should be a different patch..

Okay. Will sent the patches, that also separate JBD2 changes to a
different patch.
