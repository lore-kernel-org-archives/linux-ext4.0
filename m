From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] ext4: remove i_alloc_sem abuse
Date: Tue, 21 Jun 2011 13:16:20 -0400
Message-ID: <20110621171620.GA13891@infradead.org>
References: <20110620201533.847236272@bombadil.infradead.org>
 <20110620202030.765939598@bombadil.infradead.org>
 <alpine.LFD.2.00.1106211824330.21178@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
	tglx@linutronix.de, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	hirofumi@mail.parknet.co.jp, mfasheh@suse.com, jlbec@evilplan.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1106211824330.21178@dhcp-27-109.brq.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 21, 2011 at 06:34:50PM +0200, Lukas Czerner wrote:
> this looks like a bug fix, so we should rather do it in a separate
> commit. Could you send it separately, or at least mention that in commit
> description ?

What looks like a bugfix?

