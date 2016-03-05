From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [v3 5/5] Add project ID support for chattr/lsattr
Date: Sat, 5 Mar 2016 12:39:56 -0500
Message-ID: <20160305173956.GA10297@thunk.org>
References: <1452589008-18750-1-git-send-email-lixi@ddn.com>
 <1452589008-18750-6-git-send-email-lixi@ddn.com>
 <20160301042458.GD9772@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35782 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbcCERkD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Mar 2016 12:40:03 -0500
Content-Disposition: inline
In-Reply-To: <20160301042458.GD9772@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 29, 2016 at 11:24:58PM -0500, Theodore Ts'o wrote:
> Hi, this patch is missing the new files for fgetproject.c and
> fsetproject.c.   Can you send them, please?

Hearing nothing, I've come up with my own versions of these two files
and checked in the project ID support into e2fsprogs.

        	       	   	      - Ted
