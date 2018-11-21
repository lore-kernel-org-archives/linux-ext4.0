Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33628 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbeKUPdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 21 Nov 2018 10:33:36 -0500
Date: Wed, 21 Nov 2018 00:00:43 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs 5/9] chattr/lsattr: Support casefold attribute
Message-ID: <20181121050043.GB26006@thunk.org>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
 <20181015211220.27370-6-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181015211220.27370-6-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 05:12:16PM -0400, Gabriel Krisman Bertazi wrote:
> This flag can be set on directories to request insensitive file name
> lookupus.
> 
> I used the letter 'F', referring to "caseFold" for lack of a better
> option.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Could you include an update to the chattr man page?  Thanks!

      	  	     	       	   - Ted
