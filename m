From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ext[234]: Return -EIO not -ESTALE on directory
 traversal
Date: Wed, 24 Jun 2009 15:40:25 -0700
Message-ID: <20090624154025.285e108c.akpm@linux-foundation.org>
References: <4A425F8B.2000907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, bdonlan@gmail.com,
	linux-kernel@vger.kernel.org
To: Karl Beldan <karl.beldan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbZFXWky (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 18:40:54 -0400
In-Reply-To: <4A425F8B.2000907@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Jun 2009 19:16:59 +0200
Karl Beldan <karl.beldan@gmail.com> wrote:

> Hi,
> 
> e6f009b for ext4,
> de18f3b for ext3.
> 
> It seems that ext2 didn't get it.
> 

hm, well spotted.  I seem to have fumbled that patch.  I'll send it in
for 2.6.31.

