From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: add generic uevent infrastructure
Date: Mon, 18 Nov 2013 08:20:45 -0800
Message-ID: <20131118162045.GA3268@infradead.org>
References: <1384785520-607-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1384785520-607-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 18, 2013 at 06:38:40PM +0400, Dmitry Monakhov wrote:
> *Purpose:
> It is reasonable to annaunce fs related events via uevent infrastructure.
> This patch implement only ext4'th part, but IMHO this should be usefull for
> any generic filesystem.

It does indeed look very generic.  How about you try to redo it to sit
at the VFS level?

Also Jan Kara has done quota netlink notifications a while ago, which
fit into the same sort of niche.

