From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH, E2FSPROGS] Fix trailing whitespace in
	e2fsck/problem.[ch]
Date: Mon, 31 Mar 2008 20:00:32 -0400
Message-ID: <20080401000032.GF11828@mit.edu>
References: <1207006592-13980-1-git-send-email-tytso@mit.edu> <1207006592-13980-2-git-send-email-tytso@mit.edu> <1207006592-13980-3-git-send-email-tytso@mit.edu> <1207006592-13980-4-git-send-email-tytso@mit.edu> <1207006592-13980-5-git-send-email-tytso@mit.edu> <1207006592-13980-6-git-send-email-tytso@mit.edu> <1207006592-13980-7-git-send-email-tytso@mit.edu> <1207006592-13980-8-git-send-email-tytso@mit.edu> <1207006592-13980-9-git-send-email-tytso@mit.edu> <1207006592-13980-10-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33279 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYDAAAi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 20:00:38 -0400
Content-Disposition: inline
In-Reply-To: <1207006592-13980-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The patch which you sent me had a half-dozen or so random whitespace
fixups in it, but not of them (which numbered around a hundred or so).  

Normally I don't try to fix up white spaces until right before a
release, because it causes merge problems.  But it's relatively easy
to fix up merge problems with problem.c, so I fixed them all up here.

       	  		      		 - Ted
