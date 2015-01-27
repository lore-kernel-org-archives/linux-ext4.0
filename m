From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/54] tune2fs: call out to resize2fs for 64bit conversion
Date: Tue, 27 Jan 2015 11:31:10 -0500
Message-ID: <20150127163110.GK2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073644.13308.74437.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35395 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbbA0QbS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:31:18 -0500
Content-Disposition: inline
In-Reply-To: <20150127073644.13308.74437.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:44PM -0800, Darrick J. Wong wrote:
> If the user tries to enable or disable the 64bit feature via tune2fs,
> tell them how to use resize2fs to effect the conversion.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, although I changed to patch summary to read "direct user to
resize2fs..."

Thanks!!

						- Ted
