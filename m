From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How should e2fsck clear s_errno/j_errno on an ro mount?
Date: Mon, 23 Jul 2012 15:14:10 -0400
Message-ID: <20120723191410.GB783@thunk.org>
References: <5009E62E.3020608@redhat.com>
 <20120721003953.GA9399@thunk.org>
 <500D7BCB.2060806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40780 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2GWTON (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2012 15:14:13 -0400
Content-Disposition: inline
In-Reply-To: <500D7BCB.2060806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> nWell, I tested e2fsprogs from git and saw the same trouble.  Let me
> look more closely at that commit.

Hmm, would it be possible to send me /tmp/loop3.qcow.bz2 after running:

     e2image -Q /dev/loop3 /tmp/loop3.qcow
     bzip2 /tmp/loop3.qcow

Regardless of what the problem ends up being, this looks like
something for our regression test suite....

					- Ted
