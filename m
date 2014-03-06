From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] jbd2: don't write non-commit blocks synchronously
Date: Thu, 6 Mar 2014 13:27:29 -0500
Message-ID: <20140306182729.GA30706@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140306135642.GA22136@thunk.org>
 <20140306172801.GA12751@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38067 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbaCFS1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 13:27:39 -0500
Content-Disposition: inline
In-Reply-To: <20140306172801.GA12751@xanadu.blop.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hmm... OK, let me make sure I understand what is going on.  So you
have a single file system which is mounted read/write, and you are
doing a huge number of copies into the file system, which is keeping
it busy.  You are then running a huge number of "mount -o remount" on
that same file system, which should effectively be no-op's, since the
remount isn't actually change the read/only or read/write or any other
mount options.  Is that right?

Why were you doing the remount in in your actual production workload,
anyway?

						- Ted
