From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: Check for encryption feature before
 fscrypt_process_policy()
Date: Fri, 23 Sep 2016 14:56:54 -0700
Message-ID: <20160923215654.GB106495@google.com>
References: <1474527054-24207-1-git-send-email-richard@nod.at>
 <20160922194931.GA53380@google.com>
 <20160922223803.ggz2qodtqtht7oot@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, david@sigma-star.at, jaegeuk@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33056 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934834AbcIWV5D (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2016 17:57:03 -0400
Received: by mail-pf0-f180.google.com with SMTP id 21so45800288pfy.0
        for <linux-ext4@vger.kernel.org>; Fri, 23 Sep 2016 14:57:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160922223803.ggz2qodtqtht7oot@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 22, 2016 at 06:38:03PM -0400, Theodore Ts'o wrote:
> 
> I think it's fine to fix it now in upstream.  It might cause some
> problems for Cyanogen developers if they want to try to use an
> upstream kernel and also enable the ext4 encryption feature, but the
> fix to make_ext4fs isn't all that hard.

Would it make sense to at least provide a helpful error message in the kernel
log?  For example:

		if (!ext4_has_feature_encrypt(sb)) {
			ext4_msg(sb, KERN_INFO,
				 "warning: process `%s' tried to set "
				 "encryption policy on filesystem without "
				 "encryption enabled.  This is not supported.  "
				 "Use 'tune2fs -O encrypt' to enable the "
				 "encryption feature flag first.",
				 current->comm);
			return -EOPNOTSUPP;
		}

Eric
