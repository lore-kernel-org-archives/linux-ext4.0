From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix off-by-one on max nr_pages in
 ext4_find_unwritten_pgoff()
Date: Wed, 24 May 2017 18:03:40 -0400
Message-ID: <20170524220340.nf65pp6u3p7vi7f2@thunk.org>
References: <20170521080026.20986-1-eguan@redhat.com>
 <20170523083432.GE1230@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <eguan@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34932 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164318AbdEXWDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 May 2017 18:03:44 -0400
Content-Disposition: inline
In-Reply-To: <20170523083432.GE1230@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 23, 2017 at 10:34:32AM +0200, Jan Kara wrote:
> > Cc: stable@vger.kernel.org # v3.7+
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> 
> Yeah, thanks for fixing this! Actually this is a bug introduced by my
> recent fixes. Previously, 'end' used to be "one block after the end" and so
> the math worked out correctly :-|. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.  (And I've dropped the Cc: stable)

		       	    	    	    - Ted
