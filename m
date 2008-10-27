From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Add error handling of write_super_lockfs/unlockfs
Date: Mon, 27 Oct 2008 09:03:00 -0400
Message-ID: <20081027130259.GA1919@infradead.org>
References: <20081027215832t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYJ0NDF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 09:03:05 -0400
Content-Disposition: inline
In-Reply-To: <20081027215832t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good.
