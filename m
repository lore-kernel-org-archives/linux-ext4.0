From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Remove redundant unlikely()
Date: Sun, 19 Dec 2010 21:39:59 -0500
Message-ID: <20101220023959.GA24990@thunk.org>
References: <1291905638-32410-1-git-send-email-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Tobias Klauser <tklauser@distanz.ch>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59652 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0LTCkH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Dec 2010 21:40:07 -0500
Content-Disposition: inline
In-Reply-To: <1291905638-32410-1-git-send-email-tklauser@distanz.ch>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 09, 2010 at 04:40:38AM -0000, Tobias Klauser wrote:
> IS_ERR() already implies unlikely(), so it can be omitted here.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Thanks, added to ext4 patch queue.

					- Ted
