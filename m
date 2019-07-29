Return-Path: <SRS0=mPdH=V2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B092C76186
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Jul 2019 19:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E02E920C01
	for <linux-ext4@archiver.kernel.org>; Mon, 29 Jul 2019 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564430314;
	bh=MUgzS0F8d9HlQcIKk/AeINedk5YvM3Io6WjGyuY8L/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1+EJoTEwKEcAG7cPCGl5LeEgTe1xEiuPWVX2UDa5nS4y2OVElpqm+ceKc+GLkIKKf
	 jDJuOV4xv7I+m/ps7tWwuGh4XAiotmAlQoGbGtXKthJZYvk1Ibp3uCs90fGoNr8e7T
	 No+UArTm1fY6Q9W2436o+WEkJq60P9fRgWPOGBJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404185AbfG2T6c (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 29 Jul 2019 15:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403841AbfG2T6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Jul 2019 15:58:31 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B93BB204EC;
        Mon, 29 Jul 2019 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430310;
        bh=MUgzS0F8d9HlQcIKk/AeINedk5YvM3Io6WjGyuY8L/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iS8QBHsmz86M34KZIw9nisCR2fm0L+w7kPLmRgKBgKMY9InqdG7s5arcER6e70Hiv
         1m2j+mTH3W8YpqEW3EcAFnbX72omhY6EUmca5vAe644L7pPOodpSDNlZw9817U4/I8
         NeTf0yKRDUJxPPPBQRoViELwNkQzTSRuae1WjtFI=
Date:   Mon, 29 Jul 2019 12:58:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH v7 07/16] fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl
Message-ID: <20190729195827.GF169027@gmail.com>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, linux-api@vger.kernel.org,
        linux-crypto@vger.kernel.org, keyrings@vger.kernel.org,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
References: <20190726224141.14044-1-ebiggers@kernel.org>
 <20190726224141.14044-8-ebiggers@kernel.org>
 <20190728192417.GG6088@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728192417.GG6088@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Jul 28, 2019 at 03:24:17PM -0400, Theodore Y. Ts'o wrote:
> > +
> > +/*
> > + * Try to remove an fscrypt master encryption key.  If other users have also
> > + * added the key, we'll remove the current user's usage of the key, then return
> > + * -EUSERS.  Otherwise we'll continue on and try to actually remove the key.
> 
> Nit: this should be moved to patch #11
> 
> Also, perror(EUSERS) will display "Too many users" which is going to
> be confusing.  I understand why you chose this; we would like to
> distinguish between there are still inodes using this key, and there
> are other users using this key.
> 
> Do we really need to return EUSERS in this case?  It's actually not an
> *error* that other users are using the key.  After all, the unlink(2)
> system call doesn't return an advisory error when you delete a file
> which has other hard links.  And an application which does care about
> this detail can always call FS_IOC_ENCRYPTION_KEY_STATUS() and check
> user_count.
> 

Returning 0 when the key wasn't fully removed might also be confusing.  But I
guess you're right that returning an error doesn't match how syscalls usually
work.  It did remove the current user's usage of the key, after all, rather than
completely fail.  And as you point out, if someone cares about other users
having added the key, they can use FS_IOC_GET_ENCRYPTION_KEY_STATUS.

So I guess I'll change it to 0.

Thanks!

- Eric
