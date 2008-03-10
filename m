From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: jbd/2: eliminate code duplication and gracefully handle cache
 initialisation failure
Date: Mon, 10 Mar 2008 12:46:28 -0700
Message-ID: <20080310124628.44a62466.akpm@linux-foundation.org>
References: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, tytso@mit.edu, sct@redhat.com,
	adilger@clusterfs.com, duaneg@dghda.com
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYCJTrT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Mar 2008 15:47:19 -0400
In-Reply-To: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  8 Mar 2008 18:37:33 +0000
"Duane Griffin" <duaneg@dghda.com> wrote:

>  fs/jbd/journal.c  |  149 +++++++++++++++++++++++-------------------------
>  fs/jbd/revoke.c   |  164 +++++++++++++++++++++++------------------------------
>  fs/jbd2/journal.c |  154 ++++++++++++++++++++++++-------------------------
>  fs/jbd2/revoke.c  |  164 +++++++++++++++++++++++------------------------------
>  4 files changed, 291 insertions(+), 340 deletions(-)
> 
> This is version 2 of the jdb/2 patches to eliminate code duplication and
> gracefully handle cace initialisation failure.
> 

I couldn't get these to apply and I didn't understand the relationship
between these new patches and your earlier
jbd[2]-replace-potentially-false-assertion-with-if-block.patch and
jbd[2]-only-create-debugfs-entries-if-cache-initialisation-is-successful.patch
so I just dropped everything.

Please redo and resend against next -mm or
http://userweb.kernel.org/~akpm/mmotm/, thanks.
