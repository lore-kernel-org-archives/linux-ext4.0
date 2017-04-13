From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e4crypt: fix error handling for KEYCTL_GET_KEYRING_ID
Date: Thu, 13 Apr 2017 11:44:57 -0400
Message-ID: <20170413154457.qjxfbbnnhwj23xnn@thunk.org>
References: <1491238370-30906-1-git-send-email-joerichey94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>
To: Joe Richey <joerichey94@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34214 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751518AbdDMPo7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Apr 2017 11:44:59 -0400
Content-Disposition: inline
In-Reply-To: <1491238370-30906-1-git-send-email-joerichey94@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 03, 2017 at 04:52:50PM +0000, Joe Richey wrote:
> From: Joe Richey <joerichey@google.com>
> 
> Due to some interesting behaviour in keyctl (as described in the
> comments), we use KEYCTL_GET_KEYRING_ID to translate the special value
> of KEY_SPEC_SESSION_KEYRING to a real keyring id. However, how we
> currently do this is flawed in two ways.
> 
> First, if KEYCTL_GET_KEYRING_ID fails, we don't detect it as it returns
> -1 and zero is used for an error value in get_keyring_id. Second, if the
> user specifies "-k @s" the translation never runs and the undesireable
> behavior occurs.
> 
> These are both fixed by doing the translation outside of get_keyring_id.
> 
> Signed-off-by: Joe Richey <joerichey@google.com>

Thanks, applied.

						- Ted
