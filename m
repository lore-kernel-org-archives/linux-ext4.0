Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40302 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbeK2DMr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 22:12:47 -0500
Date: Wed, 28 Nov 2018 11:10:33 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Rainer Fiebig <jrf@mailbox.org>
Cc: linux-kernel@vger.kernel.org,
        "Andrey Jr. Melnikov" <temnota.am@gmail.com>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
Message-ID: <20181128161033.GH31885@thunk.org>
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org>
 <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2547416.7Vy7A2kRpU@siriux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2018 at 04:56:51PM +0100, Rainer Fiebig wrote:
> 
> If you still see the errors, at least the Ubuntu-kernel could be ruled out.

My impression is that some of the people reporting problems have been
using stock upstream kernels, so I wasn't really worried about the
Ubuntu kernel (although it could be something about the default
configs that Ubuntu sets up).  What I was more wondering was whether
there was something about userspace or default configs of Ubuntu.
This isn't necessarily a *problem* per se; for examople, not that long
ago some users were getting surprised when a problem showed up with an
older version of the LVM2 userspace with newer upstream kernels.
After a while, you learn to get super paranoid about making sure to
rule out all possibilities when trying to debug problems that are only
hitting a set of users.

						- Ted
