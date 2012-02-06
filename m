From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Date: Mon, 06 Feb 2012 15:47:37 -0600
Message-ID: <4F304A79.8050004@redhat.com>
References: <4F2D8F30.3090802@redhat.com> <20120206214132.GA22019@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab2BFVrm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 16:47:42 -0500
In-Reply-To: <20120206214132.GA22019@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/6/12 3:41 PM, Ted Ts'o wrote:
> Cool!  I assume you're going to try to get this into util-linux-ng?
> 
> I'm tempted to drop it in e2fsprogs's contrib directxory for now, but
> I think the best home for it is util-linux-ng.
> 
> 							- Ted

Yep, I will do that, though it could use a fair bit of cleanup first.
kzak seemed amenable to taking it in.

-Eric
