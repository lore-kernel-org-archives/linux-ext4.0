From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fixed error handling in e4crypt
Date: Sat, 1 Apr 2017 12:24:19 -0400
Message-ID: <20170401162419.sl4keqsb53zll6wf@thunk.org>
References: <1490042076-25845-1-git-send-email-joerichey94@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>
To: Joe Richey <joerichey94@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47974 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdDAQY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 1 Apr 2017 12:24:27 -0400
Content-Disposition: inline
In-Reply-To: <1490042076-25845-1-git-send-email-joerichey94@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 20, 2017 at 08:34:36PM +0000, Joe Richey wrote:
> +	if (keyring_id == KEY_SPEC_SESSION_KEYRING) {
> +		keyring_id = keyctl(KEYCTL_GET_KEYRING_ID, keyring_id, 0);
> +		if (keyring_id < 0)
> +			printf("Could not get session keyring.\n");
> +	}
>  	rc = add_key(EXT2FS_KEY_TYPE_LOGON, key_ref_full, (void *)&key,
>  		     sizeof(key), keyring_id);

Are you sure this is right?  If keyring_id is negative, we'll print
the warning/error message --- and then pass the negative keyring_id to
add_key.  Is that going to do the right thing?

	     	  	      	  	- Ted
