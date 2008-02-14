From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] ext2/3/4: convert byte order of constant instead
 of variable
Date: Thu, 14 Feb 2008 14:20:15 -0800
Message-ID: <20080214142015.f59a9e21.akpm@linux-foundation.org>
References: <20080210101010.GB6737@joi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbYBNWUu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 17:20:50 -0500
In-Reply-To: <20080210101010.GB6737@joi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 10 Feb 2008 11:10:15 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

>  fs/ext2/super.c |    8 +++-----
>  fs/ext3/super.c |    2 +-
>  fs/ext4/super.c |    2 +-

Please don't bundle the filesystem patches in this manner.  I split
it into three patches.

Thanks.
