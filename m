From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Tue, 1 Jul 2008 04:10:26 -0400
Message-ID: <20080701081026.GB16691@infradead.org>
References: <20080630212450t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYGAIK3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2008 04:10:29 -0400
Content-Disposition: inline
In-Reply-To: <20080630212450t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I still disagree with this whole patch.  There is not reason to let
the freeze request timeout - an auto-unfreezing will only confuse the
hell out of the caller.  The only reason where the current XFS freeze
call can hang and this would be theoretically useful is when the
filesystem is already frozen by someone else, but this should be fixed
by refusing to do the second freeze, as suggested in my comment to patch
1.

