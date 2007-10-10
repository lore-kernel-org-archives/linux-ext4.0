From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 2/2] move init_ext4_proc() last and add cleanup call exit_ext4_proc()
Date: Tue, 9 Oct 2007 20:34:44 -0400
Message-ID: <20071010003444.GM31713@thunk.org>
References: <20071009055033.145153755@au1.ibm.com> <20071009061102.363619477@au1.ibm.com> <1191946922.12131.26.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: markn@au1.ibm.com, ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42644 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbXJJAev (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2007 20:34:51 -0400
Content-Disposition: inline
In-Reply-To: <1191946922.12131.26.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 09, 2007 at 09:22:02AM -0700, Badari Pulavarty wrote:
> The best way is to make init_ext4_proc() cleanup itself, in case
> of an error. Hmm.. we are not handling proc_mkdir(EXT4_ROOT) 
> failures.

That's actually OK; if proc_root_ext4 is NULL, the procfs routines
should deal just fine.

						- Ted
