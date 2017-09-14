From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC] Ext4 case insensitive proposal
Date: Thu, 14 Sep 2017 19:11:30 -0400
Message-ID: <20170914231130.5t6ndiaortuo42av@thunk.org>
References: <871snrvu3r.fsf@dilma.collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43088 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751392AbdINXLm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Sep 2017 19:11:42 -0400
Content-Disposition: inline
In-Reply-To: <871snrvu3r.fsf@dilma.collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 01, 2017 at 02:57:44AM -0300, Gabriel Krisman Bertazi wrote:
> 
> As a follow-up on the discussions held in this list after Ted's proposal
> on case-insensitive support for ext4 last year, I've implemented a my
> version of it to learn my way through the ext4 code, and to get started
> on the task.  As my goal would be a slightly more complex approach, with
> at least UTF-8 support for lookups, I'd like to hear from you about my
> current implementation and the following proposal, as well as if there
> is anyone currently working on anything like this, so we could
> coordinate efforts.
> 
> Regarding the Unicode proposal (shivers), I am aware of Ben and
> Olaf's proposal from 2014, and I plan to work on top of that to get it
> updated and upstream.
> 
> Please, let me know your thoughts.
> 
> * Current Implementation
> 
> Simple learning experience to get the wheel spinning, based on Ted Ts'o
> initial proposal back in 2016 [1].  It supports ASCII-case folding only
> and doesn't rely on on-disk modifications.

This isn't a complete implementation of my proposal.  In particular
one of the things which is missing is:

   1.  If case-insensitivity is enabled, override the default dcache hash
   and compare operations to ones that are case insensitive in ext4's
   dcache_operations structure.

This is needed so there is a single dcache entry for case-folded file
names.

						- Ted
						
