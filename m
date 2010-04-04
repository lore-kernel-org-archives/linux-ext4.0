From: tytso@mit.edu
Subject: Re: [PATCH 3/3] ext4: symlink must be handled via filesystem
 specific operation
Date: Sun, 4 Apr 2010 16:05:16 -0400
Message-ID: <20100404200516.GJ18524@thunk.org>
References: <1269620996-11400-1-git-send-email-dmonakhov@openvz.org>
 <1269620996-11400-2-git-send-email-dmonakhov@openvz.org>
 <1269620996-11400-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55301 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0DDUFU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Apr 2010 16:05:20 -0400
Content-Disposition: inline
In-Reply-To: <1269620996-11400-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 07:29:56PM +0300, Dmitry Monakhov wrote:
> generic setattr implementation is no longer responsible for
> quota transfer so synlinks must be handled via ext4_setattr.

Added to the ext4 patch queue; I've added a Signed-off-by: for you
Dmitry, per your e-mail to Jan Kara.

(There seems to be some random confused people who think the
Signed-off-by has no legal significance, which is absolutely not true.)

	      	     	   		       - Ted
