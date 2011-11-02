From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Improve cmtime update on shared writable mmaps
Date: Wed, 2 Nov 2011 03:38:12 -0400
Message-ID: <20111102073812.GB17580@infradead.org>
References: <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
 <6e365cb75f3318ab45d7145aededcc55b8ededa3.1319844715.git.luto@amacapital.net>
 <20111101225342.GG18701@quack.suse.cz>
 <CALCETrW3ZZ=474cXY0HH1=fHTwKJUo--ufPfD1WLpGRC4_CPrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49310
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab1KBHiS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 03:38:18 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrW3ZZ=474cXY0HH1=fHTwKJUo--ufPfD1WLpGRC4_CPrw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 01, 2011 at 04:02:24PM -0700, Andy Lutomirski wrote:
> Hmm.  Isn't it permitted to at least read from an fs while holding the
> page lock?  I thought that the page lock was held for the entire
> duration of a read and at the beginning of writeback.
> 
> I can push this down to the ->writepage implementations or to the
> clear_page_dirty_for_io callers, but that will result in a bigger
> patch.

Besides the current way that seems to be the only reasonable place to
do it.  Pushing it into ->writepage also has the benefit that
filesystems could piggy back the ctime update onto the transaction that
updates the extent tree.

