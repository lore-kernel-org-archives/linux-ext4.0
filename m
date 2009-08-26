From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Buffer state bits
Date: Wed, 26 Aug 2009 22:27:00 +0100
Message-ID: <20090826212700.GB691@shareable.org>
References: <20090826200021.GA5716@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:55672 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZHZV1A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 17:27:00 -0400
Content-Disposition: inline
In-Reply-To: <20090826200021.GA5716@duck.novell.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> BH_Dirty
> - Ideally, this bit should mean "buffer has data that have to be
>   written". But it is not quite true. The problem happens when
>   someone calls set_page_dirty() on the page to which buffers are
>   attached or similarly when buffers are attached to a dirty
>   page. Then all buffers attached to the page are marked dirty -
>   even those that are beyond end of file which obviously should not
>   be written.
> 
>   When buffer is dirty, the page has to be dirty as well (mark
>   buffer dirty takes care of that). It is not necessarily the other
>   way around and buffer dirty bit is what ultimately decides whether
>   the buffer goes to disk or not.

That last sentence implies page can be dirty while a buffer in the
page is not dirty.

In that case, do buffers beyond the end of file need to be set dirty
by set_page_dirty()?  If yes, perhaps the text could explain why.

-- Jamie
