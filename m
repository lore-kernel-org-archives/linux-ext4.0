From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: Re: next-20141204 crashing on ext4_fill_super()
Date: Sun, 07 Dec 2014 11:58:40 -0200
Message-ID: <2207531.PyHK0LI72j@laptop>
References: <2144577.XOl86X9GoH@laptop> <20141206221621.GB27484@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:40207 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLGN6q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2014 08:58:46 -0500
In-Reply-To: <20141206221621.GB27484@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday, December 06, 2014 05:16:21 PM Theodore Ts'o wrote:
> Please revert fdfe07398761 and that should the crashes; this will be
> fixed in the next linux-next release.  My apologies for the inconvenience.
> 
>       	     	  	     	       	  	    - Ted
Hello, Ted.

Reverting that commit worked.  No need to apologize.

Thanks a lot for the quick reply.

-- 
Murilo
