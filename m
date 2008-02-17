From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 2/7] fs/ext{2,3,4}: Use BUG_ON
Date: Sun, 17 Feb 2008 15:33:49 -0500
Message-ID: <20080217203349.GH8905@mit.edu>
References: <Pine.LNX.4.64.0802171854270.28055@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sct@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60737 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYBQUen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Feb 2008 15:34:43 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802171854270.28055@ask.diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 17, 2008 at 06:55:06PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.

Hi, in the future, please separate ext4 changes from ext2/3.  Thanks!!

       	   	   	  	   - Ted
