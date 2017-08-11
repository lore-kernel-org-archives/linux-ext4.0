From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Date: Fri, 11 Aug 2017 03:01:47 -0700
Message-ID: <20170811100147.GB7064@infradead.org>
References: <1501690186-17607-1-git-send-email-lczerner@redhat.com>
 <20170805084601.GA12425@infradead.org>
 <20170807121212.nuiho4afmdjf5vsd@rh_laptop>
 <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbdHKKBr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Aug 2017 06:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20170808090016.lxfbcrhoybmyfvlc@rh_laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 08, 2017 at 11:00:16AM +0200, Lukas Czerner wrote:
> So I've read the thread where you talk about this. I do not see anything
> about it being a masive mistake. I only see that you're confident that's
> it's a wrong thing to do. Like you're ever not confident about
> something;) Care to elaborate on what's wrong with it and why we do not
> want it ? On the surface it does look like a usefull option to have.

The problem is that DAX is an implementation detail on how to write
data back.  It has absolutely no user visible semantics.  Encoding
such a detail in the on-disk format is not a good idea.
