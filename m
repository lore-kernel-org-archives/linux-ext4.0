From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: ext3_forget() and ext3_free_blocks()
Date: Fri, 2 Feb 2007 02:30:02 -0800
Message-ID: <200702020230.02728.agruen@suse.de>
References: <20070201010836.31a63ef2.akpm@osdl.org> <1170363373.4271.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXBBKaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Feb 2007 05:30:18 -0500
In-Reply-To: <1170363373.4271.44.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 01 February 2007 12:56, Mingming Cao wrote:
> Is this a potential problem? Looks like other places calling
> ext3_free_block() it all has ext3_forget() called before that.

No, the order between the two doesn't matter. I'm still unclear about leads to 
the xattr block double-free you are seeing.

Andreas
