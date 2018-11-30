Return-Path: <SRS0=01R6=OJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52602 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbeLAEDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Nov 2018 23:03:14 -0500
Date: Fri, 30 Nov 2018 11:53:17 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH v3 08/12] ext2fs: nls: Support UTF-8 11.0 with NFKD
 normalization
Message-ID: <20181130165317.GC3512@thunk.org>
References: <20181126221949.12172-1-krisman@collabora.com>
 <20181126221949.12172-9-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126221949.12172-9-krisman@collabora.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2018 at 05:19:45PM -0500, Gabriel Krisman Bertazi wrote:
> From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> 
> We need this such that we can do normalization and casefolding
> compatible with the kernel, in order to properly support fsck
> verification and rehashing.
> 
> The UTF-8 11.0 implementation is copied and adapted from the kernel code
> to ensure maximum compatibility.  The decode trie in utf8data.h is
> generated using a script and the UCD sources in the kernel code.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

One more thought.  Is there any test cases we can add here?  I assume
the SGI folks must have had some test code that they used when they
were developing their trie code.  Was any of that released?

Maybe there is some Unicode normalization and case folding test
vectors we can grab?

Thanks,

     		      	   	      	  - Ted
