From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] jbd: JBD replace jbd_kmalloc with kmalloc
Date: Mon, 8 Oct 2007 11:34:50 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710081134310.29721@schroedinger.engr.sgi.com>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>  <20071004065204.GA21481@infradead.org>
  <1191623899.3861.29.camel@localhost.localdomain>
 <Pine.LNX.4.64.0710081045180.26627@schroedinger.engr.sgi.com>
 <1191867991.3870.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60758 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754793AbXJHSev (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2007 14:34:51 -0400
In-Reply-To: <1191867991.3870.6.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 8 Oct 2007, Mingming Cao wrote:

> So we replace jbd_kmalloc() to kmalloc() with __GFP_NOFAIL flag on in
> start_this_handle(). Other two places replacing to kmalloc() is part of
> the init process, so no need for __GFP_NOFAIL flag there.

Acked-by: Christoph Lameter <clameter@sgi.com>
