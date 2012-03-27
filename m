From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Tue, 27 Mar 2012 03:31:28 -0400
Message-ID: <20120327073128.GA974@infradead.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
 <201203270533.q2R5Xl42031625@bugzilla.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46956
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756740Ab2C0Hb3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 03:31:29 -0400
Content-Disposition: inline
In-Reply-To: <201203270533.q2R5Xl42031625@bugzilla.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 27, 2012 at 05:33:47AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=42986
> 
> 
> 
> 
> 
> --- Comment #8 from H. Peter Anvin <hpa@zytor.com>  2012-03-27 05:33:47 ---
> That's fine, but it's also a gratuitous change to previously working userspace.
>  It sounds like the right thing would be to leave <linux/ext2_fs.h> in place
> exporting only those constants as a backwards compatibility measure.

That's probably a good idea, given how widespread people use the flags.
