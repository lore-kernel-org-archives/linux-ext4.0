From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: make local symbol ext4_initxattrs static
Date: Wed, 4 Jan 2012 22:34:28 -0500
Message-ID: <20120105033428.GE24494@thunk.org>
References: <20120104135120.GA12859@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Djalal Harouni <tixxdz@opendz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46187 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab2AEDea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 22:34:30 -0500
Content-Disposition: inline
In-Reply-To: <20120104135120.GA12859@dztty>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 02:51:20PM +0100, Djalal Harouni wrote:
> The ext4_initxattrs symbol is used only in this file, so it should be
> declared static.
> 
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>

Thanks, applied.

					- Ted
