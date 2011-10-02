From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] ext4: make quota as first class supported feature
Date: Sun, 2 Oct 2011 10:34:41 -0400
Message-ID: <20111002143441.GA10851@infradead.org>
References: <1313780769-21713-1-git-send-email-adityakali@google.com>
 <0EC4FCD1-1DBB-417C-BE5D-4B39ABD67A56@dilger.ca>
 <20110829204602.GI5672@quack.suse.cz>
 <20110909154057.GA7738@infradead.org>
 <20110910202409.GB6709@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Aditya Kali <adityakali@google.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43702
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab1JBOes (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 10:34:48 -0400
Content-Disposition: inline
In-Reply-To: <20110910202409.GB6709@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 10, 2011 at 10:24:09PM +0200, Jan Kara wrote:
>   Well, the trouble is with systems which have accounts stored e.g. in
> LDAP with thousands / tens thousands of users (although each machine is
> used only by a small subset of users). Then iterating with getpwent gets
> really inefficient...

Please make sure to Cc the xfs list when adding an interface like this,
as it's trivial to implement for us.

