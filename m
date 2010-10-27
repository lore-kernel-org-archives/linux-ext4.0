From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix unbalanced mutex unlock
Date: Wed, 27 Oct 2010 16:50:43 -0400
Message-ID: <20101027205043.GG3194@thunk.org>
References: <20101026011534.0bb7cb64@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolas Kaiser <nikai@nikai.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51740 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab0J0Uur (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Oct 2010 16:50:47 -0400
Content-Disposition: inline
In-Reply-To: <20101026011534.0bb7cb64@absol.kitzblitz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 26, 2010 at 01:15:34AM +0200, Nicolas Kaiser wrote:
> Although the mutex isn't locked yet, if ext4_li_request_new
> fails, the mutex would get unlocked on the error path.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Nice catch, thanks!!  I've applied a fix to the ext4 patch queue.

     	    	      	   	   - Ted
