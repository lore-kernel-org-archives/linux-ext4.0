From: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [PATCH] ext4: fix unbalanced mutex unlock
Date: Thu, 28 Oct 2010 12:04:59 +0200
Message-ID: <20101028120459.2f255b8c@absol.kitzblitz>
References: <20101026011534.0bb7cb64@absol.kitzblitz>
	<20101027205043.GG3194@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50174 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005Ab0J1KGd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 06:06:33 -0400
In-Reply-To: <20101027205043.GG3194@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* "Ted Ts'o" <tytso@mit.edu>:
> On Tue, Oct 26, 2010 at 01:15:34AM +0200, Nicolas Kaiser wrote:
> > Although the mutex isn't locked yet, if ext4_li_request_new
> > fails, the mutex would get unlocked on the error path.

> Nice catch, thanks!!  I've applied a fix to the ext4 patch queue.

Thanks for augmenting the patch - looks good to me :)

Best regards,
Nicolas Kaiser
