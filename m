From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: respect quota config option
Date: Wed, 28 Nov 2012 23:03:41 -0500
Message-ID: <20121129040341.GB8029@thunk.org>
References: <50B504C4.6090504@redhat.com>
 <50B50804.6020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Bert.Deknuydt@esat.kuleuven.be
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35633 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422637Ab2K2EDp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 23:03:45 -0500
Content-Disposition: inline
In-Reply-To: <50B50804.6020309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:35:48PM -0600, Eric Sandeen wrote:
> If we haven't turned --enable-quota on at config time,
> I don't think tune2fs should know about the feature either.

Agreed.  Thanks, applied.

						- Ted
