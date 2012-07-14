From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: rename "bool" variables
Date: Sat, 14 Jul 2012 19:43:54 -0400
Message-ID: <20120714234354.GA31952@thunk.org>
References: <1341539060-97676-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39185 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab2GOQPY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jul 2012 12:15:24 -0400
Content-Disposition: inline
In-Reply-To: <1341539060-97676-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 05, 2012 at 07:44:20PM -0600, Andreas Dilger wrote:
> Since "bool" is a valid C type, declarations of the form "int bool"
> will cause compiler errors if <stdbool.h> is included.  Rename these
> variables to avoid this name clash.
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

						- Ted
