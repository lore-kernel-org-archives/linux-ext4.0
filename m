From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/17]fs:jbd Remove one to many n's in a word.
Date: Sun, 27 Feb 2011 17:38:27 -0500
Message-ID: <20110227223826.GK2924@thunk.org>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
 <1298781250-2718-13-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45430 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1B0Xdh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Feb 2011 18:33:37 -0500
Content-Disposition: inline
In-Reply-To: <1298781250-2718-13-git-send-email-justinmattock@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 26, 2011 at 08:34:05PM -0800, Justin P. Mattock wrote:
> The Patch below removes one to many "n's" in a word.. 
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org> 
> CC: Jan Kara <jack@suse.cz> 
> CC: linux-ext4@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
