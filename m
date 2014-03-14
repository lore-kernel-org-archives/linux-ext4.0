From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/49] misc: cppcheck cleanups
Date: Fri, 14 Mar 2014 09:34:27 -0400
Message-ID: <20140314133427.GK8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065540.30585.97622.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41361 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbaCNNea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:34:30 -0400
Content-Disposition: inline
In-Reply-To: <20140311065540.30585.97622.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:40PM -0700, Darrick J. Wong wrote:
> Fix a number of things that cppcheck complains about.  Most of these
> are minor resource leaks and forgotten declarations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
