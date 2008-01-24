From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/49] Add buffer head related helper functions
Date: Thu, 24 Jan 2008 00:53:30 -0800
Message-ID: <20080124005330.b736f89d.akpm@linux-foundation.org>
References: <1200970948-17903-16-git-send-email-tytso@mit.edu>
	<1200970948-17903-17-git-send-email-tytso@mit.edu>
	<1200970948-17903-18-git-send-email-tytso@mit.edu>
	<1200970948-17903-19-git-send-email-tytso@mit.edu>
	<1200970948-17903-20-git-send-email-tytso@mit.edu>
	<1200970948-17903-21-git-send-email-tytso@mit.edu>
	<1200970948-17903-22-git-send-email-tytso@mit.edu>
	<1200970948-17903-23-git-send-email-tytso@mit.edu>
	<1200970948-17903-24-git-send-email-tytso@mit.edu>
	<20080123140648.788fbc49.akpm@linux-foundation.org>
	<20080124052227.GA7902@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@MIT.EDU, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbYAXIy1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2008 03:54:27 -0500
In-Reply-To: <20080124052227.GA7902@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, 24 Jan 2008 10:52:27 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> + * Returns zero on success and -EIO on error.If the input
> + * buffer is not locked returns -EINVAL
> + *
> + */
> +int bh_submit_read(struct buffer_head *bh)
> +{
> +	if (!buffer_locked(bh))
> +		return -EINVAL;

Is this case just catching a programming bug?

If so, a plain old BUG_ON would be better.
