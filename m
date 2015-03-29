From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 20/54] e2fsck: add a 'yes to all' response in interactive
 mode
Date: Sat, 28 Mar 2015 22:54:56 -0400
Message-ID: <20150329025456.GB19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073744.13308.73411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38532 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbC2Cy6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2015 22:54:58 -0400
Content-Disposition: inline
In-Reply-To: <20150127073744.13308.73411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:44PM -0800, Darrick J. Wong wrote:
> Provide a mechanism for a user to switch fsck into '-y' mode if they
> start an interactive session and then get tired of pressing 'y' in
> response to numerous prompts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.  (Actually, this was applied a while ago, but I
didn't ack it apparently.)

					- Ted
					
