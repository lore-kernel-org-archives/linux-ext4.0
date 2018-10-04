Return-Path: <SRS0=Op7R=MQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37100 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbeJEERd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 5 Oct 2018 00:17:33 -0400
Date: Thu, 4 Oct 2018 17:22:18 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Greg KH <greg@kroah.com>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] jbd2: Fix use after free in jbd2_log_do_checkpoint()
Message-ID: <20181004212218.GF2835@thunk.org>
References: <20181004104640.28326-1-jack@suse.cz>
 <20181004154402.GC6921@kroah.com>
 <20181004160546.GH28384@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004160546.GH28384@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 04, 2018 at 06:05:46PM +0200, Jan Kara wrote:
> 
> OK, ok, will do next time. The full git commit ID is faster to cut-n-paste
> which shows how lazy I'm ;)

No worires, I'll fix that up for you when I apply it.

   	    	     	     	     - Ted
