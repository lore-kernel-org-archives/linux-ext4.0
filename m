From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled ->
 journaled)
Date: Wed, 30 Apr 2008 10:43:30 -0700
Message-ID: <20080430104330.66c44d4f.akpm@linux-foundation.org>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
	<12095679812452-git-send-email-jack@suse.cz>
	<1209567981639-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761843AbYD3Rnf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 13:43:35 -0400
In-Reply-To: <1209567981639-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 30 Apr 2008 17:06:15 +0200
Jan Kara <jack@suse.cz> wrote:

> -					"EXT3-fs: Cannot change journalled "
> +					"EXT3-fs: Cannot change journaled "

hrm, who said?

Dictionary.com recognises neither.

google(journalled) = 520,000
google(journaled) = 652,000

akpm:/usr/src/25> grep journalled fs/ext3/*.c|wc -l
17
akpm:/usr/src/25> grep journaled fs/ext3/*.c|wc -l 
6


