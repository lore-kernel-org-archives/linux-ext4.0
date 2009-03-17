From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Mon, 16 Mar 2009 23:07:36 -0500
Message-ID: <49BF2208.2030709@redhat.com>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZCQEHk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 00:07:40 -0400
In-Reply-To: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
> this mode, we force all delayed allocation blocks involved with the
> to-be-commited transaction to be allocated, and then flushed out to
> disk before the transaction is commited.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Just out of curiosity, what is intended to be the default mode?  How do
you envision users choosing between data=ordered vs. data=alloc-on-commit?

Maybe I'm asking whether there's a Documentation/ patch to go with this? :)

-Eric
