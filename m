From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Mon, 7 Jul 2008 13:07:31 +0200
Message-ID: <20080707110730.GG5643@ucw.cz>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org.uk,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756265AbYGHNjK@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> I still disagree with this whole patch.  There is not reason to let
> the freeze request timeout - an auto-unfreezing will only confuse the
> hell out of the caller.  The only reason where the current XFS freeze
> call can hang and this would be theoretically useful is when the

What happens when someone dirties so much data that vm swaps out
whatever process that frozen the filesystem?

I though that was why the timeout was there...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
