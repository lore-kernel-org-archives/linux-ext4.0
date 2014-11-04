From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/39] misc: fix broken libmagic interaction with
 plausibility check
Date: Tue, 4 Nov 2014 11:50:02 -0500
Message-ID: <20141104165002.GG30614@thunk.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205701.532.1427.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38333 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaKDQwP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Nov 2014 11:52:15 -0500
Content-Disposition: inline
In-Reply-To: <20141025205701.532.1427.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:57:01PM -0700, Darrick J. Wong wrote:
> If we get as far as calling libmagic, return the correct error code so
> that mkfs asks for confirmation if libmagic finds something and
> doesn't ask if nothing is found.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
