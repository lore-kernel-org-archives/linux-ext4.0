From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Thu, 22 Sep 2016 06:18:54 -0700
Message-ID: <20160922131854.GA14759@infradead.org>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
 <20160921143748.xswkovbjrtcgs3bq@thunk.org>
 <20160922123143.GO2834@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52703 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933405AbcIVNS5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Sep 2016 09:18:57 -0400
Content-Disposition: inline
In-Reply-To: <20160922123143.GO2834@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2016 at 02:31:43PM +0200, Jan Kara wrote:
> So I think what Christoph meant in this case is something like attached
> patch. That achieves more than your dirty hack in a much cleaner way.
> Beware, the patch is only compile-tested.

Yes, that's exactly what I had in mind.
