From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: Initialize tmp.b_page in generic_block_bmap()
Date: Tue, 4 Jul 2017 22:21:44 -0400
Message-ID: <20170705022144.nccgpxqdeyeg4djy@thunk.org>
References: <1482409815-89034-1-git-send-email-glider@google.com>
 <20170118163220.vbdkcjmkkyjmfqxb@thunk.org>
 <CAG_fn=UEtkQmN3gjn_-1dAf=fRLX0PG7f8GDEHq_7y4B0o3aNw@mail.gmail.com>
 <CAGXu5j+XON=8U7BfS2W_YJZh8=0zfeuAPkds9Q+oXZPzvgvkqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Potapenko <glider@google.com>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47572 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752295AbdGECVs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 4 Jul 2017 22:21:48 -0400
Content-Disposition: inline
In-Reply-To: <CAGXu5j+XON=8U7BfS2W_YJZh8=0zfeuAPkds9Q+oXZPzvgvkqw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 22, 2017 at 10:58:45AM -0700, Kees Cook wrote:
> > any updates on this patch?
> > Looks like it hasn't been landed yet.
> 
> I think the following would be better (pardon any whitespace damage
> via gmail...):
> 

I've applied Kees suggested change to the ext4 git tree.

     	     	  	    	      - Ted
