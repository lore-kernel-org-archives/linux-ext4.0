Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CB9C10F08
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 18:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3349121841
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550687785;
	bh=yyDVto/5qGBteLMWT92Jqi7x2n0brJDILjRi/mEhxKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MniIZUJcVGCq2a7zMf5jB3wLPi8sYtFZk8Hyk1AHHp/lfY2mmLYamRJAs9D1dNI9W
	 Aht34yjBc8p1BBlDjsv3NsfmSdBMJGqavwFBUqnfOU955iBeAsbYZv4h/eHItWnDYY
	 ZWFluLiyJmhUuN8Us5HzxlPBqnTr5E5kPs3mdyJ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfBTSgX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfBTSgX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 13:36:23 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BD5F2146E;
        Wed, 20 Feb 2019 18:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550687782;
        bh=yyDVto/5qGBteLMWT92Jqi7x2n0brJDILjRi/mEhxKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYJU8vZf6BazayR2FnpgVdjIvZbnxDnnYgPiuCH+AQCJ+UYyHGeC81qpgcOegIACh
         w3DRQBAGcB8AeqFtEbZBszvA4P3ddEU8wpLz0wHx6BrIIGSAWC5Yt1pbKMg1xZB3ho
         yN5xqDY7gf0c7nVCUNxAK6QoxIw1D+X1UGfhEW1Q=
Date:   Wed, 20 Feb 2019 10:36:20 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        linux-api@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 00/18] fscrypt: key management improvements
Message-ID: <20190220183619.GA177939@gmail.com>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <14023.1550686042@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14023.1550686042@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi David,

On Wed, Feb 20, 2019 at 06:07:22PM +0000, David Howells wrote:
> I have a couple of patches that add ACLs to keyrings, that you can find at the
> top of the branch here:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-acl
> 
> I have other patches that allow tags to be used as subjects in the ACL, with a
> container supplying a tag, e.g.:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/commit/?h=container&id=e0fdc5613a32b9475b025f58e7a2267329b3f3a4
> 
> Might something similar be of use to you here, perhaps specifying a tag
> referring to the blockdev of interest rather than the container?
> 
> David

I don't think so.  The main point of adding keys directly to the filesystem is
that it's generally inappropriate to apply OS-level access control or
process-based visibility restrictions to fscrypt keys given that:

- The unlocked/locked status of files is already filesystem-level.
- The purpose of encryption is orthogonal to OS-level access control.

The ioctl based interface also makes it *much* easier to implement all the
semantics needed for removing fscrypt keys.

I don't see how key ACLs would be appropriate here, except that key ACLs would
allow userspace to opt-in to fixing the denial of service vulnerability where
keyctl_invalidate() only requires Search permission.  But for fscrypt that's
addressed by my proposal too, and is just one of many problems it addresses.

- Eric
